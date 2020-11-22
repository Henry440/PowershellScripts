
$TargetDir = "C:\Users\henry\Desktop\Archiv\"
$CleanDir = "C:\Users\henry\Desktop\"        
$TmpDir = Get-Date -Format dd.MM.yyyy_HH.mm.ss
$WhiteList = @("File1.end", "File2.txt", "Folder1", "Folder2")

#Vorbereitung zum Ordner säubern
Set-Location $CleanDir 
New-Item -Name $TmpDir -ItemType Directory -Path $CleanDir
$DateienInOrdner = Get-ChildItem -Path $CleanDir

for($i = 0; $i -lt $DateienInOrdner.Length; $i++){
    $CurrentFile = $DateienInOrdner[$i].Name
    $Match = 0
    for($j = 0; $j -lt $WhiteList.Length; $j++){
        $CurrentWhitelist = $WhiteList[$j]
        if($CurrentFile -match $CurrentWhitelist){
            #Write-Host $CurrentFile -match $CurrentWhitelist
            $Match = 1
        }
    }
    if($Match -eq 0){
        if($CurrentFile -notmatch $TmpDir){
            Move-Item -Path "$CleanDir\$CurrentFile" -Destination "$CleanDir\$TmpDir"
        }
    }
}

Move-Item -Path "$CleanDir\$TmpDir" -Destination $TargetDir 