function Get-ResourceList {
    param(
        [string]$resourceDir
    )

    $resourceList = @()

    Get-ChildItem -Path $resourceDir -Include *.png -Recurse | ForEach-Object {
        $base64Content = [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($_.FullName))
        $resourceList += New-Object PSObject -Property @{
            ResourcePath = $_.FullName
            Base64Content = $base64Content
        }
    }

    return $resourceList
}