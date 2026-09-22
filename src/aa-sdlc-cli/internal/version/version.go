// Package version holds the build identity of the aa CLI. The values are set by the build
// script with -ldflags "-X aasdlc.com/aa/internal/version.Version=..." so that the binary,
// the content it embeds, and the commit they were built from are one identity (O-24).
package version

// Version is the semantic version of the package, "dev" for a local build.
var Version = "dev"

// Commit is the source control revision the binary and its embedded content were built from.
var Commit = "unknown"

// BuildDate is the ISO 8601 time of the build.
var BuildDate = "unknown"
