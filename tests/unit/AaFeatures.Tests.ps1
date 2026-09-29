#Requires -Version 7.0
#Requires -Modules Pester

BeforeAll {
    $scripts = Join-Path -Path $PSScriptRoot -ChildPath '..' -AdditionalChildPath '..', 'src', 'aa-sdlc', 'scripts'
    Import-Module (Join-Path -Path $scripts -ChildPath 'AaFeatures.psm1') -Force

    $script:feature = @'
@cli @T-11 @F-006
Feature: aa init bootstraps a repository
  Lays down what a repository needs.

  Background:
    Given "aa setup" has been run on this machine

  @F-006-01
  Scenario: Initialise the current directory
    Given I am in a project directory
    When I run "aa init -tier unit|e2e"
    Then a project config exists

  @O-26 @F-006-02
  Scenario Outline: Each state is set by one step
    When "<step>" completes
    Then the ticket is <state>

    Examples:
      | step   | state   |
      | /aa-a  | Refined |
      | /aa-bb | Planned |

'@ -replace "`r`n", "`n"
}

Describe 'Feature pages' {
    It 'round-trips a feature file through a page unchanged' {
        $page = ConvertTo-FeaturePage -Text $feature -File init
        $back = ConvertFrom-FeaturePage -Markdown $page -Source 'Requirements/cli/init'
        ($back -split "`n", 3)[2] | Should -Be $feature
    }

    It 'escapes a pipe in step text so the table stays intact' {
        ConvertTo-FeaturePage -Text $feature -File init | Should -Match ([regex]::Escape('aa init -tier unit\|e2e'))
    }

    It 'writes only Approved scenarios' {
        $page = (ConvertTo-FeaturePage -Text $feature -File init) -replace '(\| Scenario \| F-006-02 \|[\s\S]*?\| Status \| )Approved', '$1Draft'
        $back = ConvertFrom-FeaturePage -Markdown $page -Source x
        $back | Should -Not -Match 'F-006-02'
        $back | Should -Match 'F-006-01'
    }

    It 'generates nothing when no scenario is Approved' {
        $page = (ConvertTo-FeaturePage -Text $feature -File init) -replace '\| Status \| Approved \|', '| Status | Retired |'
        ConvertFrom-FeaturePage -Markdown $page -Source x | Should -BeNullOrEmpty
    }

    It 'refuses a status it does not know' {
        $page = (ConvertTo-FeaturePage -Text $feature -File init) -replace '\| Status \| Approved \|', '| Status | Done |'
        { ConvertFrom-FeaturePage -Markdown $page -Source x } | Should -Throw '*not one of Draft, Approved, Retired*'
    }

    It 'refuses Gherkin a page cannot hold' {
        { ConvertTo-FeaturePage -Text "Feature: x`n  Scenario: y`n    Given z`n      | a |`n" -File x } | Should -Throw '*step data tables*'
        { ConvertTo-FeaturePage -Text "Feature: x`n  Rule: r`n" -File x } | Should -Throw '*Rule*'
    }
}

Describe 'Provenance' {
    It 'accepts a file as pulled and catches a hand edit' {
        $text = ConvertFrom-FeaturePage -Markdown (ConvertTo-FeaturePage -Text $feature -File init) -Source 'Requirements/cli/init' -Version 7
        $text | Should -Match '^# Generated from the knowledge base page Requirements/cli/init \(version 7\)'
        Test-FeatureProvenance -Text $text | Should -BeNullOrEmpty
        Test-FeatureProvenance -Text ($text -replace 'a project config exists', 'anything goes') | Should -Match 'edited after it was generated'
        Test-FeatureProvenance -Text $feature | Should -Match 'no provenance header'
    }
}

Describe 'Sync-FeatureFiles' {
    BeforeEach {
        $root = Join-Path -Path $TestDrive -ChildPath ([guid]::NewGuid())
        $knowledge = Join-Path -Path $root -ChildPath 'knowledge'
        $script:features = Join-Path -Path $root -ChildPath 'features'
        $pageDir = Join-Path -Path $knowledge -ChildPath 'Requirements' -AdditionalChildPath 'cli'
        New-Item -ItemType Directory -Path $pageDir -Force | Out-Null
        Set-Content -Path (Join-Path $pageDir 'init.md') -Value (ConvertTo-FeaturePage -Text $feature -File init) -NoNewline
        $script:sync = Join-Path -Path $scripts -ChildPath 'Sync-FeatureFiles.ps1'
    }

    It 'pulls the feature files, after which the check is clean' {
        & $sync -KnowledgeRoot $knowledge -FeaturesRoot $features | Should -BeNullOrEmpty
        Test-Path (Join-Path $features 'cli/init.feature') | Should -BeTrue
        & $sync -KnowledgeRoot $knowledge -FeaturesRoot $features -Check | Should -BeNullOrEmpty
    }

    It 'catches a feature file edited in the repository' {
        & $sync -KnowledgeRoot $knowledge -FeaturesRoot $features | Out-Null
        $path = Join-Path $features 'cli/init.feature'
        (Get-Content $path -Raw) -replace 'a project config exists', 'anything goes' | Set-Content -Path $path -NoNewline
        & $sync -KnowledgeRoot $knowledge -FeaturesRoot $features -Check | Should -Match 'differs from its knowledge base page'
    }

    It 'catches a feature file no page generates' {
        New-Item -ItemType Directory -Path (Join-Path $features 'cli') -Force | Out-Null
        Set-Content -Path (Join-Path $features 'cli/extra.feature') -Value "Feature: extra`n"
        (& $sync -KnowledgeRoot $knowledge -FeaturesRoot $features -Check) -join "`n" | Should -Match 'extra.feature: no knowledge base page generates it'
    }
}

Describe 'Add-FeatureId' {
    It 'fills empty ids on a page with the next free numbers and puts them in the headings' {
        $knowledge = Join-Path -Path $TestDrive -ChildPath ([guid]::NewGuid())
        $dir = Join-Path -Path $knowledge -ChildPath 'Requirements' -AdditionalChildPath 'cli'
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Set-Content -Path (Join-Path $dir 'init.md') -Value (ConvertTo-FeaturePage -Text $feature -File init) -NoNewline
        $new = (ConvertTo-FeaturePage -Text $feature -File other) -replace 'F-006-01', '' -replace 'F-006-02', '' -replace 'F-006', ''
        Set-Content -Path (Join-Path $dir 'other.md') -Value $new -NoNewline

        & (Join-Path -Path $scripts -ChildPath 'Add-FeatureId.ps1') -KnowledgeRoot $knowledge 6> $null

        $page = Get-Content -Path (Join-Path $dir 'other.md') -Raw
        $page | Should -Match '(?m)^\| Feature \| F-007 \|'
        $page | Should -Match '(?m)^\| Scenario \| F-007-01 \|'
        $page | Should -Match '(?m)^## F-007-02 Each state is set by one step'
        $page | Should -Match '(?m)^# F-007 aa init bootstraps a repository'
        (Get-Content -Path (Join-Path $dir 'init.md') -Raw) | Should -Match '(?m)^\| Feature \| F-006 \|'
    }
}
