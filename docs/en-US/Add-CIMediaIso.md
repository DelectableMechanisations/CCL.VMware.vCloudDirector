---
external help file: CCL.VMware.vCloudDirector-help.xml
Module Name: CCL.VMware.vCloudDirector
online version:
schema: 2.0.0
---

# Add-CIMediaIso

## SYNOPSIS
This function adds an ISO media file to a vCloud Director catalog.

## SYNTAX

```
Add-CIMediaIso [-Path] <String> [-CatalogName] <String> [[-Description] <String>] [<CommonParameters>]
```

## DESCRIPTION
This function adds an ISO media file to a vCloud Director catalog.
Note: You must have the 'VMware.VimAutomation.Cloud' module installed and be connected to a vCloud Director organisation before running this command.

## EXAMPLES

### EXAMPLE 1
```
Add-CIMediaIso -Path 'C:\Temp\Windows2016Installer.iso' -CatalogName 'Christchurch Generic Catalog' -Description 'Official installation media for Windows Server 2016'
```

Uploads the 'C:\Temp\Windows2016Installer.iso' ISO media file to the vCloud Director catalog 'Christchurch Generic Catalog' and adds a description.

### EXAMPLE 2
```
Connect-CIServer -Server vcloud.mycompany.co.nz -Org corp -Credential (Get-Credential)
Add-CIMediaIso -Path 'C:\Temp\Windows2016Installer.iso' -CatalogName 'Christchurch Generic Catalog' -Description 'Official installation media for Windows Server 2016'
```

Uploads the 'C:\Temp\Windows2016Installer.iso' ISO media file to the vCloud Director catalog 'Christchurch Generic Catalog'.

## PARAMETERS

### -Path
The path to the ISO media file that to upload to a vCloud Directory catalog.
This must have a '.iso' file extension and be a valid path.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CatalogName
The name of the vCloud Director catalog that will store the ISO media file.
This must be a valid vCloud Director catalog name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
The optional description to add to the ISO media once it has been uploaded to the vCloud Director catalog.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Developed with help from the following documentation:
https://code.vmware.com/doc/preview?id=6899#/doc/GUID-4DAFB730-9C5B-406E-8348-E42B9036B49A.html

## RELATED LINKS
