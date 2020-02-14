function ConvertFrom-LastPassEncryptedString {
    <#
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$InputObject,
        [string]$Key = (Get-LastPassKeys).Keys.GetNetworkCredential().Password
    )
    begin {
        $KeyBytes = $BasicEncoding.GetBytes($Key)
    }
    process {
        if (($InputObject[0] -eq '!') -and (($InputObject.Length % 16) -eq 1) -and ($InputObject.Length -gt 32)) {
            Write-Debug "Decrypting using AES"
            $StringBytes = $BasicEncoding.GetBytes($InputObject)
            $AES = New-Object -TypeName "System.Security.Cryptography.AesManaged"
            $AES.Key = $KeyBytes
            $AES.IV = $StringBytes[1..16]
            $AES.Padding = [System.Security.Cryptography.PaddingMode]::PKCS7

            $Decryptor = $AES.CreateDecryptor()
            $PlainBytes = $Decryptor.TransformFinalBlock($StringBytes, 17, $($StringBytes.Length - 17))

            $OutString = $TextEncoding.GetString($PlainBytes)

            $Decryptor.Dispose()
            $AES.Dispose()
        } else {
            Write-Debug "Not AES encrypted, returning unaltered string"
            $OutString = $InputObject
        }

        $OutString.Trim([byte]0)
    }
}