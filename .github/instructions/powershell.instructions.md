---
applyTo: "**/*.ps1,**/*.psm1,**/*.psd1"
---

# PowerShell Rules

- Target Windows PowerShell 5.1 Desktop, full .NET Framework, and Windows-only behavior; do not use PowerShell 6+ syntax or automatic platform variables.
- Prefer small advanced functions, terminating errors with useful context, structured output, and `ShouldProcess` around mutations.
- Keep code testable: isolate external effects and avoid live service calls in tests.
