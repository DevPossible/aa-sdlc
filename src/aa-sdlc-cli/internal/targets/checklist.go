package targets

import (
	"bufio"
	"fmt"
	"io"
	"strconv"
	"strings"
)

// Checklist shows harnesses with their ticked state and toggles the numbers the user enters until
// an empty line or the end of input. found marks harnesses to label as found on this machine.
func Checklist(prompt string, harnesses []Spec, ticked, found map[string]bool, in io.Reader, out io.Writer) {
	// reuse a caller's buffered reader, so answers it has already buffered are not lost
	reader, ok := in.(*bufio.Reader)
	if !ok {
		reader = bufio.NewReader(in)
	}
	for {
		fmt.Fprintf(out, "  %s\n", prompt)
		for i, t := range harnesses {
			mark := " "
			if ticked[t.ID] {
				mark = "x"
			}
			note := ""
			if found[t.ID] {
				note = " (found on this machine)"
			}
			fmt.Fprintf(out, "    %2d. [%s] %s%s\n", i+1, mark, t.Name, note)
		}
		line, err := reader.ReadString('\n')
		line = strings.TrimSpace(line)
		if line == "" {
			return
		}
		for _, field := range strings.FieldsFunc(line, func(r rune) bool { return r == ',' || r == ' ' }) {
			n, convErr := strconv.Atoi(field)
			if convErr != nil || n < 1 || n > len(harnesses) {
				fmt.Fprintf(out, "  %q is not a number from the list\n", field)
				continue
			}
			ticked[harnesses[n-1].ID] = !ticked[harnesses[n-1].ID]
		}
		if err != nil {
			return
		}
	}
}
