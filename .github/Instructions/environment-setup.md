# Environment Setup: Windows PowerShell Development Template

## Overview

This repository provides a native Windows development baseline for Windows PowerShell 5.1 Desktop projects.

## Development Mode

Work locally in VS Code on Windows. The repository configures both the PowerShell extension and integrated terminal to prefer the Windows PowerShell executable at:

```text
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
```

Dev Containers and GitHub Codespaces are intentionally not supported because they cannot provide the Windows PowerShell 5.1 Desktop runtime contract without adding a separate, unsupported Windows-container workflow.

## Technical Stack

<!-- BEGIN generated:environment-runtime-stack -->
- **Runtime:** Windows PowerShell 5.1 Desktop edition on Windows
<!-- END generated:environment-runtime-stack -->
<!-- BEGIN generated:environment-tooling-stack -->
- **Tooling:** Pester 6.0.0, PSScriptAnalyzer 1.25.0, and PSReadLine 2.4.5
<!-- END generated:environment-tooling-stack -->
- **Editor:** VS Code with the PowerShell extension
- **CI:** GitHub Actions on `windows-2022`
- **Governance:** EditorConfig, Markdown linting, and repository AI instructions

## Prerequisites

1. Windows 10, Windows 11, or a supported Windows Server release with Windows PowerShell 5.1.
2. Git for Windows.
3. VS Code with the recommended extensions.
4. The pinned PowerShell modules installed for the current user.

```powershell
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
Install-Module Pester -Scope CurrentUser -Force -RequiredVersion 5.7.1
Install-Module PSScriptAnalyzer -Scope CurrentUser -Force -RequiredVersion 1.25.0
Install-Module PSReadLine -Scope CurrentUser -Force -RequiredVersion 2.4.5
```

Azure CLI is optional and should be installed only when required by the project.

## Getting Started

1. Clone or create a repository from the template.
2. Open the folder in VS Code on Windows.
3. Use **PowerShell: Show Session Menu** and confirm **Windows PowerShell** is selected.
4. Open a new integrated terminal and verify:

   ```powershell
   $PSVersionTable.PSVersion
   $PSVersionTable.PSEdition
   ```

   The expected values are version `5.1` and edition `Desktop`.

5. Run the repository checks:

   ```powershell
   powershell.exe -NoProfile -File .\scripts\Invoke-RepoChecks.ps1 -IncludeTemplates
   ```

## Design Principles

<!-- BEGIN generated:environment-runtime-principle -->
- **Controlled Runtime:** Local checks use Windows PowerShell 5.1, and CI validates the same Desktop-edition contract on windows-2022
<!-- END generated:environment-runtime-principle -->
- **Pinned Validation Tooling:** Pester and PSScriptAnalyzer versions are centralized in `eng/runtime-policy.json`.
- **Native Runtime Fidelity:** Development occurs on the operating system and .NET Framework edition the template supports.
- **Minimal Divergence:** Capabilities shared with `pwsh-dev-template` remain aligned unless Windows PowerShell compatibility requires a difference.

## Troubleshooting

- **Wrong PowerShell edition:** Select Windows PowerShell from the VS Code PowerShell session menu and open a new terminal.
- **Built-in Pester 3.4.0 loads:** Install Pester 5.7.1 and run checks through `scripts/Invoke-RepoChecks.ps1`, which imports the pinned version explicitly.
- **Module not found:** Reinstall the pinned module with `-Scope CurrentUser` and confirm it appears in `$env:PSModulePath`.
- **Line-ending drift:** Preserve the repository EditorConfig and Git attributes settings.
