# Define file paths
$scriptDir = $PSScriptRoot
Write-Host "Script is located at: $scriptDir"

$xmlPath = $scriptDir + "/EFI/OC/config.plist"
$configPath = $scriptDir + "/SMBIOS.config"

$search = "<key>KEY_VALUE</key>
                <TYPE_VALUE>REPLACE_VALUE</TYPE_VALUE>"

# Load XML
$xmlText = Get-Content $xmlPath -Raw
$configText = Get-Content $configPath -Raw

$configDoc = New-Object System.Xml.XmlDocument
$configDoc.LoadXml($configText)

# Read config file
foreach ($key in $configDoc.SelectNodes("//keys/key")) {
    Write-Host $key.name

    $searchText = $search.Replace('KEY_VALUE', $key.name).Replace('TYPE_VALUE', $key.type).Replace('REPLACE_VALUE', $key.replace)
    Write-Host $searchText

    $replaceText = $search.Replace('KEY_VALUE', $key.name).Replace('TYPE_VALUE', $key.type).Replace('REPLACE_VALUE', $key.value)
    Write-Host $replaceText

    $xmlText = $xmlText.Replace($searchText, $replaceText)
}

# Save updated config
$writer = [System.IO.StreamWriter]::new($xmlPath, $false)
$writer.Write($xmlText)
$writer.Close()
Write-Host "XML updated successfully."