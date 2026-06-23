# Architecture Decision Records

This directory captures durable template decisions that future maintainers should be able to understand without reconstructing pull request discussion.

ADRs are not required for routine documentation updates, patch fixes, release metadata updates, or implementation plans that are fully explained by the pull request. Use a decision record when a change introduces or changes a durable template capability, workflow policy, ownership boundary, or non-obvious tradeoff.

Good ADR candidates include decisions that affect:

- downstream repositories created from this template
- AI-assisted development workflow or governance
- validation and CI expectations
- runtime or tooling policy
- template release policy
- ownership boundaries between the template and downstream projects

## Format

Use a short, numbered Markdown file with this structure:

```markdown
# 0001 - Decision Title

## Status

Accepted

## Context

## Decision

## Alternatives Considered

## Consequences
```

Keep ADRs brief and outcome-focused. They should explain durable reasoning, not replay every implementation step.

## Current Records

- `0001-downstream-guidance-sync.md`: limits downstream synchronization to template-owned guidance and guardrails.
- `0002-repo-local-agent-workflows.md`: defines skills as orchestration over deterministic scripts and review.
- `0003-manual-github-releases.md`: keeps GitHub Release publication as an explicit post-merge action.
- `0004-windows-powershell-development-baseline.md`: establishes Windows PowerShell 5.1 Desktop, native Windows development, and Windows-hosted CI.
