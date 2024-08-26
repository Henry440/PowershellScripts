# Importieren des Active Directory-Moduls
Import-Module ActiveDirectory

# Definieren Sie den Zeitraum von 180 Tagen ab heute
$startDate = (Get-Date).AddDays(-90)

# Suchen und filtern Sie die Benutzer im Active Directory
$users = Get-ADUser -Filter {(LastLogonDate -gt $startDate) -and (Enabled -eq $true) -and (Name -like '* *')} -Properties Name, Title, Department, OfficePhone, Mobile

# Erstellen Sie ein Array für die Benutzerinformationen
$userInfo = @()

# Durchlaufen Sie die gefundenen Benutzer und fügen Sie die Informationen dem Array hinzu
foreach ($user in $users) {
    # Überprüfen, ob Position und Abteilung beide null sind oder Telefonnummer null ist
    if (($null -eq $user.Title -and $null -eq $user.Department) -or $null -eq $user.OfficePhone) {
        $userInfo += [PSCustomObject]@{
            Name = $user.Name
            Position = $user.Title
            Abteilung = $user.Department
            Telefonnummer = $user.OfficePhone
            Handynummer = $user.Mobile
        }
    }
}

# Zeigen Sie die Benutzerinformationen in einer Tabelle an
$userInfo | Format-Table -AutoSize

# Entfernen Sie das Active Directory-Modul, wenn es nicht mehr benötigt wird
Remove-Module ActiveDirectory
pause