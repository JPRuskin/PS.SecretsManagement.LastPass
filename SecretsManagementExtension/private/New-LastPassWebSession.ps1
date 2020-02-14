function New-LastPassWebSession {
    <#
        .Synopsis
            Logs in to LastPass, returns the WebSession object
    #>
    [CmdletBinding()]
    param(
        $BaseUrl = "https://lastpass.com",
        $UserAgent = "LastPass-CLI/1.2.1",
        $WebSession = (New-Object -TypeName Microsoft.PowerShell.Commands.WebRequestSession)
    )
    end {
        $Keys = Get-LastPassKeys -WebSession $WebSession

        $WebRequestSettings = @{
            UserAgent       = $UserAgent
            WebSession      = $WebSession
            UseBasicParsing = $true
        }

        $LoginRequest = @{
            Uri    = "$BaseUrl/login.php"
            Method = "POST"
            Body   = @{
                xml                  = 2;
                username             = (Get-LastPassLogin).UserName.ToLower()
                hash                 = $Keys.keys.UserName
                iterations           = $Keys.iter
                includeprivatekeyenc = 1
                method               = "cli"
                outofbandsupported   = 1
            }
        }

        [xml]$Result = ($global:LPResponse = Invoke-WebRequest @LoginRequest @WebRequestSettings).content

        <#
        if (-not $Result.response.error -and $Result.response.ok) {
            Write-Verbose "Hooray!"
        } else {
            Seems to be a lot of error handling, here
            "LastPassInvalidUsername" {}
            "LastPassInvalidPassword" {}
            "LastPassIncorrectGoogleAuthenticatorCode" {}
            "LastPassIncorrectYubikeyPassword" {}
            "LastPassOutOfBandAuthenticationRequired" {}
            "LastPassOutOfBandAuthenticationFailed" {}
            "LastPassOther" {} # Message property contains the message given by the LastPass server
            "LastPassUnknown" {}

            # Other
            "UnsupportedFeature" {}
            "UnknownResponseSchema" {}
            "InvalidResponse" {}
            "WebException" {}
            # Write-Error "Something's up"  # Probably improve this with this: https://github.com/ScottEvtuch/PSLastPass/blob/master/Private/Invoke-LPLogin.ps1
        }#>

        switch ($Result.response.error.cause) {
            $null {
                if ($Result.response.ok) {
                    Write-Verbose "Successful login"
                } else {
                    throw "Malformed response from server"
                }
            }

            "outofbandrequired" {
                Write-Host "Out of band authentication is required"
                Write-Verbose "Trying login again with out of band request"
                $LoginRequest.Body.Add("outofbandrequest", 1)
                [xml]$Result = ($global:LPResponse = Invoke-WebRequest @LoginRequest @WebRequestSettings).content

                if ($Result.response.error) {
                    throw "$($Result.response.error.message)"
                }
                if ($Result.response.ok) {
                    Write-Verbose "Successful login"
                } else {
                    throw "Malformed response from server"
                }
            }

            "googleauthrequired" {
                Write-Host "Two-factor authentication is required"
                $2faCode = Read-Host -Prompt "Please provide two-factor code"
                Write-Verbose "Trying login again with two-factor request"
                $LoginBody.Add("otp", $2faCode)
                $LoginResponse = Invoke-WebRequest -Uri "$LPUrl/login.php" -Method Post -Body $LoginBody @WebRequestSettings
                Write-Debug $($LoginResponse | Out-String)

                if ($Result.response.error) {
                    throw "$($Result.response.error.message)"
                }
                if ($Result.response.ok) {
                    Write-Verbose "Sucessful login"
                } else {
                    throw "Malformed response from server"
                }
            }

            "unknownpassword" {
                Write-Host "Invalid LastPass password"
                $script:LPLogin = $null
            }

            default {
                throw "$($Result.response.error.message)"
            }
        }

        return $WebSession
    }
}