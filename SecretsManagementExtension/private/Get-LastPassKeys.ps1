function Get-LastPassKeys {
    <#
        .Synopsis
            Gets the latest LastPass keys
    #>
    [CmdletBinding()]
    param(
        $BaseUrl = "https://lastpass.com",
        $UserAgent = "LastPass-CLI/1.2.1",
        $WebSession = (New-Object -TypeName Microsoft.PowerShell.Commands.WebRequestSession)
    )
    begin {
        $WebRequestShared = @{
            UserAgent       = $UserAgent
            WebSession      = $WebSession
            UseBasicParsing = $true
        }
    }
    process {
        if (-not $script:LastPassKeys) {
            Write-Verbose "Getting LastPass Iterations for '$((Get-LastPassLogin).UserName)'"
            $IterationsRequest = @{
                Uri    = "$BaseURL/iterations.php"
                Method = "POST"
                Body   = @{
                    username = (Get-LastPassLogin).UserName.ToLower()
                }
            }

            $IterationsResponse = Invoke-WebRequest @IterationsRequest @WebRequestShared

            $Iterations = switch ($IterationsResponse.Content) {
                1 { "5000" }
                default { $IterationsResponse.Content }
            }

            Write-Verbose "Producing LastPass Keys for '$((Get-LastPassLogin).UserName)'"
            $UsernameBytes = $BasicEncoding.GetBytes((Get-LastPassLogin).UserName.ToLower())
            $PasswordBytes = $BasicEncoding.GetBytes((Get-LastPassLogin).GetNetworkCredential().Password)

            $KeyPBKDF2 = [System.Security.Cryptography.PBKDF2]::new($PasswordBytes, $UsernameBytes, $Iterations, "HMACSHA256")
            $KeyBytes = $KeyPBKDF2.GetBytes(32)
            $KeyString = $BasicEncoding.GetString($KeyBytes) | ConvertTo-SecureString -AsPlainText -Force

            $LoginPBKDF2 = [System.Security.Cryptography.PBKDF2]::new($KeyBytes, $PasswordBytes, 1, "HMACSHA256")
            $LoginBytes = $LoginPBKDF2.GetBytes(32)
            $LoginString = [System.BitConverter]::ToString($LoginBytes).Replace("-", "").ToLower()

            $script:LastPassKeys = @{
                iter = $Iterations
                keys = [PSCredential]::new($LoginString, $KeyString)
            }
        }
        $script:LastPassKeys
    }
}