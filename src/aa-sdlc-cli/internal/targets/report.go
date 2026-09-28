package targets

import (
	"fmt"
	"io"
	"strings"
)

// ReportInstall writes one line per harness: where its skills and commands went, whether the
// entry has been verified in the harness itself, and whether it reads the skills from more than
// one folder.
func ReportInstall(out io.Writer, scope Scope, harnesses []Spec, res InstallResult) {
	for _, t := range harnesses {
		reads := res.Plan.Reads[t.ID]
		var where []string
		for _, d := range reads {
			where = append(where, scope.Ref(d))
		}
		line := fmt.Sprintf("  %s: %d skills in %s", t.Name, res.Skills, strings.Join(where, " and "))
		for _, set := range res.Plan.Commands {
			for _, id := range set.Targets {
				if id == t.ID {
					line += fmt.Sprintf("; %d commands in %s", res.Skills, scope.Ref(set.Dir))
				}
			}
		}
		for _, set := range res.Plan.Agents {
			for _, id := range set.Targets {
				if id == t.ID {
					line += fmt.Sprintf("; %d subagents in %s", res.Agents, scope.Ref(set.Dir))
				}
			}
		}
		line += fmt.Sprintf(" at %s scope", scope.Name)
		if !t.Verified {
			line += " (per its documentation; not yet verified in the harness)"
		}
		fmt.Fprintln(out, line)
		if len(reads) > 1 {
			fmt.Fprintf(out, "    note: %s reads skills from more than one of these folders, so it may list each skill twice\n", t.Name)
		}
	}
}
