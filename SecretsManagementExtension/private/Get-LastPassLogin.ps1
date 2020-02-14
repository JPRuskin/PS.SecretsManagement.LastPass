function Get-LastPassLogin {
    <#
        .Synopsis
            Prompts the user to enter credentials for logging into and/or decrypting LastPass

        .Description
            This is stored in memory, within the module. Should probably do better.
    #>
    [CmdletBinding()]
    param(
        [PSCredential]$Credential
    )
    end {
        if (-not $script:LastPassCredential) {
            if (-not $Credential) {
                $Credential = Get-Credential -Message "LastPass Login"
            }
            $script:LastPassCredential = $Credential
        }

        $script:LastPassCredential
    }
}