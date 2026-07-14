package main

import (
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"flag"
	"fmt"
	"io"
	"os"
	"strings"
)

const (
	expectedRunID       = "RUN_01_OPTION_A_SYNTHETIC_GAP_TEST"
	expectedLineageHash = "345138cc9c92352a73fe20dbfe6785cb1ddfd799fd0e54b8e42161c3dc3b1429"
	expectedBasis       = "VALUE_CONTROL_OVERLAP_RECORDED"
)

type statusNode struct {
	Status string `json:"status"`
}

type receiptState struct {
	Missing        bool `json:"missing"`
	Contradictions bool `json:"contradictions"`
}

type timeWindow struct {
	Start string `json:"start"`
	End   string `json:"end"`
}

type vector struct {
	RunID             string       `json:"run_id"`
	PacketType        string       `json:"packet_type"`
	SyntheticOnly     bool         `json:"synthetic_only"`
	LineageHash       string       `json:"lineage_hash"`
	IntersectionBasis string       `json:"intersection_basis"`
	TimeWindow        timeWindow   `json:"time_window"`
	Left              statusNode   `json:"left"`
	Right             statusNode   `json:"right"`
	Receipts          receiptState `json:"receipts"`
}

type result struct {
	Result          string `json:"result"`
	MaxState        string `json:"max_state"`
	ProgressionToL3 bool   `json:"progression_to_l3"`
}

func fail(message string) {
	fmt.Fprintln(os.Stderr, message)
	os.Exit(1)
}

func selfHash() string {
	path, err := os.Executable()
	if err != nil {
		fail("SELF_HASH_ERROR")
	}
	f, err := os.Open(path)
	if err != nil {
		fail("SELF_HASH_ERROR")
	}
	defer f.Close()

	h := sha256.New()
	if _, err := io.Copy(h, f); err != nil {
		fail("SELF_HASH_ERROR")
	}
	return hex.EncodeToString(h.Sum(nil))
}

func validL2Basis(v vector) bool {
	if strings.TrimSpace(v.IntersectionBasis) != expectedBasis {
		return false
	}
	start := strings.TrimSpace(v.TimeWindow.Start)
	end := strings.TrimSpace(v.TimeWindow.End)
	return start != "" && end != "" && start < end
}

func main() {
	syntheticOnly := flag.Bool("synthetic-only", false, "required safety gate")
	vectorPath := flag.String("vector", "", "path to synthetic test vector")
	flag.Parse()

	if !*syntheticOnly {
		fail("PROD_INJECTION_BLOCKED")
	}
	if *vectorPath == "" {
		fail("VECTOR_REQUIRED")
	}

	fmt.Printf("SELF_HASH=%s\n", selfHash())

	data, err := os.ReadFile(*vectorPath)
	if err != nil {
		fail("VECTOR_READ_FAILED")
	}

	var v vector
	if err := json.Unmarshal(data, &v); err != nil {
		fail("VECTOR_PARSE_FAILED")
	}

	if !v.SyntheticOnly || v.PacketType != "SYNTHETIC_STRESS_TEST" {
		fail("PROD_INJECTION_BLOCKED")
	}
	if v.RunID != expectedRunID {
		fail("RUN_ID_MISMATCH")
	}
	if v.LineageHash != expectedLineageHash {
		fail("LINEAGE_HASH_MISMATCH")
	}
	if !validL2Basis(v) {
		fail("L2_INTERSECTION_EVIDENCE_REQUIRED")
	}

	mustHalt := v.Left.Status != "SUPPORTED" ||
		v.Right.Status != "SUPPORTED" ||
		v.Receipts.Missing ||
		v.Receipts.Contradictions

	if !mustHalt {
		fail("L3_PATH_REACHED")
	}

	out := result{
		Result:          "PARTIAL_TRACE_GAP",
		MaxState:        "L-2",
		ProgressionToL3: false,
	}

	encoded, err := json.Marshal(out)
	if err != nil {
		fail("OUTPUT_ENCODE_FAILED")
	}

	expected := `{"result":"PARTIAL_TRACE_GAP","max_state":"L-2","progression_to_l3":false}`
	if string(encoded) != expected {
		fail("ACCEPTANCE_OUTPUT_MISMATCH")
	}

	fmt.Println(string(encoded))
}
