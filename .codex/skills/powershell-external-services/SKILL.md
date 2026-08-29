---
name: powershell-external-services
description: Implement or review Windows PowerShell 5.1 integrations with Graph, REST, credentials, deprecations, and testable boundaries.
---

# Windows PowerShell External Services

- Prefer Microsoft Graph PowerShell when supported; justify raw REST calls.
- Verify service contracts rather than inventing cmdlets, parameters, or API behavior.
- Keep credentials and tokens out of source and output; isolate integration boundaries for mocking and tests.
- Preserve Windows PowerShell 5.1 compatibility and document deprecated service migrations.
