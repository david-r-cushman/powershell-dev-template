<#
.SYNOPSIS
    Runs repository checks (PSScriptAnalyzer + Pester) with consistent settings.

.DESCRIPTION
    Intended to be the single entrypoint for local validation and CI.

    - Runs PSScriptAnalyzer using PSScriptAnalyzerSettings.psd1
    - Runs Pester using PesterConfiguration.psd1

.PARAMETER SkipAnalyzer
    Skips PSScriptAnalyzer.

.PARAMETER SkipTests
    Skips Pester tests.

.PARAMETER IncludeTemplates
    Includes the `templates/` folder in PSScriptAnalyzer scanning.

.PARAMETER SkipVersionPolicy
    Skips runtime and tooling version policy validation.

.PARAMETER SkipGeneratedMarkdown
    Skips generated Markdown validation.

.PARAMETER SkipTemplateVersion
    Skips template release version metadata validation.

.PARAMETER OutputPath
    Optional output folder for artifacts (currently used for test results).
#>
[CmdletBinding()]
param(
    [Parameter()]
    [switch]$SkipAnalyzer,

    [Parameter()]
    [switch]$SkipTests,

    [Parameter()]
    [switch]$IncludeTemplates,

    [Parameter()]
    [switch]$SkipVersionPolicy,

    [Parameter()]
    [switch]$SkipGeneratedMarkdown,

    [Parameter()]
    [switch]$SkipTemplateVersion,

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$OutputPath
)

$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path -LiteralPath (Join-Path -Path $PSScriptRoot -ChildPath '..')).Path
$runtimePolicyPath = Join-Path -Path $repoRoot -ChildPath 'eng\runtime-policy.json'
$runtimePolicy = Get-Content -Raw -LiteralPath $runtimePolicyPath | ConvertFrom-Json

if (-not $SkipAnalyzer) {
    try {
        Import-Module PSScriptAnalyzer -RequiredVersion $runtimePolicy.tooling.psScriptAnalyzerVersion -ErrorAction Stop
    }
    catch {
        throw ('Required module not available: PSScriptAnalyzer {0}. Install it and retry.' -f $runtimePolicy.tooling.psScriptAnalyzerVersion)
    }
}

if (-not $SkipTests) {
    try {
        Import-Module Pester -RequiredVersion $runtimePolicy.tooling.pesterVersion -ErrorAction Stop
    }
    catch {
        throw ('Required module not available: Pester {0}. Install it and retry.' -f $runtimePolicy.tooling.pesterVersion)
    }
}

function Resolve-RepoPath {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$RelativePath
    )

    return (Join-Path -Path $repoRoot -ChildPath $RelativePath)
}

$analyzerSettingsPath = Resolve-RepoPath -RelativePath 'PSScriptAnalyzerSettings.psd1'
$pesterConfigPath = Resolve-RepoPath -RelativePath 'PesterConfiguration.psd1'
$pesterRunPath = Resolve-RepoPath -RelativePath 'tests'
$versionPolicyScriptPath = Resolve-RepoPath -RelativePath 'scripts/Test-VersionPolicy.ps1'
$generatedMarkdownScriptPath = Resolve-RepoPath -RelativePath 'scripts/Update-GeneratedMarkdown.ps1'
$templateVersionScriptPath = Resolve-RepoPath -RelativePath 'scripts/Test-TemplateVersion.ps1'

if (-not $SkipGeneratedMarkdown) {
    if (-not (Test-Path -LiteralPath $generatedMarkdownScriptPath)) {
        throw ('Generated Markdown script not found: {0}' -f $generatedMarkdownScriptPath)
    }

    Write-Verbose 'Validating generated Markdown...'
    & $generatedMarkdownScriptPath -Check
}

if (-not $SkipVersionPolicy) {
    if (-not (Test-Path -LiteralPath $versionPolicyScriptPath)) {
        throw ('Version policy validation script not found: {0}' -f $versionPolicyScriptPath)
    }

    Write-Verbose 'Validating version policy...'
    & $versionPolicyScriptPath
}
if (-not $SkipTemplateVersion) {
    if (-not (Test-Path -LiteralPath $templateVersionScriptPath)) {
        throw ('Template version validation script not found: {0}' -f $templateVersionScriptPath)
    }

    Write-Verbose 'Validating template version metadata...'
    & $templateVersionScriptPath
}

if (-not $SkipAnalyzer) {
    if (-not (Test-Path -LiteralPath $analyzerSettingsPath)) {
        throw ('PSScriptAnalyzer settings file not found: {0}' -f $analyzerSettingsPath)
    }

    Write-Verbose 'Running PSScriptAnalyzer...'

    $analyzerResults = @()
    $analyzerResults += @(Invoke-ScriptAnalyzer -Path (Resolve-RepoPath -RelativePath 'src') -Recurse -Settings $analyzerSettingsPath)
    $analyzerResults += @(Invoke-ScriptAnalyzer -Path (Resolve-RepoPath -RelativePath 'tests') -Recurse -Settings $analyzerSettingsPath)
    $analyzerResults += @(Invoke-ScriptAnalyzer -Path (Resolve-RepoPath -RelativePath 'scripts') -Recurse -Settings $analyzerSettingsPath)

    if ($IncludeTemplates) {
        $analyzerResults += @(Invoke-ScriptAnalyzer -Path (Resolve-RepoPath -RelativePath 'templates') -Recurse -Settings $analyzerSettingsPath)
    }

    if ($analyzerResults) {
        $analyzerResults | Format-Table -AutoSize | Out-String | Write-Output
        throw ('PSScriptAnalyzer found {0} issue(s).' -f @($analyzerResults).Count)
    }
}

if (-not $SkipTests) {
    if (-not (Test-Path -LiteralPath $pesterConfigPath)) {
        throw ('Pester configuration file not found: {0}' -f $pesterConfigPath)
    }

    $config = Import-PowerShellDataFile -LiteralPath $pesterConfigPath
    $config.Run.Path = @($pesterRunPath)

    if ($OutputPath) {
        $resolvedOutputPath = Resolve-Path -LiteralPath $OutputPath -ErrorAction SilentlyContinue
        if ($resolvedOutputPath) {
            $resolvedOutputPath = $resolvedOutputPath.Path
        }
        else {
            New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
            $resolvedOutputPath = (Resolve-Path -LiteralPath $OutputPath).Path
        }

        $config.TestResult.OutputPath = (Join-Path -Path $resolvedOutputPath -ChildPath 'TestResults.xml')
        $pesterConfiguration = [PesterConfiguration]::new($config)
    }
    else {
        $pesterConfiguration = [PesterConfiguration]::new($config)
    }

    Write-Verbose 'Running Pester...'
    $result = Invoke-Pester -Configuration $pesterConfiguration

    if ($result.FailedCount -gt 0) {
        throw ('Pester failures: {0}' -f $result.FailedCount)
    }
}
