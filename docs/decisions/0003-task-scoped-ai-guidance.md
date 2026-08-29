# 0003 - Task-Scoped AI Guidance And Freshness Preflight

## Status

Accepted

## Context

The template needs detailed Windows PowerShell 5.1 authoring, testing, and external-service guidance, but making every rule universal makes instructions difficult to maintain and less relevant to non-PowerShell work. Mutable workflows also need a consistent guard against starting from stale or ambiguous remote state.

## Decision

Use layered guidance: lean always-on rules in `AGENTS.md` and `.github/copilot-instructions.md`, path-specific rules under `.github/instructions/`, and task-scoped Codex skills for PowerShell authoring, testing and review, and external services. Retain GitHub Copilot compatibility while designing skill routing for Codex.

Every modifying workflow must check for a clean tree, fetch and prune `origin`, require an upstream, and verify that the branch contains the latest `origin/main`. It must stop without pulling, rebasing, merging, or editing if that preflight fails.

## Consequences

Detailed PowerShell guidance is discoverable when relevant while the universal instruction surface stays concise. Downstream sync and cleanup must deliver and retain the new files, and test fixtures must model a tracking remote.
