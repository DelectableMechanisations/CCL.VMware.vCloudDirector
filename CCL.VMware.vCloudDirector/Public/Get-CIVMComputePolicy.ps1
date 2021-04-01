

<#
    .SYNOPSIS
        This cmdlet retrieves the vCloud Director Compute Policy applied to a VM.

    .DESCRIPTION
        This cmdlet retrieves the vCloud Director Compute Policy applied to one or more VMs.

        You must have an existing vCloud session (Connect-CIServer) for this function to work.

    .EXAMPLE
        Get-CIVM -Name 'Server01' | Get-CIVMComputePolicy

        Returns the Compute Policy applied to VM 'Server01'.

    .EXAMPLE
        $CIVM = Get-CIVM -Name 'Server01'
        Get-CIVMComputePolicy -CIVM $CIVM

        Returns the Compute Policy applied to VM 'Server01' (non-pipeline variation of the previous example).

    .EXAMPLE
        Get-CIVM Server01, Server02 | Get-CIVMComputePolicy | Format-Table -Property *

        Returns the Compute Policy applied to VMs 'Server01' and 'Server02'.

    .PARAMETER CIVM
        Specifies the vCloud Director VM(s) you want to return Compute Policy for.
#>
Function Get-CIVMComputePolicy {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $True)]
        [System.Object[]]
        $CIVM
    )

    Begin {
        $ProgressPreference = 'SilentlyContinue'

        #Terminate if not currently connected to vCloud Director.
        if (-not $global:DefaultCIServers) {
            throw "Get-CIVMHistoricUsageMetric : You are not currently connected to any servers. Please connect first using a Connect cmdlet."
        }

        #Populate the $global:DefaultCIApiVersion variable if it doesn't exist
        if (-not $global:DefaultCIApiVersion) {
            New-Variable -Name DefaultCIApiVersion -Scope Global -Value (Get-vCloudDirectorApiSupportedVersion)
        }

        #Create authorisation headers used to connect to vCloud Director
        $headers = @{
            "x-vcloud-authorization" = $global:DefaultCIServers[0].sessionid
            "Accept"                 = "application/*+xml;version=$global:DefaultCIApiVersion"
        }
    }

    Process {
        foreach ($vm in $CIVM) {
            #Retrieve the vCloud representation of the VM.
            $vCloudVM = Invoke-RestMethod -Headers $headers -Method Get -Uri $vm.Href

            #Output the Compute Policy currently applied to the VM.
            $vCloudVM.Vm.VdcComputePolicy | Select-Object -Property @(
                @{Label = 'VMName'; Expression = {$vm.Name}},
                'name',
                'id',
                'href',
                'type'
            ) | Write-Output
        }
    }
}