# Module may need to be renamed to SecretsManagementExtension in the future
# Currently based on https://devblogs.microsoft.com/powershell/secrets-management-module-vault-extensions/
# which references https://github.com/PowerShell/Modules/tree/master/Samples/VaultExtension/Modules/ScriptLocalVault

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
        return $Secret
    }
}

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
        $MatchingSecrets = @(
            @{
                # Should be a Get-LastPassSecret
                Title = 'TestSecret'
                Value = 'ThisIsAString'
            }
        ) | Where-Object Title -like $Filter

        foreach ($Secret in $MatchingSecrets) {
            [PSCustomObject]@{
                Name  = $Secret.Title
                Value = $(
                    switch ($Secret.Value.GetType().Name) {
                        # Could use GetType().Name, if we could guarantee the right types within - unsure what LastPass will spit out
                        "byte" { return "ByteArray" }
                        "string" { return "String" }
                        "securestring" { return "SecureString" }
                        "PSCredential" { return "PSCredential" }
                        "hashtable" { return "Hashtable" }
                        default { return "Unknown" }
                    }
                )
            }
        }
    }
}