@{
    RootModule = 'AaFeatures.psm1'
    ModuleVersion = '0.1.2'
    GUID = '47df87f6-b73d-4ddb-ba47-02f335123463'
    Author = 'DevPossible'
    Description = 'Versioned feature-page conversion and provenance tooling.'
    PowerShellVersion = '7.4'
    FunctionsToExport = @('ConvertTo-FeaturePage', 'ConvertFrom-FeaturePage', 'Test-FeatureProvenance', 'Get-FeatureChecksum')
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
}
