function ConvertFrom-LastPassEncryptedAccountData {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [Alias('Data')]
        $InputObject
    )
    process {
        $AccountCursor = 0
        $AccountData = @()

        $AccountBytes = $BasicEncoding.GetBytes($InputObject)

        while ($AccountCursor -lt $AccountBytes.Count) {
            $Length = [System.BitConverter]::ToUInt32($AccountBytes[$($AccountCursor + 3)..$AccountCursor], 0)
            $AccountCursor = $AccountCursor + 4

            $DataItem = $BasicEncoding.GetString($AccountBytes[$AccountCursor..$($AccountCursor + $Length - 1)])
            $AccountCursor = $AccountCursor + $Length

            $AccountData += $DataItem
        }

        $AccountData
    }
}