@{
    ModuleVersion          = "0.0.1"

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules   = @()

    # Functions to export. Populated by Optimize-Module during the build step.
    # For best performance, do not use wildcards and do not delete this entry!
    # Use an empty array if there is nothing to export.
    FunctionsToExport      = @()

    # Cmdlets to export.
    # For best performance, do not use wildcards and do not delete this entry!
    # Use an empty array if there is nothing to export.
    CmdletsToExport        = @()

    # Aliases to export.
    # For best performance, do not use wildcards and do not delete this entry!
    # Use an empty array if there is nothing to export.
    AliasesToExport        = @()

    # ID used to uniquely identify this module
    GUID                   = '76da33a8-24e4-4b97-95ec-14f9287fa66e'
    Description            = 'A Proof of Concept for a LastPass Secrets Management provider.'

    # The main script or binary module that is automatically loaded as part of this module
    #RootModule             = 'SecretsManagement.LastPass.psm1'

    # Common stuff for all our modules:
    Author                 = 'James Ruskin'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion      = '5.1'
}