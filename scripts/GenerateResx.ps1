param(
    [string]$resourceDir
)

$resourceDir = Resolve-Path $resourceDir
$resxTempFile = ".\Properties\Resources.resx.temp"
$resxFile = ".\Properties\Resources.resx"

# Force delete .resx file if it exist
if (Test-Path $resxFile) {
    Remove-Item $resxFile -Force
}

# Create resxTempFile empty
# hide echo output
$null = New-Item -Path $resxTempFile -ItemType "file"

$resxTempFile = Resolve-Path $resxTempFile

Add-Type -AssemblyName System.Windows.Forms

$resx = New-Object System.Resources.ResXResourceWriter($resxTempFile)

Get-ChildItem -Path $resourceDir -Include *.png -Recurse | ForEach-Object {
    $filePath = $_.FullName

    if (Test-Path $filePath) {
        $bitmap = New-Object System.Drawing.Bitmap($filePath)

        # Get filename from path without extension
        $resourceName = [System.IO.Path]::GetFileNameWithoutExtension($filePath)

        $resx.AddResource($resourceName, $bitmap)

        Write-Host "Resource $filePath added"
    } else {
        Write-Host "File $filePath not found"
    }
}

$resx.Close()

$resxFile = [System.IO.Path]::GetFileName($resxFile)

Rename-Item -Path $resxTempFile -NewName $resxFile -Force

Write-Host "Resource file $resxFile created successfully."
