package targets

import (
	"errors"
	"os"
	"path/filepath"
	"sort"
	"strings"
)

// The markers around the block aa init keeps in a project's instruction file. Everything outside
// them belongs to the project and is never changed (decision record 0014).
const (
	blockBegin = "<!-- aa-sdlc:begin -->"
	blockEnd   = "<!-- aa-sdlc:end -->"
)

// InstructionFiles returns the distinct instruction files the harnesses read, sorted.
func InstructionFiles(harnesses []Spec) []string {
	seen := map[string]bool{}
	var files []string
	for _, t := range harnesses {
		if t.Instructions != "" && !seen[t.Instructions] {
			seen[t.Instructions] = true
			files = append(files, t.Instructions)
		}
	}
	sort.Strings(files)
	return files
}

// WriteInstructionBlock puts body between the markers in repo/file: it replaces an existing block,
// or appends one after the file's own text, or creates the file. It reports whether the file
// changed.
func WriteInstructionBlock(repo, file, body string) (bool, error) {
	path := filepath.Join(repo, filepath.FromSlash(file))
	block := blockBegin + "\n" + strings.TrimRight(body, "\n") + "\n" + blockEnd + "\n"
	old, err := os.ReadFile(path)
	if err != nil && !errors.Is(err, os.ErrNotExist) {
		return false, err
	}
	text := string(old)
	var updated string
	start := strings.Index(text, blockBegin)
	end := strings.Index(text, blockEnd)
	switch {
	case start >= 0 && end > start:
		rest := text[end+len(blockEnd):]
		rest = strings.TrimPrefix(strings.TrimPrefix(rest, "\r"), "\n")
		updated = text[:start] + block + rest
	case strings.TrimSpace(text) == "":
		updated = block
	default:
		updated = strings.TrimRight(text, "\n") + "\n\n" + block
	}
	if updated == text {
		return false, nil
	}
	return true, os.WriteFile(path, []byte(updated), 0o644)
}

// RemoveInstructionBlock takes the marked block out of repo/file, leaving the rest as it was, and
// deletes the file if the block was all it held. It reports whether the file changed.
func RemoveInstructionBlock(repo, file string) (bool, error) {
	path := filepath.Join(repo, filepath.FromSlash(file))
	old, err := os.ReadFile(path)
	if errors.Is(err, os.ErrNotExist) {
		return false, nil
	}
	if err != nil {
		return false, err
	}
	text := string(old)
	start := strings.Index(text, blockBegin)
	end := strings.Index(text, blockEnd)
	if start < 0 || end < start {
		return false, nil
	}
	rest := strings.TrimPrefix(strings.TrimPrefix(text[end+len(blockEnd):], "\r"), "\n")
	updated := strings.TrimRight(text[:start], "\n")
	if updated != "" && strings.TrimSpace(rest) != "" {
		updated += "\n\n" + rest
	} else if updated != "" {
		updated += "\n"
	} else {
		updated = rest
	}
	if strings.TrimSpace(updated) == "" {
		return true, os.Remove(path)
	}
	return true, os.WriteFile(path, []byte(updated), 0o644)
}
