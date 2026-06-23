---
name: runtime-policy-update
description: Use when asked to update, audit, or align the powershell-dev-template Windows PowerShell runtime or tooling policy, including Windows PowerShell, GitHub Actions runner, Pester, PSScriptAnalyzer, PSReadLine, generated Markdown, or eng/runtime-policy.json version drift.
---

# Runtime Policy Update

## Overview

Use this skill to update the template repository's pinned Windows PowerShell runtime contract, CI runner, and baseline tooling versions. The source of truth is `eng/runtime-policy.json`.

This skill is for `powershell-dev-template` itself. Do not apply it to downstream repositories unless the user explicitly asks for a separate repo-specific runtime migration.

## Why This Exists

Runtime and tooling pins appear across GitHub Actions, VS Code settings, module manifests, generated documentation, and validation behavior. Updating only one surface can leave the template inconsistent even when that individual file looks correct.

`eng/runtime-policy.json` coordinates those values. Generated Markdown and validation scripts make updates repeatable, reviewable, and easier to audit.

## Required Context

Before acting, identify:

- the requested Windows PowerShell, runner, or tooling version change
- whether the request is an audit, branch/PR workflow, or direct local update
- whether the change preserves the Windows PowerShell 5.1 Desktop-only contract

If a requested version or compatibility decision is unclear, inspect the current policy and ask before editing.

## Update Workflow

Use this order:

1. Update `eng/runtime-policy.json` first.
2. Align policy-managed configuration:
   - `.github/workflows/ci.yml`
   - `.vscode/settings.json`
   - `src/TemplateModule.psd1`
   - `templates/module/ModuleName/ModuleName.psd1`
3. Update generated Markdown:

   ```powershell
   powershell.exe -NoProfile -File .\scripts\Update-GeneratedMarkdown.ps1
   ```

4. Inspect the diff and verify generated blocks changed only because of policy values.
5. Update `VERSION` and `CHANGELOG.md` when the change is part of a template release.

Do not edit generated Markdown block contents by hand.

## Validation Workflow

```powershell
powershell.exe -NoProfile -File .\scripts\Update-GeneratedMarkdown.ps1 -Check
powershell.exe -NoProfile -File .\scripts\Test-VersionPolicy.ps1
powershell.exe -NoProfile -File .\scripts\Invoke-RepoChecks.ps1 -IncludeTemplates
```

Run validation under Windows PowerShell 5.1 Desktop, not PowerShell 7.

## Success Criteria

- `eng/runtime-policy.json` remains the source of truth.
- CI, editor settings, module manifests, and generated Markdown agree with the policy.
- CI explicitly verifies Windows PowerShell 5.1 Desktop.
- Generated Markdown is updated through its script.
- Focused and full repository checks pass under `powershell.exe`.
- The diff is limited to the intended runtime, tooling, documentation, tests, and release metadata surfaces.

## Stop Conditions

Stop and report when:

- a requested version or supported-edition decision is ambiguous
- the request would silently broaden support beyond Windows PowerShell 5.1 Desktop
- validation reports unrelated drift
- generated Markdown remains stale after regeneration
- the change requires a new environment model without an explicit architecture decision

## Agent Role

Treat `eng/runtime-policy.json` and the validation scripts as deterministic controls. Coordinate the update, inspect the diff, run checks under Windows PowerShell 5.1, and prepare a conventional commit and PR summary.
