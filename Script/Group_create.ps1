$groups = @("IT", "Marketing", "Sales", "Finance", "HR", "Non-Admins")

$path = "CN=Users,DC=progetto,DC=com"

foreach ($group in $groups) {
    $samAccountName = "$group" + "Group"
    $description = "This is the $group department group"
    
    New-ADGroup -Name $group -SamAccountName $samAccountName -GroupCategory Security -GroupScope Global -Path $path -Description $description
    Write-Host "Created group: $group"
}