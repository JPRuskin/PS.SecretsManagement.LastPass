function Set-Secret {
    <#
        .Synopsis
            This function stores a secret object to the vault.

        .Description
            The function returns a boolean true on success and false otherwise.
    #>
    [OutputType([bool])]
    [CmdletBinding()]
    param (
        # The name of the secret to store
        [Parameter(Mandatory)]
        [string]$Name,

        # The secret object to be stored
        [Parameter(Mandatory)]
        [object]$Secret,

        # An optional dictionary (Hashtable) of name/value pairs for additional parameters
        [hashtable]$AdditionalParameters
    )
    end {
        return [bool]$Success
    }
}