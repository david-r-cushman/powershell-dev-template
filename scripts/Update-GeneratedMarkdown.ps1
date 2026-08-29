<#
.SYNOPSIS
    Updates generated Markdown blocks from the central runtime policy.

.DESCRIPTION
    Rewrites known generated blocks in documentation files. The script only
    changes content between matching BEGIN/END generated markers.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter()]
    [switch]$Check,

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$PolicyPath
)

$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path -LiteralPath (Join-Path -Path $PSScriptRoot -ChildPath '..')).Path
if ([string]::IsNullOrWhiteSpace($PolicyPath)) {
    $PolicyPath = Join-Path -Path $repoRoot -ChildPath 'eng\runtime-policy.json'
}
$resolvedPolicyPath = (Resolve-Path -LiteralPath $PolicyPath).Path
$policy = Get-Content -Raw -LiteralPath $resolvedPolicyPath | ConvertFrom-Json
$checkOnly = $Check.IsPresent
$pendingChanges = [System.Collections.Generic.List[object]]::new()

function Assert-RemoteFreshness {
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$RepoPath)

    if (@(& git -C $RepoPath status --porcelain).Count -gt 0) { throw 'Refusing to update generated Markdown because the working tree is dirty.' }
    $origin = & git -C $RepoPath remote get-url origin 2>$null
    if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($origin)) { throw 'Refusing to update generated Markdown because origin is not configured.' }
    & git -C $RepoPath fetch --quiet --prune origin
    if ($LASTEXITCODE -ne 0) { throw 'Refusing to update generated Markdown because origin cannot be fetched.' }
    $upstream = & git -C $RepoPath rev-parse --abbrev-ref '@{upstream}' 2>$null
    if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($upstream)) { throw 'Refusing to update generated Markdown because the current branch has no upstream.' }
    $counts = @((& git -C $RepoPath rev-list --left-right --count HEAD...$upstream) -split '\s+')
    if ($LASTEXITCODE -ne 0 -or $counts.Count -ne 2 -or [int]$counts[1] -gt 0 -or ([int]$counts[0] -gt 0 -and [int]$counts[1] -gt 0)) { throw 'Refusing to update generated Markdown because the branch is not current with its upstream.' }
    & git -C $RepoPath merge-base --is-ancestor origin/main HEAD
    if ($LASTEXITCODE -ne 0) { throw 'Refusing to update generated Markdown because the branch does not contain the latest origin/main.' }
}

if (-not $checkOnly -and -not $WhatIfPreference) {
    Assert-RemoteFreshness -RepoPath $repoRoot
}

function Set-GeneratedMarkdownBlock {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$RelativePath,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$BlockName,

        [Parameter(Mandatory)]
        [ValidateNotNull()]
        [string[]]$Lines
    )

    $path = Join-Path -Path $repoRoot -ChildPath $RelativePath
    if (-not (Test-Path -LiteralPath $path)) {
        throw ('Markdown file not found: {0}' -f $RelativePath)
    }

    $beginMarker = '<!-- BEGIN generated:{0} -->' -f $BlockName
    $endMarker = '<!-- END generated:{0} -->' -f $BlockName
    $content = Get-Content -Raw -LiteralPath $path
    $escapedBeginMarker = [regex]::Escape($beginMarker)
    $escapedEndMarker = [regex]::Escape($endMarker)
    $pattern = '(?s){0}.*?{1}' -f $escapedBeginMarker, $escapedEndMarker
    $regex = [regex]::new($pattern)

    if (-not $regex.IsMatch($content)) {
        throw ('Generated block "{0}" not found in {1}' -f $BlockName, $RelativePath)
    }

    $replacement = @($beginMarker) + $Lines + @($endMarker)
    $updatedContent = $regex.Replace($content, ($replacement -join "`n"), 1).TrimEnd("`r", "`n") + "`n"

    if ($updatedContent -ne $content) {
        if ($checkOnly) {
            $pendingChange = [pscustomobject]@{
                Path = $RelativePath
                BlockName = $BlockName
                Reason = 'Generated block is out of date'
            }

            $pendingChanges.Add($pendingChange)
            return
        }

        if ($PSCmdlet.ShouldProcess($RelativePath, ('Update generated block {0}' -f $BlockName))) {
            [System.IO.File]::WriteAllText($path, $updatedContent, [System.Text.UTF8Encoding]::new($false))
        }
    }
}

