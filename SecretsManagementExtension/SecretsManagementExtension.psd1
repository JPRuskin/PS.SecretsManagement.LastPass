@{
    ModuleVersion      = '0.0.1'

    RootModule         = '.\SecretsManagementExtension.psm1'

    FunctionsToExport  = @('Set-Secret', 'Get-Secret', 'Remove-Secret', 'Get-SecretInfo')

    RequiredModules    = @(
        #"Configuration"
    )

    RequiredAssemblies = @(
        ".\lib\PBKDF2.NET.dll"
    )
}
