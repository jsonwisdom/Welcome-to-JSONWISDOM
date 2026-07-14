package main

import (
	"encoding/csv"
	"flag"
	"fmt"
	"os"
	"os/exec"
	"regexp"
	"sort"
	"strconv"
	"strings"
)

type row struct {
	Commit     string
	MaxState   string
	GapClass   string
	ExitReason string
}

type auditStats struct {
	RoleCounts                  map[EvidenceRole]int
	ReviewContextLiteralCount   int
	ReviewContextVoidPromotions int
}

var (
	sha40        = regexp.MustCompile(`(?i)\b[0-9a-f]{40}\b`)
	declaredRoot = regexp.MustCompile(`(?i)"declared_root_commit"\s*:\s*"([0-9a-f]{40})"`)
	rootExpected = regexp.MustCompile(`(?i)(?:ROOT_EXPECTED=|ROOT=")([0-9a-f]{40})`)
)

func parserFail(msg string) {
	fmt.Fprintln(os.Stderr, msg)
	os.Exit(1)
}

func gitFail(msg string) {
	fmt.Fprintln(os.Stderr, msg)
	os.Exit(2)
}

func gitRead(repo string, args ...string) string {
	full := append([]string{"-C", repo}, args...)
	cmd := exec.Command("git", full...)
	cmd.Env = append(os.Environ(), "GIT_CONFIG_NOSYSTEM=1", "GIT_TERMINAL_PROMPT=0")
	out, err := cmd.CombinedOutput()
	if err != nil {
		gitFail(fmt.Sprintf("GIT_TRAVERSAL_FAILED: %s: %s", strings.Join(args, " "), strings.TrimSpace(string(out))))
	}
	return string(out)
}

func classifyEvidence(fragments []EvidenceFragment, priorRoots map[string]struct{}) (string, string, []string) {
	text := joinEvidence(fragments)
	lower := strings.ToLower(text)
	roots := []string{}
	for _, re := range []*regexp.Regexp{declaredRoot, rootExpected} {
		for _, m := range re.FindAllStringSubmatch(text, -1) {
			if len(m) > 1 {
				roots = append(roots, strings.ToLower(m[1]))
			}
		}
	}

	for _, r := range roots {
		for p := range priorRoots {
			if r != p {
				return "contradictory", "CONFLICTING_ROOT_RECEIPTS", roots
			}
		}
	}

	if hasVoidAssertion(fragments) {
		return "void", "UNVERIFIED_OR_EMPTY_EVIDENCE", roots
	}

	if strings.Contains(lower, `"replaycomplete": true`) &&
		strings.Contains(lower, `"githubverified": true`) &&
		strings.Contains(lower, `"testexecutionobserved": true`) &&
		!strings.Contains(lower, `"replaycomplete": false`) &&
		!strings.Contains(lower, `"githubverified": false`) &&
		!strings.Contains(lower, `"testexecutionobserved": false`) {
		return "clean", "CLEAN_MARKERS_PRESENT_REVIEW_REQUIRED", roots
	}

	if len(sha40.FindAllString(text, -1)) > 0 {
		return "partial", "HASH_OR_REFERENCE_PRESENT_WITHOUT_COMPLETE_RECEIPT_SET", roots
	}

	return "partial", "NO_COMPLETE_RECEIPT_SET_OBSERVED", roots
}

func main() {
	repo := flag.String("repo", ".", "local repository path")
	ref := flag.String("ref", "HEAD", "git ref to audit")
	maxCount := flag.Int("max-count", 50, "maximum commits to audit")
	output := flag.String("output", "JQG-50_PHASE_III_AUDIT_MATRIX.csv", "CSV output path")
	flag.Parse()

	if *maxCount < 1 {
		parserFail("INVALID_MAX_COUNT")
	}

	gitRead(*repo, "rev-parse", "--is-inside-work-tree")
	commitsRaw := gitRead(*repo, "rev-list", "--reverse", "--max-count="+strconv.Itoa(*maxCount), *ref)
	commits := []string{}
	for _, line := range strings.Split(commitsRaw, "\n") {
		commit := strings.TrimSpace(line)
		if commit != "" {
			commits = append(commits, commit)
		}
	}
	if len(commits) == 0 {
		gitFail("NO_COMMITS_OBSERVED")
	}

	stats := auditStats{RoleCounts: map[EvidenceRole]int{}}
	priorRoots := map[string]struct{}{}
	rows := make([]row, 0, len(commits))
	for _, commit := range commits {
		fragments := collectEvidenceFragments(*repo, commit)
		for _, fragment := range fragments {
			stats.RoleCounts[fragment.Role]++
		}
		for _, observation := range voidTriggerObservations(fragments) {
			if observation.Role == ReviewContext {
				stats.ReviewContextLiteralCount++
				if observation.IsAssertion {
					stats.ReviewContextVoidPromotions++
				}
			}
		}

		gapClass, reason, roots := classifyEvidence(fragments, priorRoots)
		for _, r := range roots {
			priorRoots[r] = struct{}{}
		}
		rows = append(rows, row{Commit: commit, MaxState: "L-2", GapClass: gapClass, ExitReason: reason})
	}

	f, err := os.Create(*output)
	if err != nil {
		parserFail("CSV_CREATE_FAILED")
	}
	w := csv.NewWriter(f)
	if err := w.Write([]string{"commit", "max_state", "gap_class", "exit_reason"}); err != nil {
		_ = f.Close()
		parserFail("CSV_HEADER_WRITE_FAILED")
	}
	for _, r := range rows {
		if err := w.Write([]string{r.Commit, r.MaxState, r.GapClass, r.ExitReason}); err != nil {
			_ = f.Close()
			parserFail("CSV_ROW_WRITE_FAILED")
		}
	}
	w.Flush()
	if err := w.Error(); err != nil {
		_ = f.Close()
		parserFail("CSV_FLUSH_FAILED")
	}
	if err := f.Close(); err != nil {
		parserFail("CSV_CLOSE_FAILED")
	}

	counts := map[string]int{}
	for _, r := range rows {
		counts[r.GapClass]++
	}
	keys := []string{"void", "contradictory", "partial", "clean"}
	sort.Strings(keys)
	fmt.Printf("AUDIT_REF=%s\n", *ref)
	fmt.Printf("MAX_COUNT=%d\n", *maxCount)
	fmt.Printf("AUDITED_COMMITS=%d\n", len(rows))
	for _, k := range keys {
		fmt.Printf("GAP_CLASS_%s=%d\n", strings.ToUpper(k), counts[k])
	}
	for _, role := range []EvidenceRole{AssertionSource, ReviewContext, ClassifierImplementation, CommitContext} {
		fmt.Printf("EVIDENCE_ROLE_%s=%d\n", role, stats.RoleCounts[role])
	}
	fmt.Printf("REVIEW_CONTEXT_LITERAL_COUNT=%d\n", stats.ReviewContextLiteralCount)
	fmt.Printf("REVIEW_CONTEXT_VOID_PROMOTIONS=%d\n", stats.ReviewContextVoidPromotions)
	fmt.Printf("ROLE_POLICY_MODE=CURRENT_VERSIONED_SIDECARS_APPLIED_TO_HISTORICAL_PATHS\n")
	fmt.Printf("MAX_STATE_CEILING=L-2\n")
	fmt.Printf("OUTPUT=%s\n", *output)
	fmt.Printf("REPOSITORY_MUTATED=FALSE\n")
	fmt.Printf("AUDIT_COMPLETE=TRUE\n")
}
