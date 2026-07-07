# Windows PowerShell Development Template

[![CI](https://github.com/david-r-cushman/powershell-dev-template/actions/workflows/ci.yml/badge.svg)](https://github.com/david-r-cushman/powershell-dev-template/actions/workflows/ci.yml)
<!-- BEGIN generated:readme-powershell-badge -->
![PowerShell 5.1](https://img.shields.io/badge/PowerShell-5.1-blue)
<!-- END generated:readme-powershell-badge -->
![Template Version](https://img.shields.io/badge/template-0.1.0-blue)

A repeatable Windows PowerShell development template for scripts, modules, and Windows automation projects.

This template provides:

<!-- BEGIN generated:readme-runtime-focus -->
- Windows PowerShell 5.1 development
<!-- END generated:readme-runtime-focus -->
- Pester testing and PSScriptAnalyzer validation
- GitHub Actions CI on Windows
- reusable script, function, module, and test scaffolds
- AI governance and GitHub Copilot guidance
- downstream AI guidance synchronization
- repo-local agent workflows for runtime policy, guidance sync, and releases
- Conventional Commit and repository hygiene standards

## Engineering Philosophy

> *"Zero Margin for Error"*

<!-- BEGIN generated:readme-runtime-philosophy -->
- **Deterministic Runtime:** Development and validation use Windows PowerShell 5.1 Desktop edition, with CI pinned to windows-2022
<!-- END generated:readme-runtime-philosophy -->
- **Process Integrity:** Linting, testing, and deliberate structure keep automation behavior predictable.
- **Respect For State:** State-changing functions should support `-WhatIf` and `-Confirm`.
- **Human Accountability:** AI assistance accelerates drafting, but review and ownership remain human responsibilities.

See [`docs/powershell-ai-operating-model.md`](docs/powershell-ai-operating-model.md) and [`docs/decisions/`](docs/decisions/) for the deeper operating model and durable decisions.

## Use This Template

1. Create a new repository from this template.
2. Open it in VS Code on Windows.
3. Confirm the PowerShell extension is using **Windows PowerShell**.
4. Replace placeholder module metadata when the project is module-oriented.
5. Add source under `src` and tests under `tests`.
6. Copy and adapt approved scaffolds from `templates`.
7. Run validation:

   ```powershell
   powershell.exe -NoProfile -File .\scripts\Invoke-RepoChecks.ps1 -IncludeTemplates
   ```

## Runtime And Environment

<!-- BEGIN generated:readme-runtime-stack -->
- **Runtime:** Windows PowerShell 5.1 Desktop edition on Windows
<!-- END generated:readme-runtime-stack -->
- **Development mode:** Native Windows with VS Code
- **CI:** GitHub-hosted `windows-2022` runner using `powershell.exe`
- **Compatibility:** Windows PowerShell 5.1 Desktop is the sole supported runtime
- **Formatting:** UTF-8 text and LF line endings are retained for predictable Git diffs

This template intentionally does not include Dev Containers or GitHub Codespaces. VS Code Dev Containers does not support Windows container images, and a Linux container cannot provide the Windows PowerShell 5.1 Desktop runtime contract.

## Tooling

<!-- BEGIN generated:readme-tooling-list -->
- **Pester 5.7.1:** For unit and integration testing
- **PSScriptAnalyzer 1.25.0:** To enforce PowerShell best practices and security rules
- **PSReadLine 2.4.5:** Configured for a more efficient terminal experience
<!-- END generated:readme-tooling-list -->

Install the pinned modules for the current user before running local checks:

```powershell
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
Install-Module Pester -Scope CurrentUser -Force -RequiredVersion 5.7.1
Install-Module PSScriptAnalyzer -Scope CurrentUser -Force -RequiredVersion 1.25.0
Install-Module PSReadLine -Scope CurrentUser -Force -RequiredVersion 2.4.5
```

Azure CLI is optional and should be installed separately when a project requires Azure operations.

## Repository Structure

- `src/`: project source and optional module scaffold
- `tests/`: Pester tests
- `templates/`: approved function, script, module, pattern, and test scaffolds
- `scripts/Invoke-RepoChecks.ps1`: local and CI validation entrypoint
- `eng/runtime-policy.json`: runtime, runner, and tooling source of truth
- `.github/copilot-instructions.md`: authoritative AI coding guidance

## Validation And Maintenance

Run the complete validation suite:

```powershell
powershell.exe -NoProfile -File .\scripts\Invoke-RepoChecks.ps1 -IncludeTemplates
```

Run the maintainer health report:

```powershell
powershell.exe -NoProfile -File .\scripts\Get-TemplateHealth.ps1
```

Runtime and tooling updates begin in `eng/runtime-policy.json`; see [`docs/template-evolution.md`](docs/template-evolution.md). Repo-local maintenance workflows are indexed in [`docs/agent-workflows.md`](docs/agent-workflows.md).

## Downstream Guidance Sync

Audit a downstream repository:

```powershell
powershell.exe -NoProfile -File .\scripts\Invoke-TemplateGuidanceSync.ps1 -Path ..\downstream-repo
```

Apply approved guidance updates only from a non-protected branch:

```powershell
git -C ..\downstream-repo switch -c chore/sync-template-guidance-0.1.0
powershell.exe -NoProfile -File .\scripts\Invoke-TemplateGuidanceSync.ps1 -Path ..\downstream-repo -Apply
```

The downstream badge records guidance alignment only; it does not claim that project-owned source, tests, CI, or tooling match this template.

## Prerequisites And Setup

This template assumes **Windows PowerShell 5.1** running on Windows. Before installing pinned modules from the PowerShell Gallery, confirm that `PowerShellGet` 2.2.5 is available. Older inbox versions such as `1.0.0.1` may fail to find modules on the first attempt or fail to install them reliably.

Check the installed `PowerShellGet` versions:

```powershell
Get-Module PowerShellGet -ListAvailable | Sort-Object Version -Descending | Select-Object Name, Version, Path
```

If version `2.2.5` is not installed yet, install it and then retry the pinned module installation commands shown earlier in this README:

```powershell
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
Install-Module PowerShellGet -RequiredVersion 2.2.5 -Scope CurrentUser -Force
```

After installation, restart the Windows PowerShell session before installing or updating the pinned repository modules.

## Template Versioning

This repository versions the reusable template baseline using Semantic Versioning. `VERSION`, the README template badge, and `CHANGELOG.md` must remain aligned. The release workflow is defined by `.codex/skills/template-version-release/SKILL.md`. Release tags use `vX.Y.Z` after the release change is merged to `main`, followed by a matching GitHub Release.
