# Knowledge base

The framework keeps its knowledge base in this folder, the documents-folder fallback a project
uses when it has no knowledge base in scope (T-12, decision record 0019). The pages are in the
same format a knowledge base would hold, so moving them into one is an upload.

- `Requirements/<topic>/<feature>.md`: one feature page per feature, the source of truth for what
  the framework must do. The feature files in `features/` are generated from them.

The format is in `docs/formats.md`, section 4. To change a requirement, change its page and run
`./scripts/Add-FeatureId.ps1`.
