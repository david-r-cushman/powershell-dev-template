# Changelog

All notable changes to this template are documented in this file.

This project uses Semantic Versioning for the template itself.

## Unreleased

### Added

### Changed

- Added a README portfolio-context section that frames this repository as the engineering platform behind the Windows PowerShell 5.1 portfolio while keeping the supporting capability claims aligned to the current template.

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
