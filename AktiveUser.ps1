#$d = [DateTime]::Today.AddDays(-365)
#Get-ADUser -Filter {((LastLogonTimestamp -gt $d) -and (Enabled -eq $true)) -and (-not (Name -like "*HealthMailbox*")) -and (-not (Name -like "IUSR_*"))} -Properties LastLogonTimestamp,Enabled | Sort-Object LastLogonTimestamp | ft Name, @{N="LastLogonTimestamp";E={[datetime]::FromFileTime($_.LastLogonTimestamp)}}, Enabled

Add-Type -AssemblyName System.Windows.Forms

$d = [DateTime]::Today.AddDays(-365)
$users = Get-ADUser -Filter {(LastLogonTimestamp -gt $d) -and (-not (Name -like "*HealthMailbox*")) -and (-not (Name -like "IUSR_*"))} -Properties LastLogonTimestamp,Enabled |
Sort-Object LastLogonTimestamp |
Select-Object Name, LastLogonTimestamp, Enabled

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "AD User Logon Report"
$form.Width = 800
$form.Height = 600

# Create a DataGridView
$dataGridView = New-Object System.Windows.Forms.DataGridView
$dataGridView.Dock = [System.Windows.Forms.DockStyle]::Fill
$dataGridView.AutoSizeColumnsMode = [System.Windows.Forms.DataGridViewAutoSizeColumnsMode]::Fill

# Create DataTable
$dataTable = New-Object System.Data.DataTable
$dataTable.Columns.Add("Name", [System.Type]::GetType("System.String"))
$dataTable.Columns.Add("LastLogonTimestamp", [System.Type]::GetType("System.DateTime"))
$dataTable.Columns.Add("Enabled", [System.Type]::GetType("System.Boolean"))

# Populate DataTable
foreach ($user in $users) {
    $row = $dataTable.NewRow()
    $row.Name = $user.Name
    if ($user.LastLogonTimestamp -ne $null) {
        try {
            $row.LastLogonTimestamp = [datetime]::FromFileTime([int64]$user.LastLogonTimestamp)
        } catch {
            $row.LastLogonTimestamp = $user.LastLogonTimestamp
        }
    }
    $row.Enabled = $user.Enabled
    $dataTable.Rows.Add($row)
}

# Bind DataTable to DataGridView
$dataGridView.DataSource = $dataTable

# Add DataGridView to the form
$form.Controls.Add($dataGridView)

# Show the form
$form.Add_Shown({ $form.Activate() })
[System.Windows.Forms.Application]::Run($form)
