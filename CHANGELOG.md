# Changelog

All notable changes to this template are documented in this file.

This project uses Semantic Versioning for the template itself.

## Unreleased

### Added

### Changed

- Clarified the README opening positioning so the template reads as both a practical PowerShell foundation and a documented exploration of effective PowerShell engineering.

## 0.3.0 - 2026-07-10

### Added

- Added a shared downstream README skeleton for repositories created from this template.
- Added deterministic downstream cleanup and downstream README alignment workflows, including repo-local cleanup and README-alignment skills.
- Added ADR 0002 documenting the downstream README workflow and starter README strategy.
- Added the change-delivery workflow skill so ordinary repository changes follow the same repeatable branch, changelog, validation, and PR discipline as the PowerShell Core template.

### Changed

- Expanded downstream guidance sync to deliver cleanup assets, README workflow assets, and the runtime-policy README-generation files required by those workflows.
- Updated generated Markdown, version-policy validation, template health reporting, README guidance, and skill discoverability to treat the new downstream README workflow as a maintained template capability.

## 0.2.0 - 2026-07-09

### Added

### Changed

- Clarified repository guidance to prefer self-explanatory code over explanatory inline comments while still requiring comment-based help for public functions and scripts and allowing targeted rationale comments for non-obvious constraints or quirks.
- Hardened `scripts/Invoke-RepoChecks.ps1` so Pester test discovery is anchored to the repository root even when the script is launched from another working directory.
- Added README prerequisites and setup guidance that documents the Windows PowerShell `PowerShellGet` 2.2.5 requirement for reliable PSGallery-backed module installation.
- Adopted Pester 6.0.0 as the pinned template test framework version across the runtime policy, CI workflow, generated documentation, and Windows PowerShell 5.1 install guidance after verifying the repository checks pass under Windows PowerShell 5.1 with Pester 6.

## 0.1.0 - 2026-06-23

### Added

- Created an independent Windows PowerShell 5.1 Desktop development template from the `pwsh-dev-template` baseline.
- Added native Windows VS Code configuration and Windows-hosted GitHub Actions validation.
- Added ADR 0001 documenting the Windows PowerShell development baseline decision.

### Changed

- Replaced PowerShell 7 and Linux-container assumptions with Windows PowerShell 5.1 Desktop compatibility.
- Removed Dev Container, GitHub Codespaces, Docker, and WSL setup surfaces.
- Updated repository automation and tests to run under `powershell.exe` with pinned Pester 5.7.1 and PSScriptAnalyzer 1.25.0.
