# AI Coding Instructions

Apply these requirements to all repository work.

- Follow `AGENTS.md`; prioritize safety, explicit user direction, deterministic repository behavior, Windows PowerShell 5.1 Desktop compatibility, then local convention.
- Before modifying tracked content, complete the freshness gate in `AGENTS.md`. Do not pull, rebase, merge, or edit when it fails.
- Be truthful about commands, APIs, and validation. State material assumptions and never expose secrets.
- Make the smallest maintainable change that satisfies the request. Avoid speculative abstractions, unrelated refactors, and unverified claims.
- Target Windows PowerShell 5.1 Desktop on Windows and full .NET Framework. Do not use PowerShell 6+ automatic variables such as `$IsWindows`, `$IsLinux`, or `$IsMacOS`.
- Use `.github/instructions/` and task-scoped skills for detailed file- and task-specific rules.
- Run relevant validation, inspect the diff, and use Conventional Commits for commits.
