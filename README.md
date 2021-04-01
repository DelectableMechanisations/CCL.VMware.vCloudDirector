# CCL.VMware.vCloudDirector

Contains functions used to manage a VMware vCloud Director tenant and is designed to supplement VMware's VMware.VimAutomation.Cloud module.
All functions have been designed for use by an Organisation Administrator and so vCloud Administrator permissions are not required.

## Installation

Install VMware's vCloud Director module and then this module.

```powershell
Install-Module VMware.VimAutomation.Cloud
Install-Module CCL.VMware.vCloudDirector
```

## Examples

Note: Before using any of these examples you'll need to connect to your vCloud Director organisation:

```powershell
Connect-CIServer -Server vcloud.mycompany.co.nz -Org corp -Credential (Get-Credential)
```

### Example 1

Uploads the 'C:\Temp\Windows2016Installer.iso' ISO media file to the vCloud Director catalog 'Christchurch Generic Catalog'.

```powershell
Add-CIMediaIso -Path 'C:\Temp\Windows2016Installer.iso' -CatalogName 'Christchurch Generic Catalog' -Description 'Official installation media for Windows Server 2016'
```

### Example 2

Returns the Compute Policy applied to VM 'Server01'.

```powershell
Get-CIVM Server01 | Get-CIVMComputePolicy | Format-Table -Property *
```

### Example 3

Returns the CPU details for the VM 'Server01'

```powershell
Get-CIVM Server01 | Get-CIVMCpu
```

### Example 4

Returns all Hard Disks attached to the VM 'Server01'

```powershell
Get-CIVM Server01 | Get-CIVMHardDisk | Format-Table -Property *
```

### Example 5

Returns all metadata configured on the VM 'Server01'

```powershell
Get-CIVM Server01 | Get-CIVMMetaData | Format-Table -Property *
```

### Example 6

Returns the snapshot details for VM 'Server01'.

```powershell
Get-CIVM -Name 'Server01' | Get-CIVMSnapshot
```

### Example 7

Returns all Compute Policies in all Vdcs.

```powershell
Get-OrgVdc | Get-OrgVdcComputePolicy | Format-Table -Property *
```

### Example 8

Returns the Compute Policies available for all Vdcs.

```powershell
Get-OrgVdc | Get-OrgVdcComputePolicy | Format-Table -Property *
```

### Example 9

Changes the Compute Policy applied to VM 'Server01'.

```powershell
$OrgVdc = Get-OrgVdc | Where-Object {$_.name -eq 'MyVdc'}
$ComputePolicy = Get-OrgVdcComputePolicy -OrgVdc $OrgVdc -Name 'MyComputePolicy'

Get-CIVM -Name 'Server01' | Set-CIVMComputePolicy -ComputePolicy $ComputePolicy
```
