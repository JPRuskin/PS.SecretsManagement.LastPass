function Get-LastPassVault {
    <#
        .Synopsis
            Gets the latest encrypted LastPass vault
    #>
    [CmdletBinding()]
    param(
        $BaseUrl = "https://lastpass.com",
        $UserAgent = "LastPass-CLI/1.2.1",
        $WebSession = (New-LastPassWebSession)
    )
    end {
        Write-Verbose "Getting vault for '$((Get-LastPassLogin).UserName)'"
        $VaultRequest = @{
            Uri             = "$BaseUrl/getaccts.php"
            Method          = "POST"
            Body            = @{
                mobile     = 1
                requestsrc = "cli"
                hasplugin  = "1.2.1"
            }
            UserAgent       = $UserAgent
            WebSession      = $WebSession
            UseBasicParsing = $true
        }

        $Vault = Invoke-WebRequest @VaultRequest

        ConvertFrom-LastPassVaultContent $Vault.Content
    }
}