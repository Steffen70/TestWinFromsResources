# Project Setup Instructions

## Overview

This project involves a custom build process where a resource designer is generated using PowerShell scripts during the compilation of a .NET project. The scripts are responsible for handling resources and are essential for the proper functioning of the project.

## Prerequisites

- **PowerShell Version**: Ensure you have PowerShell version 7.4.1 installed to match the .NET 8.0 target version.
- **.NET Version**: This project targets .NET 8.0.

## Installation

1. **Install PowerShell 7.4.1**:
    - Download and install PowerShell 7.4.1
    - Make sure it is added to your system's PATH.

2. **NuGet Cache Location**:
    - Confirm that your NuGet cache is located at the default location: `%userdir%\.nuget\packages\`.
    - This is crucial for PowerShell to load project's private assets from the NuGet cache, especially `System.CodeDom`.

## Build Process

During the build process, the following PowerShell scripts are executed:

- `GenerateResx.ps1`: Generates resources from the `Resources` directory.
- `GenerateResxDesigner.ps1`: Generates a resource designer file based on the project file and base namespace.

These scripts are triggered automatically as part of the MSBuild process, as specified in the project file.

These scripts allow us to replace the default software icons with customer-specific icons. The icons are stored in the `Resources` directory and are embedded into the assembly as resources.
This complicated process is necessary to ensure we can access the icons easily in our dotnet-core backend (without DevExpress references) and in our Forms frontend (with DevExpress references).

## Known Issue & Solution

### Issue Description

When adding a reference to this assembly in a different solution and attempting to load images from the assembly to the ImageCollection using ImageCollection tasks menu, the following warning appears: "No referenced assembly with images is found".

(DX version 23.2.3)