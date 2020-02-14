function ConvertFrom-LastPassHexString {
    <#
        .Synopsis
            Returns the plaintext for a hex string from the LastPass vault
        .DESCRIPTION
            Loops through the hex characters in a string and returns a decoded string.
        .EXAMPLE
            ConvertFrom-LPHexString -String $String
    #>
    [CmdletBinding()]
    Param(
        # The encrypted string to decrypt
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [String]$InputObject
    )

    Process {
        $CharArray = @()

        Write-Debug "Converting from Hex string"
        for ($i = 0; $i -lt $InputObject.Length; $i = $i + 2) {
            if ($BasicEncoding.GetBytes($InputObject.Substring($i, 2)) -ne [byte]16) {
                $CharArray += [char][System.Convert]::ToInt16($InputObject.Substring($i, 2), 16)
            }
        }

        -join $CharArray
    }
}