# Importieren des Active Directory Moduls
#Import-Module ActiveDirectory

$results = @()

# Abrufen aller Computer aus dem AD
$computers = Get-ADComputer -Filter * -Property *

foreach ($computer in $computers) {
    $os = $computer.OperatingSystem
    $lastLogonDate = $computer.LastLogonDate

    # Hinzuf�gen der Computerinformationen zum Ergebnisarray
    $results += New-Object PSObject -Property @{
        'Computer' = $computer.Name
        'Betriebssystem' = $os
        'Letzte Verwendung' = $lastLogonDate
    }
}

# Sortieren der Ergebnisse nach dem Datum der letzten Verwendung und Ausgabe als Tabelle
$results | Sort-Object 'Letzte Verwendung' -Descending | Format-Table -AutoSize
pause