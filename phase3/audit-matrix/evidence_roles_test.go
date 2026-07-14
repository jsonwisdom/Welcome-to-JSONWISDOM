package main

import (
	"os"
	"path/filepath"
	"testing"
)

func writeSidecar(t *testing.T, repo, artifact, body string) {
	t.Helper()
	path := filepath.Join(repo, filepath.FromSlash(artifact+".meta.json"))
	if err := os.MkdirAll(filepath.Dir(path), 0o755); err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(path, []byte(body), 0o644); err != nil {
		t.Fatal(err)
	}
}

func validSidecar(artifact string) string {
	return `{"schema":"JQG50_EVIDENCE_ROLE_V1","artifact":"` + artifact + `","artifact_role":"REVIEW_CONTEXT","asserts_subject_state":false,"role_scope":"FILE_CONTENT_ONLY","authority":false}`
}

func TestRoleResolutionFailClosed(t *testing.T) {
	repo := t.TempDir()
	artifact := "phase3/anomaly-review/review.md"

	if role, valid := resolveEvidenceRole(repo, artifact); role != AssertionSource || valid {
		t.Fatalf("missing sidecar: role=%s valid=%v", role, valid)
	}

	writeSidecar(t, repo, artifact, `{malformed`)
	if role, valid := resolveEvidenceRole(repo, artifact); role != AssertionSource || valid {
		t.Fatalf("malformed sidecar: role=%s valid=%v", role, valid)
	}

	cases := []string{
		`{"schema":"WRONG","artifact":"phase3/anomaly-review/review.md","artifact_role":"REVIEW_CONTEXT","asserts_subject_state":false,"role_scope":"FILE_CONTENT_ONLY","authority":false}`,
		`{"schema":"JQG50_EVIDENCE_ROLE_V1","artifact":"wrong.md","artifact_role":"REVIEW_CONTEXT","asserts_subject_state":false,"role_scope":"FILE_CONTENT_ONLY","authority":false}`,
		`{"schema":"JQG50_EVIDENCE_ROLE_V1","artifact":"phase3/anomaly-review/review.md","artifact_role":"UNKNOWN","asserts_subject_state":false,"role_scope":"FILE_CONTENT_ONLY","authority":false}`,
		`{"schema":"JQG50_EVIDENCE_ROLE_V1","artifact":"phase3/anomaly-review/review.md","artifact_role":"REVIEW_CONTEXT","asserts_subject_state":true,"role_scope":"FILE_CONTENT_ONLY","authority":false}`,
		`{"schema":"JQG50_EVIDENCE_ROLE_V1","artifact":"phase3/anomaly-review/review.md","artifact_role":"REVIEW_CONTEXT","asserts_subject_state":false,"role_scope":"FILE_CONTENT_ONLY","authority":true}`,
	}
	for i, body := range cases {
		writeSidecar(t, repo, artifact, body)
		if role, valid := resolveEvidenceRole(repo, artifact); role != AssertionSource || valid {
			t.Fatalf("case %d: role=%s valid=%v", i, role, valid)
		}
	}

	writeSidecar(t, repo, artifact, validSidecar(artifact))
	if role, valid := resolveEvidenceRole(repo, artifact); role != ReviewContext || !valid {
		t.Fatalf("valid sidecar: role=%s valid=%v", role, valid)
	}
}

func TestStructuralRoles(t *testing.T) {
	if role, _ := resolveEvidenceRole(t.TempDir(), "phase3/audit-matrix/main.go"); role != ClassifierImplementation {
		t.Fatalf("classifier role=%s", role)
	}
	if role, _ := resolveEvidenceRole(t.TempDir(), "unknown/data.json"); role != AssertionSource {
		t.Fatalf("unknown role=%s", role)
	}
}

func TestVoidDependsOnRole(t *testing.T) {
	literal := `{"content_independently_verified": false}`
	emptyHash := "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"

	for _, text := range []string{literal, emptyHash} {
		if !hasVoidAssertion([]EvidenceFragment{{Role: AssertionSource, Text: text}}) {
			t.Fatalf("assertion did not trigger VOID: %s", text)
		}
		for _, role := range []EvidenceRole{ReviewContext, ClassifierImplementation, CommitContext} {
			if hasVoidAssertion([]EvidenceFragment{{Role: role, Text: text}}) {
				t.Fatalf("role %s triggered VOID", role)
			}
		}
	}
}
