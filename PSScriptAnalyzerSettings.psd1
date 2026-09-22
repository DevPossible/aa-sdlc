@{
    # Conventions for the repository's PowerShell, enforced by ./build.ps1 -Lint (O-21, R-35).
    # The formatter rules below are what Invoke-Formatter applies; the analyser runs every
    # default rule plus these, at Warning severity and above.
    Severity     = @('Error', 'Warning')
    IncludeRules = @('*')
    ExcludeRules = @(
        'PSAvoidUsingWriteHost',            # the root scripts are consoles for a person; Write-Host is the point
        'PSUseShouldProcessForStateChangingFunctions',
        'PSUseBOMForUnicodeEncodedFile',
        'PSReviewUnusedParameter'            # false positive when a script parameter is read inside a nested function (PSScriptAnalyzer issue 1472)
    )
    Rules        = @{
        PSPlaceOpenBrace           = @{ Enable = $true; OnSameLine = $true; NewLineAfter = $true; IgnoreOneLineBlock = $true }
        PSPlaceCloseBrace          = @{ Enable = $true; NewLineAfter = $false; IgnoreOneLineBlock = $true; NoEmptyLineBefore = $false }
        PSUseConsistentIndentation = @{ Enable = $true; IndentationSize = 4; PipelineIndentation = 'IncreaseIndentationForFirstPipeline'; Kind = 'space' }
        PSUseConsistentWhitespace  = @{ Enable = $true; CheckInnerBrace = $true; CheckOpenBrace = $true; CheckOpenParen = $true; CheckOperator = $false; CheckPipe = $true; CheckSeparator = $true; CheckParameter = $false }
        PSAlignAssignmentStatement = @{ Enable = $false }
        PSUseCorrectCasing         = @{ Enable = $true }
        PSAvoidUsingCmdletAliases  = @{ Enable = $true }
    }
}
