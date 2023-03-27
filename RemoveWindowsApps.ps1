
#git clone https://github.com/Sycnex/Windows10Debloater Debload Software
Get-AppxPackage | Remove-AppxPackage
Get-AppXPackage WindowsStore -AllUsers | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
