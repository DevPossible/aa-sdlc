#Requires -Version 7.0
#Requires -Modules Pester

BeforeAll {
    $script:schema = Join-Path $PSScriptRoot '../../src/aa-sdlc/schemas/aa.config.schema.json'
}

Describe 'F-094-01 F-094-07 Full-suite config schema' {
    It 'accepts <Name>' -ForEach @(
        @{ Name = 'an absent testing policy'; Policy = $null },
        @{ Name = 'an absent mode'; Policy = @{} },
        @{ Name = 'explicit per-branch'; Policy = @{ mode = 'per-branch' } },
        @{ Name = 'checkpoint without a backstop'; Policy = @{ mode = 'checkpoint'; integrationBranch = 'develop'; perMerge = @('build', 'lint', 'smoke', 'changed-components'); checkpointBefore = @('demonstration') } },
        @{ Name = 'checkpoint with both backstop bounds and extra merge checks'; Policy = @{ mode = 'checkpoint'; integrationBranch = 'develop'; perMerge = @('build', 'lint', 'smoke', 'changed-components', 'security'); checkpointBefore = @('release', 'exposure', 'demonstration'); backstop = @{ merges = 10; days = 3 } } },
        @{ Name = 'checkpoint with a merge-only backstop'; Policy = @{ mode = 'checkpoint'; integrationBranch = 'develop'; perMerge = @('build', 'lint', 'smoke', 'changed-components'); checkpointBefore = @('release'); backstop = @{ merges = 1 } } },
        @{ Name = 'checkpoint with a day-only backstop'; Policy = @{ mode = 'checkpoint'; integrationBranch = 'develop'; perMerge = @('build', 'lint', 'smoke', 'changed-components'); checkpointBefore = @('exposure'); backstop = @{ days = 1 } } }
    ) {
        $config = @{ version = 1; scope = 'project' }
        if ($null -ne $Policy) { $config.testing = @{ fullSuite = $Policy } }
        Test-Json -Json ($config | ConvertTo-Json -Depth 8) -SchemaFile $script:schema | Should -BeTrue
    }

    It 'rejects <Name>' -ForEach @(
        @{ Name = 'an unknown mode'; Change = @{ mode = 'sometimes' } },
        @{ Name = 'a missing integration branch'; Remove = 'integrationBranch' },
        @{ Name = 'a blank integration branch'; Change = @{ integrationBranch = ' ' } },
        @{ Name = 'missing checkpoint events'; Remove = 'checkpointBefore' },
        @{ Name = 'empty checkpoint events'; Change = @{ checkpointBefore = @() } },
        @{ Name = 'blank checkpoint events'; Change = @{ checkpointBefore = @(' ') } },
        @{ Name = 'duplicate checkpoint events'; Change = @{ checkpointBefore = @('release', 'release') } },
        @{ Name = 'missing per-merge gates'; Remove = 'perMerge' },
        @{ Name = 'an omitted build gate'; Change = @{ perMerge = @('lint', 'smoke', 'changed-components', 'security') } },
        @{ Name = 'an omitted lint gate'; Change = @{ perMerge = @('build', 'smoke', 'changed-components', 'security') } },
        @{ Name = 'an omitted smoke gate'; Change = @{ perMerge = @('build', 'lint', 'changed-components', 'security') } },
        @{ Name = 'an omitted component gate'; Change = @{ perMerge = @('build', 'lint', 'smoke', 'security') } },
        @{ Name = 'duplicate merge gates'; Change = @{ perMerge = @('build', 'lint', 'smoke', 'changed-components', 'build') } },
        @{ Name = 'an empty backstop'; Change = @{ backstop = @{} } },
        @{ Name = 'a zero merge bound'; Change = @{ backstop = @{ merges = 0 } } },
        @{ Name = 'a negative day bound'; Change = @{ backstop = @{ days = -1 } } },
        @{ Name = 'a fractional bound'; Change = @{ backstop = @{ days = 1.5 } } },
        @{ Name = 'a string bound'; Change = @{ backstop = @{ merges = '10' } } },
        @{ Name = 'an unknown backstop key'; Change = @{ backstop = @{ weeks = 1 } } },
        @{ Name = 'an unknown policy key'; Change = @{ checkpointAfter = @('release') } }
    ) {
        $policy = @{ mode = 'checkpoint'; integrationBranch = 'develop'; perMerge = @('build', 'lint', 'smoke', 'changed-components'); checkpointBefore = @('release') }
        if ($Remove) { $policy.Remove($Remove) }
        foreach ($key in $Change.Keys) { $policy[$key] = $Change[$key] }
        $json = @{ version = 1; scope = 'project'; testing = @{ fullSuite = $policy } } | ConvertTo-Json -Depth 8
        Test-Json -Json $json -SchemaFile $script:schema -ErrorAction SilentlyContinue | Should -BeFalse
    }
}
