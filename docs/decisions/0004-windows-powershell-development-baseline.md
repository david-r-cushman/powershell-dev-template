# 0004 - Windows PowerShell Development Baseline

## Status

Accepted

## Context

A sibling template is needed for projects that require Windows PowerShell 5.1, the full .NET Framework, or Windows-only modules and management surfaces. The source `pwsh-dev-template` targets modern PowerShell on Linux and uses a Dev Container and GitHub Codespaces as its primary deterministic development environment.

Windows PowerShell 5.1 is a Windows-only Desktop-edition runtime. A Linux container cannot provide that execution environment, and VS Code Dev Containers does not support Windows container images. Reproducing the existing container experience would therefore require unsupported or separately managed infrastructure.

The current pinned versions of Pester, PSScriptAnalyzer, and PSReadLine support Windows PowerShell 5.1, so changing the runtime does not by itself require older development tooling.

## Decision

Create `powershell-dev-template` as an independent template targeting Windows PowerShell 5.1 Desktop exclusively.

Development occurs natively in VS Code on Windows. CI runs on the GitHub-hosted `windows-2022` runner and explicitly uses `powershell.exe`. Dev Container and GitHub Codespaces support are removed without adding replacement container machinery.

Retain the existing compatible tooling pins and preserve the structure, governance, scaffolds, validation workflow, downstream guidance sync, and release process inherited from `pwsh-dev-template`. Diverge only where Windows PowerShell 5.1 compatibility or the native-Windows environment requires it.

## Alternatives Considered

- Windows Dev Container: rejected because VS Code Dev Containers does not support Windows container images.
- Linux editing container with separate Windows validation: rejected because it adds complexity and presents a development runtime that cannot execute the supported target faithfully.
- Custom or self-hosted Windows container workflow: rejected because it introduces infrastructure and manual maintenance that are unnecessary for this template.
- Dual Windows PowerShell 5.1 and PowerShell 7 support: rejected because the purpose of this sibling template is an explicit Windows PowerShell 5.1 Desktop baseline.
- Downgrade Pester and related tooling: rejected because the retained pinned versions support Windows PowerShell 5.1.

## Consequences

Development requires Windows, and the template does not offer Codespaces or container portability.

GitHub Actions provides the pinned, repeatable validation environment through `windows-2022` and `powershell.exe`. Local validation must also run under Windows PowerShell 5.1 Desktop.

Projects created from this template may intentionally use Windows-only and Desktop-edition capabilities. They should not imply compatibility with PowerShell 7 unless a downstream project independently adds and validates that support.

Future template changes should remain aligned with `pwsh-dev-template` where practical, while preserving this runtime and environment boundary.
