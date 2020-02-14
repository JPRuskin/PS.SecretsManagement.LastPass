function Get-LastPassAccounts {
    <#
        .Synopsis
            Returns account objects from the encrypted vault
        .DESCRIPTION
            Iterates through all of the ACCT objects from the vault, decrypts them
            with the user's key, and then returns an array of objects.
        .EXAMPLE
            Get-LPAccounts
    #>
    [CmdletBinding()]
    Param(
        # Force a refresh
        [Parameter()]
        [switch]$Refresh
    )
    process {
        if (!$LPAccounts -or $Refresh) {
            [LastPassAccount[]]$script:LPAccounts = (Get-LastPassVault).Where{$_.ID -eq 'ACCT'}
        }
        $LPAccounts
    }
}