package main

import (
	"encoding/json"
	"errors"
	"fmt"
	"os"
	"path/filepath"
	"strings"
)

type EvidenceRole string

const (
	AssertionSource          EvidenceRole = "ASSERTION_SOURCE"
	ReviewContext            EvidenceRole = "REVIEW_CONTEXT"
	ClassifierImplementation EvidenceRole = "CLASSIFIER_IMPLEMENTATION"
	CommitContext             EvidenceRole = "COMMIT_CONTEXT"
)

const (
	roleSchema       = "JQG50_EVIDENCE_ROLE_V1"
	roleScope        = "FILE_CONTENT_ONLY"
	reviewPathPrefix = "phase3/anomaly-review/"
	classifierPrefix = "phase3/audit-matrix/"
)

type RoleDeclaration struct {
	Schema              string       `json:"schema"`
	Artifact            string       `json:"artifact"`
	ArtifactRole        EvidenceRole `json:"artifact_role"`
	AssertsSubjectState bool         `json:"asserts_subject_state"`
	RoleScope           string       `json:"role_scope"`
	Authority           bool         `json:"authority"`
}

type EvidenceFragment struct {
	Commit string
	Path   string
	Role   EvidenceRole
	Text   string
}

type TriggerObservation struct {
	Path        string
	Role        EvidenceRole
	Trigger     string
	IsAssertion bool
}

func structuralRole(path string) EvidenceRole {
	switch {
	case strings.HasPrefix(path, classifierPrefix):
		return ClassifierImplementation
	case strings.HasPrefix(path, reviewPathPrefix):
		return ReviewContext
	default:
		return AssertionSource
	}
}

func validateRoleDeclaration(path string, declaration RoleDeclaration) error {
	if declaration.Schema != roleSchema {
		return errors.New("ROLE_SCHEMA_MISMATCH")
	}
	if declaration.Artifact != path {
		return errors.New("ROLE_ARTIFACT_PATH_MISMATCH")
	}
	if declaration.ArtifactRole != ReviewContext {
		return errors.New("ROLE_ENUM_NOT_ALLOWED")
	}
	if declaration.AssertsSubjectState {
		return errors.New("ROLE_ASSERTS_SUBJECT_STATE_TRUE")
	}
	if declaration.RoleScope != roleScope {
		return errors.New("ROLE_SCOPE_MISMATCH")
	}
	if declaration.Authority {
		return errors.New("ROLE_AUTHORITY_TRUE")
	}
	return nil
}

// resolveEvidenceRole applies the current, versioned policy registry to a
// historical artifact path. Paths only nominate REVIEW_CONTEXT; a valid
// sidecar in the current policy tree authorizes it. Missing or malformed
// declarations fail closed to ASSERTION_SOURCE.
func resolveEvidenceRole(repo, path string) (EvidenceRole, bool) {
	candidate := structuralRole(path)
	if candidate == ClassifierImplementation {
		return ClassifierImplementation, true
	}
	if candidate != ReviewContext {
		return AssertionSource, true
	}

	sidecarPath := filepath.Join(repo, filepath.FromSlash(path+".meta.json"))
	data, err := os.ReadFile(sidecarPath)
	if err != nil {
		return AssertionSource, false
	}
	var declaration RoleDeclaration
	if err := json.Unmarshal(data, &declaration); err != nil {
		return AssertionSource, false
	}
	if err := validateRoleDeclaration(path, declaration); err != nil {
		return AssertionSource, false
	}
	return ReviewContext, true
}

func collectEvidenceFragments(repo, commit string) []EvidenceFragment {
	fragments := []EvidenceFragment{{
		Commit: commit,
		Path:   "<commit-metadata>",
		Role:   CommitContext,
		Text:   gitRead(repo, "show", "--no-patch", "--format=fuller", commit),
	}}

	filesRaw := gitRead(repo, "diff-tree", "--root", "--no-commit-id", "--name-only", "-r", commit)
	for _, line := range strings.Split(filesRaw, "\n") {
		path := strings.TrimSpace(line)
		if path == "" {
			continue
		}
		role, _ := resolveEvidenceRole(repo, path)
		text := gitRead(repo, "show", "--no-ext-diff", "--format=", "--unified=0", commit, "--", path)
		fragments = append(fragments, EvidenceFragment{
			Commit: commit,
			Path:   path,
			Role:   role,
			Text:   text,
		})
	}
	return fragments
}

func voidTriggerObservations(fragments []EvidenceFragment) []TriggerObservation {
	observations := []TriggerObservation{}
	for _, fragment := range fragments {
		lower := strings.ToLower(fragment.Text)
		for _, trigger := range []string{
			`"content_independently_verified": false`,
			"e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
		} {
			if strings.Contains(lower, trigger) {
				observations = append(observations, TriggerObservation{
					Path:        fragment.Path,
					Role:        fragment.Role,
					Trigger:     trigger,
					IsAssertion: fragment.Role == AssertionSource,
				})
			}
		}
	}
	return observations
}

func hasVoidAssertion(fragments []EvidenceFragment) bool {
	for _, observation := range voidTriggerObservations(fragments) {
		if observation.IsAssertion {
			return true
		}
	}
	return false
}

func joinEvidence(fragments []EvidenceFragment) string {
	var joined strings.Builder
	for _, fragment := range fragments {
		fmt.Fprintf(&joined, "\nROLE=%s\nPATH=%s\n%s", fragment.Role, fragment.Path, fragment.Text)
	}
	return joined.String()
}
