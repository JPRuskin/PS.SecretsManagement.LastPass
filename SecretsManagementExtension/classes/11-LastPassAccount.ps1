class LastPassAccount {
    [string]$ID
    [string]$Name
    [string]$Group
    [string]$URL
    [string[]]$Notes
    [PSCredential]$Credential
    [string]$Username
    [securestring]$Password
    [securestring]$SecureNote

    <# Constructors #>

    # Blank
    LastPassAccount () {}

    # Encrypted (or not) split values
    LastPassAccount (
        $ID,
        $Name,
        $Group,
        $URL,
        $Notes,
        $Username,
        $Password,
        $SecureNote
    ) {
        $this.ID = $ID | ConvertFrom-LastPassEncryptedString
        $this.Name = $Name | ConvertFrom-LastPassEncryptedString <#-Key $SharingKey#>
        $this.Group = $Group | ConvertFrom-LastPassEncryptedString <#-Key $SharingKey#>
        $this.URL = $URL | ConvertFrom-LastPassEncryptedString | ConvertFrom-LastPassHexString
        $this.Notes = $Notes | ConvertFrom-LastPassEncryptedString <#-Key $SharingKey#>
        $this.Username = $Username | ConvertFrom-LastPassEncryptedString <#-Key $SharingKey#>
        $this.Password = $Password | ConvertFrom-LastPassEncryptedString <#-Key $SharingKey#> | ConvertTo-SecureString -AsPlainText -Force -ErrorAction SilentlyContinue
        $this.SecureNote = $SecureNote | ConvertFrom-LastPassEncryptedString | ConvertTo-SecureString -AsPlainText -Force -ErrorAction SilentlyContinue

        if ($this.Username -and $this.Password) {
            $this.Credential = [PSCredential]::new(
                $this.Username,
                $this.Password
            )
        }
    }

    # Vault Entry
    LastPassAccount (
        $ID,
        $Length,
        $Data
    ) {
        if ($ID -ne 'ACCT') {
            Write-Warning "This is not an account."
            return
        }
        $UnrolledData = ConvertFrom-LastPassEncryptedAccountData -InputObject $Data

        $this.ID = $UnrolledData[0] | ConvertFrom-LastPassEncryptedString
        $this.Name = $UnrolledData[1] | ConvertFrom-LastPassEncryptedString <#-Key $SharingKey#>
        $this.Group = $UnrolledData[2] | ConvertFrom-LastPassEncryptedString <#-Key $SharingKey#>
        $this.URL = $UnrolledData[3] | ConvertFrom-LastPassEncryptedString | ConvertFrom-LastPassHexString
        $this.Notes = $UnrolledData[4] | ConvertFrom-LastPassEncryptedString <#-Key $SharingKey#>
        $this.Username = $UnrolledData[7] | ConvertFrom-LastPassEncryptedString <#-Key $SharingKey#>
        $this.Password = $UnrolledData[8] | ConvertFrom-LastPassEncryptedString <#-Key $SharingKey#> | ConvertTo-SecureString -AsPlainText -Force -ErrorAction SilentlyContinue
        $this.SecureNote = $UnrolledData[11] | ConvertFrom-LastPassEncryptedString | ConvertTo-SecureString -AsPlainText -Force -ErrorAction SilentlyContinue

        if ($this.Username -and $this.Password) {
            $this.Credential = [PSCredential]::new(
                $this.Username,
                $this.Password
            )
        }
    }

    LastPassAccount (
        $Data
    ) {
        if ($Data.Data) {
            if ($Data.ID -ne 'ACCT') {
                Write-Warning "This is not an account."
                return
            }
            $UnrolledData = ConvertFrom-LastPassEncryptedAccountData -InputObject $Data.Data
        } else {
            $UnrolledData = ConvertFrom-LastPassEncryptedAccountData -InputObject $Data
        }

        $this.ID = $UnrolledData[0] | ConvertFrom-LastPassEncryptedString
        $this.Name = $UnrolledData[1] | ConvertFrom-LastPassEncryptedString <#-Key $SharingKey#>
        $this.Group = $UnrolledData[2] | ConvertFrom-LastPassEncryptedString <#-Key $SharingKey#>
        $this.URL = $UnrolledData[3] | ConvertFrom-LastPassEncryptedString | ConvertFrom-LastPassHexString
        $this.Notes = $UnrolledData[4] | ConvertFrom-LastPassEncryptedString <#-Key $SharingKey#>
        $this.Username = $UnrolledData[7] | ConvertFrom-LastPassEncryptedString <#-Key $SharingKey#>
        $this.Password = $UnrolledData[8] | ConvertFrom-LastPassEncryptedString <#-Key $SharingKey#> | ConvertTo-SecureString -AsPlainText -Force -ErrorAction SilentlyContinue
        $this.SecureNote = $UnrolledData[11] | ConvertFrom-LastPassEncryptedString | ConvertTo-SecureString -AsPlainText -Force -ErrorAction SilentlyContinue

        if ($this.Username -and $this.Password) {
            $this.Credential = [PSCredential]::new(
                $this.Username,
                $this.Password
            )
        }
    }

}