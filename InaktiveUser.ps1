$d = [DateTime]::Today.AddDays(-365)
Get-ADUser -Filter {((LastLogonTimestamp -lt $d) -and (Enabled -eq $true)) -and (-not (Name -like "*HealthMailbox*")) -and (-not (Name -like "IUSR_*"))} -Properties LastLogonTimestamp,Enabled | Sort-Object LastLogonTimestamp | ft Name, @{N="LastLogonTimestamp";E={[datetime]::FromFileTime($_.LastLogonTimestamp)}}, Enabled
pause