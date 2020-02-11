@{
    ModuleVersion = '1.0'
    RootModule = '.\ImplementingModule.psm1'
    PowershellVersion = '5.1'
    RequiredModules = @()
    FunctionsToExport = @('Set-Secret','Get-Secret','Remove-Secret','Get-SecretInfo')
}
