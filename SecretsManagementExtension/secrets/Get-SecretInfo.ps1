function Get-SecretInfo {
    <#
        .Synopsis
            Returns an array of string pairs representing each secret.

        .Description
            This function never returns the actual secret object, but only information about the secret.
    #>
    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        # Which secrets to display information about, defaults to '*' (all)
        [string]$Filter = "*",

        # An optional dictionary (Hashtable) of name/value pairs for additional parameters
        [hashtable]$AdditionalParameters
    )
    end {
        $MatchingSecrets = Get-LastPassAccounts | Where-Object -Property Name -like $Filter

        foreach ($Secret in $MatchingSecrets) {
            [PSCustomObject]@{
                Name  = $Secret.Name
                Value = $(
                    if (-not $Secret.Username -and $Secret.Password -or $Secret.SecureNote) {
                        "securestring"
                    } elseif ($Secret.Credential) {
                        "PSCredential"
                    } else {
                        "hashtable"
                    }
                    <#
                    switch ($Secret) {
                        # Could use GetType().Name, if we could guarantee the right types within - unsure what LastPass will spit out
                        "byte" { return "ByteArray" }
                        "string" { return "String" }
                        "securestring" { return "SecureString" }
                        "PSCredential" { return "PSCredential" }
                        "hashtable" { return "Hashtable" }
                        default { return "Unknown" }
                    }#>
                )
            }
        }
    }
}