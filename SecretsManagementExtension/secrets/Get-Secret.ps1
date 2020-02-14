function Get-Secret {
    <#
        .Synopsis
            This function returns a single secret object from the vault.

        .Description
            The function returns a single secret object or null if secret name does not exist.
    #>
    #[OutputType([SecureString], [PSCredential])]  # ??
    [CmdletBinding()]
    param (
        # The name of the secret to get
        [Parameter(Mandatory)]
        [string]$Name,

        # An optional dictionary (Hashtable) of name/value pairs for additional parameters
        [hashtable]$AdditionalParameters
    )
    end {
        return (Get-LastPassAccounts).Where({ $_.Name -eq $Name }, "First", 1)
    }
}