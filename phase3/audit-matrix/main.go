package main

import (
	"bufio"
	"encoding/csv"
	"flag"
	"fmt"
	"os"
	"os/exec"
	"regexp"
	"sort"
	"strings"
)

type row struct {
	Commit     string
	MaxState   string
	GapClass   string
	ExitReason string
}

var (
	sha40 = regexp.MustCompile(`(?i)\b[0-9a-f]{40}\b`)
	declaredRoot = regexp.MustCompile(`(?i)"declared_root_commit"\s*:\s*"([0-9a-f]{40})"`)
	rootExpected = regexp.MustCompile(`(?i)(?:ROOT_EXPECTED=|ROOT=")([0-9a-f]{40})`)
)

func fail(msg string) {
	fmt.Fprintln(os.Stderr, msg)
	os.Exit(1)
}

func git(repo string, args ...string) string {
	full := append([]string{"-C", repo}, args...)
	cmd := exec.Command("git", full...)
	cmd.Env = append(os.Environ(), "GIT_CONFIG_NOSYSTEM=1", "GIT_TERMINAL_PROMPT=0")
	out, err := cmd.CombinedOutput()
	if err != nil {
		fail(fmt.Sprintf("GIT_READ_FAILED: %s: %s", strings.Join(args, " "), strings.TrimSpace(string(out))))
	}
	return string(out)
}

func classify(text string, priorRoots map[string]struct{}) (string, string, []string) {
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

	if strings.Contains(lower, `"content_independently_verified": false`) ||
		strings.Contains(lower, "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855") {
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
	rangeSpec := flag.String("range", "HEAD~50..HEAD", "git revision range")
	output := flag.String("output", "JQG-50_PHASE_III_AUDIT_MATRIX.csv", "CSV output path")
	flag.Parse()

	// Read-only repository checks.
	git(*repo, "rev-parse", "--is-inside-work-tree")
	commitsRaw := git(*repo, "rev-list", "--reverse", *rangeSpec)
	commits := []string{}
	scanner := bufio.NewScanner(strings.NewReader(commitsRaw))
	for scanner.Scan() {
		v := strings.TrimSpace(scanner.Text())
		if v != "" {
			commits = append(commits, v)
		}
	}
	if len(commits) == 0 {
		fail("NO_COMMITS_IN_RANGE")
	}

	priorRoots := map[string]struct{}{}
	rows := make([]row, 0, len(commits))
	for _, commit := range commits {
		text := git(*repo, "show", "--no-ext-diff", "--format=fuller", "--unified=0", commit)
		gapClass, reason, roots := classify(text, priorRoots)
		for _, r := range roots {
			priorRoots[r] = struct{}{}
		}

		// Conservative Phase III ceiling: no history row auto-promotes beyond L-2.
		rows = append(rows, row{
			Commit: commit,
			MaxState: "L-2",
			GapClass: gapClass,
			ExitReason: reason,
		})
	}

	f, err := os.Create(*output)
	if err != nil {
		fail("CSV_CREATE_FAILED")
	}
	defer f.Close()
	w := csv.NewWriter(f)
	if err := w.Write([]string{"commit", "max_state", "gap_class", "exit_reason"}); err != nil {
		fail("CSV_WRITE_FAILED")
	}
	for _, r := range rows {
		if err := w.Write([]string{r.Commit, r.MaxState, r.GapClass, r.ExitReason}); err != nil {
			fail("CSV_WRITE_FAILED")
		}
	}
	w.Flush()
	if err := w.Error(); err != nil {
		fail("CSV_FLUSH_FAILED")
	}

	counts := map[string]int{}
	for _, r := range rows {
		counts[r.GapClass]++
	}
	keys := []string{"void", "contradictory", "partial", "clean"}
	sort.Strings(keys)
	fmt.Printf("AUDIT_RANGE=%s\n", *rangeSpec)
	fmt.Printf("AUDITED_COMMITS=%d\n", len(rows))
	for _, k := range keys {
		fmt.Printf("GAP_CLASS_%s=%d\n", strings.ToUpper(k), counts[k])
	}
	fmt.Printf("MAX_STATE_CEILING=L-2\n")
	fmt.Printf("OUTPUT=%s\n", *output)
	fmt.Printf("REPOSITORY_MUTATED=FALSE\n")
}
