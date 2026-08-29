---
name: powershell-authoring
description: Author Windows PowerShell 5.1 Desktop functions, modules, and scripts with the template conventions.
---

# Windows PowerShell Authoring

- Target Windows PowerShell 5.1 Desktop, full .NET Framework, and Windows-only behavior; do not use PowerShell 6+ syntax or platform variables.
- Use advanced functions, approved verbs, PascalCase parameters, useful validation, comment-based help, terminating errors, and structured output.
- Place `SupportsShouldProcess` around only the mutation; avoid hidden side effects and `Write-Host` for functional output.
