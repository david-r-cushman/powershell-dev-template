# Changelog

All notable changes to this template are documented in this file.

This project uses Semantic Versioning for the template itself.

## Unreleased

### Added

### Changed

## 0.1.0 - 2026-06-23

### Added

- Created an independent Windows PowerShell 5.1 Desktop development template from the `pwsh-dev-template` baseline.
- Added native Windows VS Code configuration and Windows-hosted GitHub Actions validation.
- Added ADR 0001 documenting the Windows PowerShell development baseline decision.

### Changed

- Replaced PowerShell 7 and Linux-container assumptions with Windows PowerShell 5.1 Desktop compatibility.
- Removed Dev Container, GitHub Codespaces, Docker, and WSL setup surfaces.
- Updated repository automation and tests to run under `powershell.exe` with pinned Pester 5.7.1 and PSScriptAnalyzer 1.25.0.
