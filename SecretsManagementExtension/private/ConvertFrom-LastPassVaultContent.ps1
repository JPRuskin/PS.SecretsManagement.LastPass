function ConvertFrom-LastPassVaultContent {
    <#
        .Synopsis
            Converts vault from a web stream to secrets
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [Alias('VaultContent')]
        $InputObject
    )
    end {
        $VaultBytes = $BasicEncoding.GetBytes($InputObject)

        $VaultCursor = 0

        Write-Verbose "Iterating through the vault entries"
        while ($VaultCursor -lt $VaultBytes.Count) {
            $ID = $BasicEncoding.GetString($VaultBytes[$VaultCursor..$($VaultCursor + 3)])

            $VaultCursor = $VaultCursor + 4
            $Length = [System.BitConverter]::ToUInt32($VaultBytes[$($VaultCursor + 3)..$VaultCursor], 0)

            $VaultCursor = $VaultCursor + 4
            $Data = $VaultBytes[$VaultCursor..$($VaultCursor + $Length - 1)]
            $VaultCursor = $VaultCursor + $Length

            [PSCustomObject]@{
                ID     = $ID;
                Length = $Length;
                Data   = $BasicEncoding.GetString($Data);
            }
        }
    }
}