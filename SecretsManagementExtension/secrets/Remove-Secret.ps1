function Remove-Secret {
    <#
        .Synopsis
            This function removes a single secret from the vault.

        .Description
            The function returns a boolean true on success and false otherwise.
    #>
    [OutputType([bool])]
    [CmdletBinding()]
    param (
        # The name of the secret to remove
        [Parameter(Mandatory)]
        [string]$Name,

        # An optional dictionary (Hashtable) of name/value pairs for additional parameters
        [hashtable]$AdditionalParameters
    )
    end {
        return [bool]$Success
    }
}