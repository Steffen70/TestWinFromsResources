param(
    [string]$projectFile,
    [string]$baseNamespace
)

$codeDom = "System.CodeDom"

. "$PSScriptRoot\GetNugetVersion.ps1"
$versions = Get-NugetVersion -projectFile $projectFile -assemblyNames $codeDom
$codeDomVersion = $versions[$codeDom]

# Define paths
. "$PSScriptRoot\GetNugetResourcePath.ps1"
# default target framework is netstandard2.0
# netstandard2.0 is supported by .Net Core 2.0+ and .Net Framework 4.6.1
$codeDomPath = Get-NugetResourcePath -assemblyName $codeDom -version $codeDomVersion

Add-Type -AssemblyName "System"
Add-Type -AssemblyName "System.Design"
Add-Type -AssemblyName "Microsoft.CSharp"
Add-Type -Path $codeDomPath

$unmatchedElements = @()
$codeProvider = New-Object Microsoft.CSharp.CSharpCodeProvider

$resxFile = Resolve-Path '.\Properties\Resources.resx'

Write-Host "Generating designer file for $resxFile"

if($null -eq $baseNamespace) {
    $projectName = [System.IO.Path]::GetFileNameWithoutExtension($projectFile)
    $baseNamespace = $projectName
}

$namespaceArray = @($baseNamespace, "Properties")

$baseNamespace = $namespaceArray -join '.' 

# Generate the resource class
$codeCompileUnit = [System.Resources.Tools.StronglyTypedResourceBuilder]::Create(
    $resxFile, 
    "Resources",
    $baseNamespace, 
    $codeProvider, 
    $false, 
    [ref]$unmatchedElements)

$fileName = ".\Properties\Resources.Designer.cs"

$writer = New-Object System.IO.StreamWriter($fileName, $false, [System.Text.Encoding]::UTF8)
$codeProvider.GenerateCodeFromCompileUnit($codeCompileUnit, $writer, (New-Object System.CodeDom.Compiler.CodeGeneratorOptions))
$writer.Dispose()

$success = $unmatchedElements.Count -eq 0

if ($success) {
    Write-Host "Designer file $fileName created successfully."
}
else {
    Write-Host "Failed to create the designer file $fileName. Unmatched elements: $($unmatchedElements -join ', ')"
}