$ADUsers = Import-Csv "C:\Users\Administrator\Documents\users.csv"

$UPN = "progetto.com"

foreach ($User in $ADUsers) {
    try {
        $UserParams = @{
            Name = $User.name
            Surname = $User.surname
            DisplayName = "$($User.name) $($User.surname)"
            GivenName = $User.name
            AccountPassword = (ConvertTo-SecureString $User.accountpassword -AsPlainText -Force)
            AuthType = $User.authtype
            ChangePasswordAtLogon = $True
            Description = $User.Description
            Enabled = $True
            KerberosEncryptionType = $User.kerberosencryptiontype
            Path = "CN=Users,DC=progetto,DC=com"
            SamAccountName = $User.name
            UserPrincipalName = "$($User.name)@$UPN"
        }

        if (Get-ADUser -Filter "SamAccountName -eq '$($User.name)'") {
            Write-Host "A user with username $($User.name) already exists in Active Directory." -ForegroundColor Yellow
        
        }
        else {
            New-ADUser @UserParams
            Write-Host "The user $($User.name) is created." -ForegroundColor Green
        }
        
        switch -Wildcard ($User.Description) {
            '*IT account*' {
                $GroupName = 'IT'
            }
            '*Finance account*' {
                $GroupName = 'Finance'
            }
            '*HR account*' {
                $GroupName = 'HR'
            }
            '*Marketing account*' {
                $GroupName = 'Marketing'
            }
            '*Sales account*' {
                $GroupName = 'Sales'
            }
        }

        Add-ADGroupMember -Identity $GroupName -Members $User.Name
        Write-Host "User $($User.Name) added to group $GroupName." -ForegroundColor Cyan        
    }
    catch {
        Write-Host "Failed to create user $($User.name) - $_" -ForegroundColor Red
    }
}
