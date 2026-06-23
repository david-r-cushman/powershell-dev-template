Describe 'Template scaffold' {
    BeforeAll {
        $script:RepoRoot = (Resolve-Path -LiteralPath (Join-Path -Path $PSScriptRoot -ChildPath '..\..')).Path
    }

    It 'has PowerShell script templates that parse without syntax errors' {
        $scriptFiles = Get-ChildItem -LiteralPath (Join-Path -Path $script:RepoRoot -ChildPath 'templates') -Filter '*.ps1' -Recurse -File
        $scriptFiles | Should -Not -BeNullOrEmpty

        foreach ($scriptFile in $scriptFiles) {
            $tokens = $null
            $parseErrors = $null
            [System.Management.Automation.Language.Parser]::ParseFile($scriptFile.FullName, [ref]$tokens, [ref]$parseErrors) | Out-Null

            $parseErrors | Should -BeNullOrEmpty -Because ('{0} should parse successfully' -f $scriptFile.FullName)
        }
    }

    It 'has PowerShell data files that import without parse errors' {
        $dataFiles = Get-ChildItem -LiteralPath $script:RepoRoot -Filter '*.psd1' -Recurse -File
        $dataFiles | Should -Not -BeNullOrEmpty

        foreach ($dataFile in $dataFiles) {
            { Import-PowerShellDataFile -LiteralPath $dataFile.FullName } |
                Should -Not -Throw -Because ('{0} should import successfully' -f $dataFile.FullName)
        }
    }
    It 'declares the Windows PowerShell 5.1 Desktop runtime contract' {
        $policy = Get-Content -Raw -LiteralPath (Join-Path -Path $script:RepoRoot -ChildPath 'eng/runtime-policy.json') | ConvertFrom-Json
        $workflow = Get-Content -Raw -LiteralPath (Join-Path -Path $script:RepoRoot -ChildPath '.github/workflows/ci.yml')

        $policy.runtime.powershellVersion | Should -Be '5.1'
        $policy.runtime.edition | Should -Be 'Desktop'
        $policy.runtime.executable | Should -Be 'powershell.exe'
        $policy.runtime.platform | Should -Be 'Windows'
        $policy.githubActions.runnerImage | Should -Be 'windows-2022'
        $workflow | Should -Match 'shell: powershell'
        $workflow | Should -Not -Match 'shell: pwsh'
    }

    It 'does not include a Dev Container configuration' {
        Test-Path -LiteralPath (Join-Path -Path $script:RepoRoot -ChildPath '.devcontainer') | Should -BeFalse
    }

    It 'documents the Windows PowerShell baseline decision as the first repository ADR' {
        $decisionsPath = Join-Path -Path $script:RepoRoot -ChildPath 'docs/decisions'
        $numberedAdrs = @(Get-ChildItem -LiteralPath $decisionsPath -Filter '*.md' -File | Where-Object { $_.Name -match '^\d{4}-' })
        $numberedAdrs.Count | Should -Be 1
        $numberedAdrs[0].Name | Should -Be '0001-windows-powershell-development-baseline.md'

        $adrPath = Join-Path -Path $decisionsPath -ChildPath '0001-windows-powershell-development-baseline.md'
        Test-Path -LiteralPath $adrPath -PathType Leaf | Should -BeTrue

        $content = Get-Content -Raw -LiteralPath $adrPath
        $content | Should -Match '^# 0001 - Windows PowerShell Development Baseline'
        $content | Should -Match '## Status\s+Accepted'
        $content | Should -Match '## Context'
        $content | Should -Match '## Decision'
        $content | Should -Match '## Alternatives Considered'
        $content | Should -Match '## Consequences'
        $content | Should -Match 'Windows PowerShell 5\.1 Desktop'
        $content | Should -Match 'windows-2022'
    }
}
