package tools

import (
	"bytes"
	"errors"
	"strings"
	"testing"

	"aasdlc.com/aa/internal/config"
)

// fakeMachine answers check commands from versions and records the install commands it runs;
// an install makes its tool report want.
type fakeMachine struct {
	versions map[string]string // check command -> what it prints; absent means not found
	ran      []string
	after    map[string][2]string // install command -> {check command, what it prints after}
}

func (m *fakeMachine) run(command string) (string, error) {
	if v, ok := m.versions[command]; ok {
		return v, nil
	}
	if a, ok := m.after[command]; ok {
		m.ran = append(m.ran, command)
		m.versions[a[0]] = a[1]
		return "", nil
	}
	return "", errors.New("not found")
}

func tool(version string) config.Tool {
	return config.Tool{Name: "PowerShell", Category: "shell", Version: version, Check: "pwsh --version", Install: map[string]string{Platform(): "install pwsh"}}
}

func TestAtLeast(t *testing.T) {
	cases := []struct {
		a, b string
		want bool
	}{{"7.6.6", "7.0", true}, {"5.1", "7.0", false}, {"7.0", "7.0", true}, {"10.2", "9.9", true}, {"2.47.1", "2.47.2", false}}
	for _, c := range cases {
		if got := AtLeast(c.a, c.b); got != c.want {
			t.Errorf("AtLeast(%s, %s) = %v, want %v", c.a, c.b, got, c.want)
		}
	}
}

func TestCheck_FoundTooOldAndMissing(t *testing.T) {
	m := &fakeMachine{versions: map[string]string{"pwsh --version": "PowerShell 7.6.6\n"}}
	if r := Check(tool("7.0"), m.run); !r.OK || r.Found != "7.6.6" {
		t.Errorf("want found 7.6.6, got %+v", r)
	}
	if r := Check(tool("8.0"), m.run); r.OK || !strings.Contains(Describe(r), "too old") {
		t.Errorf("want too old, got %s", Describe(r))
	}
	missing := config.Tool{Name: "dotnet", Version: "9.0", Check: "dotnet --version"}
	if r := Check(missing, m.run); r.OK || !strings.Contains(Describe(r), "missing") {
		t.Errorf("want missing, got %s", Describe(r))
	}
}

func TestEnsure_InstallsOnlyWithConsent(t *testing.T) {
	newMachine := func() *fakeMachine {
		return &fakeMachine{versions: map[string]string{}, after: map[string][2]string{"install pwsh": {"pwsh --version", "PowerShell 7.6.6"}}}
	}
	var out bytes.Buffer

	declined := newMachine()
	Ensure([]config.Tool{tool("7.0")}, declined.run, func(string) bool { return false }, "", &out)
	if len(declined.ran) != 0 {
		t.Errorf("installed without consent: %v", declined.ran)
	}

	agreed := newMachine()
	results := Ensure([]config.Tool{tool("7.0")}, agreed.run, func(string) bool { return true }, "", &out)
	if len(agreed.ran) != 1 || !results[0].OK {
		t.Errorf("want one install and the tool found after it, got %v %+v\n%s", agreed.ran, results, out.String())
	}
}

func TestEnsure_NoInstallCommandNamesWhereToGetIt(t *testing.T) {
	m := &fakeMachine{versions: map[string]string{}}
	t1 := config.Tool{Name: "dotnet", Version: "9.0", Check: "dotnet --version"}
	var out bytes.Buffer
	Ensure([]config.Tool{t1}, m.run, func(string) bool { t.Fatal("asked with nothing to run"); return false }, "run the root initialize script", &out)
	if !strings.Contains(out.String(), "run the root initialize script") {
		t.Errorf("want the fallback named:\n%s", out.String())
	}
}

func TestEnsure_SkipsToolsTheAgentProbes(t *testing.T) {
	m := &fakeMachine{versions: map[string]string{}}
	var out bytes.Buffer
	results := Ensure([]config.Tool{{Name: "ticket connector", Category: "ticket-connector"}}, m.run, func(string) bool { return false }, "", &out)
	if len(results) != 0 || out.Len() != 0 {
		t.Errorf("a tool with no check should be left to the agent, got %v %q", results, out.String())
	}
}
