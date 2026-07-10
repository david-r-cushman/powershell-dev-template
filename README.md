# Windows PowerShell Development Template

[![CI](https://github.com/david-r-cushman/powershell-dev-template/actions/workflows/ci.yml/badge.svg)](https://github.com/david-r-cushman/powershell-dev-template/actions/workflows/ci.yml)
<!-- BEGIN generated:readme-powershell-badge -->
![PowerShell 5.1](https://img.shields.io/badge/PowerShell-5.1-blue)
<!-- END generated:readme-powershell-badge -->
![Template Version](https://img.shields.io/badge/template-0.2.0-blue)

A repeatable Windows PowerShell development template for building scripts, modules, and automation projects.

This template provides a standardized starting point for PowerShell development with:

<!-- BEGIN generated:readme-runtime-focus -->
- Windows PowerShell 5.1 development
<!-- END generated:readme-runtime-focus -->
- Pester testing and PSScriptAnalyzer validation
- GitHub Actions CI on Windows
- reusable script, function, module, and test scaffolds
- AI governance and GitHub Copilot guidance
- downstream AI guidance synchronization
- repo-local agent workflows for change delivery, guidance sync, runtime policy updates, and template release management
- Conventional Commit and repository hygiene standards

Designed for engineers who want a consistent, AI-assisted PowerShell development workflow with validation and review guardrails. This repository also serves as the baseline template for my Windows PowerShell 5.1 portfolio projects, where downstream repositories demonstrate these standards applied to real Windows automation work.

Quick navigation:

- [Portfolio Context](#portfolio-context)
- [Engineering Principles in Practice](#engineering-principles-in-practice)
- [Validation And Maintenance](#validation-and-maintenance)
- [Repository Structure](#repository-structure)

## Portfolio Context

Unlike a traditional project template, this repository is the engineering platform behind my Windows PowerShell 5.1 portfolio. It establishes the engineering standards, validation workflows, AI guardrails, and governance model used throughout the portfolio, while allowing downstream repositories to adopt template improvements through deliberate, project-specific validation rather than automatic synchronization.

This repo provides:

- a repeatable PowerShell development environment
- reusable script, function, module, and test scaffolds
- validation through PSScriptAnalyzer and Pester
- GitHub project hygiene for issues, pull requests, security, and dependency updates
- AI-assisted development governance for safe, reviewable, and verifiable engineering work

Downstream portfolio repositories provide the project-specific implementation and show these standards applied to real Windows PowerShell 5.1 projects.

## Engineering Principles in Practice

> *"Zero Margin for Error"*

<!-- BEGIN generated:readme-runtime-philosophy -->
- **Deterministic Runtime:** Development and validation use Windows PowerShell 5.1 Desktop edition, with CI pinned to windows-2022
<!-- END generated:readme-runtime-philosophy -->
- **Process Integrity:** Linting, testing, and deliberate structure keep automation behavior predictable
- **Respect For State:** State-changing functions should support `-WhatIf` and `-Confirm`
- **Human Accountability:** AI assistance accelerates drafting, but review and ownership remain human responsibilities

That same philosophy also shapes how AI assistance is used in this template and in repositories created from it. For the deeper operating model behind that approach, see [`docs/powershell-ai-operating-model.md`](docs/powershell-ai-operating-model.md). For durable engineering decisions behind the template's workflow and ownership boundaries, see [`docs/decisions/`](docs/decisions/).

## Use This Template

1. Create a new repository from this template.
2. Open the repository locally in VS Code on Windows.
3. Confirm the PowerShell extension is using **Windows PowerShell** before adding project-specific docs, tests, ADRs, or CI changes.
4. Replace placeholder module metadata if the project is module-oriented.
5. Add scripts, functions, modules, or automation under `src`.
6. Add project-specific Pester tests under `tests`.
7. Copy and adapt scaffolds from `templates` for new functions, scripts, modules, and tests when they fit the work.
8. Review the AI-assisted development guidance in `AGENTS.md` and `.github/copilot-instructions.md` before using AI-generated changes.
9. Run local validation:

   ```powershell
   powershell.exe -NoProfile -File .\scripts\Invoke-RepoChecks.ps1 -IncludeTemplates
   ```

This template provides the environment, conventions, structure, and reusable scaffolds. Downstream repositories are expected to replace placeholder metadata, add real implementation code, and supply project-specific tests and documentation.

## Runtime And Environment

This template provides a Windows-native development baseline for repositories that must target Windows PowerShell 5.1 Desktop edition accurately and predictably.

<!-- BEGIN generated:readme-runtime-stack -->
- **Runtime:** Windows PowerShell 5.1 Desktop edition on Windows
<!-- END generated:readme-runtime-stack -->
- **Development Mode:** Native Windows with VS Code
- **CI:** GitHub-hosted `windows-2022` runner using `powershell.exe`
- **Compatibility:** Windows PowerShell 5.1 Desktop is the sole supported runtime
- **Formatting:** UTF-8 text and LF line endings are retained for predictable Git diffs

This template intentionally does not include Dev Containers or GitHub Codespaces. VS Code Dev Containers does not support Windows container images, and a Linux container cannot provide the Windows PowerShell 5.1 Desktop runtime contract.

## Tooling

<!-- BEGIN generated:readme-tooling-list -->
- **Pester 6.0.0:** For unit and integration testing
- **PSScriptAnalyzer 1.25.0:** To enforce PowerShell best practices and security rules
- **PSReadLine 2.4.5:** Configured for a more efficient terminal experience
<!-- END generated:readme-tooling-list -->

When you work in the intended Windows-native environment, install the pinned modules for the current user before running local checks:

```powershell
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
Install-Module Pester -Scope CurrentUser -Force -RequiredVersion 6.0.0
Install-Module PSScriptAnalyzer -Scope CurrentUser -Force -RequiredVersion 1.25.0
Install-Module PSReadLine -Scope CurrentUser -Force -RequiredVersion 2.4.5
```

Azure CLI is optional and should be installed separately when a project requires Azure operations.

## Repository Structure

This repository includes the environment, conventions, and approved templates used to start new Windows PowerShell projects, but it does not ship with downstream project business logic, public functions, private helpers, or project-owned test implementations.

Core repository structure:

- `src/`: project source and optional module scaffold
- `tests/`: Pester tests for the template itself and downstream project tests after repository creation
- `templates/`: approved function, script, module, pattern, and test scaffolds
- `docs/`: operating model, durable decisions, and maintainer guidance
- `scripts/Invoke-RepoChecks.ps1`: local and CI validation entrypoint
- `eng/runtime-policy.json`: runtime, runner, and tooling source of truth
- `.github/copilot-instructions.md`: authoritative AI coding guidance

Template starting points include:

- `templates/functions/read-only-function-template.ps1`
- `templates/functions/state-changing-function-template.ps1`
- `templates/patterns/retry-pattern-template.ps1`
- `templates/tests/read-only-function-tests-template.ps1`
- `templates/tests/state-changing-function-tests-template.ps1`

See `templates/README.md` for the full template index, including module and script scaffolds.

## Validation And Maintenance

Run the complete validation suite:

```powershell
powershell.exe -NoProfile -File .\scripts\Invoke-RepoChecks.ps1 -IncludeTemplates
```

Run the template health report for a maintainer view of generated Markdown, runtime policy, template version metadata, repo-local agent workflow discoverability, and Git release posture:

```powershell
powershell.exe -NoProfile -File .\scripts\Get-TemplateHealth.ps1
```

Use `-AsJson` for agent-readable output or `-FailOnIssue` when a non-healthy item should fail automation.

Validation and maintenance also rely on:

- `PSScriptAnalyzerSettings.psd1`
- `PesterConfiguration.psd1`
- `.github/workflows/ci.yml`
- `eng/runtime-policy.json`
- [`docs/template-evolution.md`](docs/template-evolution.md)
- [`docs/agent-workflows.md`](docs/agent-workflows.md)

This template includes repo-local agent workflows for repeatable maintenance. Guidance sync, runtime policy updates, and template release work are documented under `.codex/skills/` and indexed in [`docs/agent-workflows.md`](docs/agent-workflows.md).

## Downstream Guidance Sync

This template includes a local sync tool for repositories created from it. The sync can refresh AI guidance, guardrail documentation, the ADR scaffold README, and the README template-version badge so downstream repositories can stay aligned with template-owned guidance after project-specific work has begun.

The sync does not update project-owned source, tests, PSScriptAnalyzer settings, Pester configuration, CI workflows, runtime policy, or project-specific ADRs.

A repo-local Codex skill is also provided at `.codex/skills/downstream-guidance-sync/SKILL.md` so agents can operate the sync script through the intended audit, branch, validation, commit, and pull request workflow.

Run the tool from this template repository and pass the downstream repository path:

```powershell
powershell.exe -NoProfile -File .\scripts\Invoke-TemplateGuidanceSync.ps1 -Path ..\downstream-repo
```

Audit mode is the default and reports drift without changing files. To apply the safe sync set, create or switch the downstream repo to a non-main branch first, then run:

```powershell
git -C ..\downstream-repo switch -c chore/sync-template-guidance-0.1.0
powershell.exe -NoProfile -File .\scripts\Invoke-TemplateGuidanceSync.ps1 -Path ..\downstream-repo -Apply
```

The README template badge means the downstream repo's AI guidance and guardrails are aligned to that template version. It does not mean the downstream implementation or tooling fully matches this template.

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

This repository versions the template itself using Semantic Versioning.

- Current version: see `VERSION`
- Version history: see `CHANGELOG.md`
- Version validation: run `scripts/Test-TemplateVersion.ps1`
- Versioning policy: see [`docs/template-evolution.md`](docs/template-evolution.md)

Version changes apply to the template baseline, not to downstream repositories created from it. In general:

- Major versions indicate breaking template, workflow, or compatibility changes.
- Minor versions indicate new template capabilities, tooling, templates, or conventions.
- Patch versions indicate fixes, documentation clarifications, and low-risk maintenance updates.

A repo-local Codex skill is provided at `.codex/skills/template-version-release/SKILL.md` for version preparation, post-merge release tagging, and GitHub Release publishing. Release tags use the lightweight `vX.Y.Z` format and are applied to the merged `main` commit after the release PR is merged. GitHub Releases use the matching changelog section as their public release notes, and GitHub verification should be confirmed in the GitHub UI after the tag is pushed.