$runtimeLine = '- **Runtime:** Windows PowerShell {0} {1} edition on Windows' -f $policy.runtime.powershellVersionLabel, $policy.runtime.edition
$toolingLine = '- **Tooling:** Pester {0}, PSScriptAnalyzer {1}, and PSReadLine {2}' -f $policy.tooling.pesterVersion, $policy.tooling.psScriptAnalyzerVersion, $policy.tooling.psReadLineVersion
$baseRuntimeLine = '- **Deterministic Runtime:** Development and validation use Windows PowerShell {0} {1} edition, with CI pinned to {2}' -f $policy.runtime.powershellVersion, $policy.runtime.edition, $policy.githubActions.runnerImage
$controlledRuntimeLine = '- **Controlled Runtime:** Local checks use Windows PowerShell {0}, and CI validates the same Desktop-edition contract on {1}' -f $policy.runtime.powershellVersion, $policy.githubActions.runnerImage

Set-GeneratedMarkdownBlock -RelativePath 'README.md' -BlockName 'readme-powershell-badge' -Lines @(
    '![PowerShell {0}](https://img.shields.io/badge/PowerShell-{0}-blue)' -f $policy.runtime.powershellVersion
)

Set-GeneratedMarkdownBlock -RelativePath 'README.md' -BlockName 'readme-runtime-focus' -Lines @(
    '- Windows PowerShell {0} development' -f $policy.runtime.powershellVersion
)

Set-GeneratedMarkdownBlock -RelativePath 'README.md' -BlockName 'readme-runtime-stack' -Lines @(
    $runtimeLine
)

Set-GeneratedMarkdownBlock -RelativePath 'README.md' -BlockName 'readme-tooling-list' -Lines @(
    ('- **Pester {0}:** For unit and integration testing' -f $policy.tooling.pesterVersion),
    ('- **PSScriptAnalyzer {0}:** To enforce PowerShell best practices and security rules' -f $policy.tooling.psScriptAnalyzerVersion),
    ('- **PSReadLine {0}:** Configured for a more efficient terminal experience' -f $policy.tooling.psReadLineVersion)
)

Set-GeneratedMarkdownBlock -RelativePath 'README.md' -BlockName 'readme-runtime-philosophy' -Lines @(
    $baseRuntimeLine
)


Set-GeneratedMarkdownBlock -RelativePath 'templates/downstream/README.md' -BlockName 'readme-powershell-badge' -Lines @(
    '![PowerShell {0}](https://img.shields.io/badge/PowerShell-{0}-blue)' -f $policy.runtime.powershellVersion
)

Set-GeneratedMarkdownBlock -RelativePath 'templates/downstream/README.md' -BlockName 'readme-runtime-focus' -Lines @(
    '- Windows PowerShell {0} development' -f $policy.runtime.powershellVersion
)

Set-GeneratedMarkdownBlock -RelativePath 'templates/downstream/README.md' -BlockName 'readme-runtime-stack' -Lines @(
    $runtimeLine
)

Set-GeneratedMarkdownBlock -RelativePath 'templates/downstream/README.md' -BlockName 'readme-tooling-list' -Lines @(
    ('- **Pester {0}:** For unit and integration testing' -f $policy.tooling.pesterVersion),
    ('- **PSScriptAnalyzer {0}:** To enforce PowerShell best practices and security rules' -f $policy.tooling.psScriptAnalyzerVersion),
    ('- **PSReadLine {0}:** Configured for a more efficient terminal experience' -f $policy.tooling.psReadLineVersion)
)

Set-GeneratedMarkdownBlock -RelativePath 'templates/downstream/README.md' -BlockName 'readme-runtime-philosophy' -Lines @(
    $baseRuntimeLine
)
Set-GeneratedMarkdownBlock -RelativePath '.github/instructions/environment-setup.md' -BlockName 'environment-runtime-stack' -Lines @(
    $runtimeLine
)

Set-GeneratedMarkdownBlock -RelativePath '.github/instructions/environment-setup.md' -BlockName 'environment-tooling-stack' -Lines @(
    $toolingLine
)

Set-GeneratedMarkdownBlock -RelativePath '.github/instructions/environment-setup.md' -BlockName 'environment-runtime-principle' -Lines @(
    $controlledRuntimeLine
)

if ($pendingChanges.Count -gt 0) {
    $pendingChanges | Format-Table -AutoSize | Out-String | Write-Output
    throw ('Generated Markdown is out of date in {0} block(s).' -f $pendingChanges.Count)
}

Write-Verbose ('Generated Markdown validated from policy: {0}' -f $resolvedPolicyPath)
