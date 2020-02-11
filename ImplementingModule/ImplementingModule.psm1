function Get-Secret {
    [CmdletBinding()]
    param (
        [string] $Name
    )
    end {
        return $Secret
    }
}

function Set-Secret {
    [CmdletBinding()]
    param (
        [string] $Name,
        [object] $Secret
    )
    end {
        return $Success
    }
}

function Remove-Secret {
    [CmdletBinding()]
    param (
        [string] $Name
    )
    end {
        return $Success
    }
}

function Get-SecretInfo {
    [CmdletBinding()]
    param(
        [string]$Filter
    )
    end {
        $(<# Secrets matching #>).foreach{
            [PSCustomObject]@{
                Name  = $PSItem.Title
                Value = if (-not $PSItem.Username) { 'String' } else { 'PSCredential' }
            }
        }
    }
}
