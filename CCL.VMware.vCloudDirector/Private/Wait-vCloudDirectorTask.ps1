<#
    .SYNOPSIS
        Waits for a vCloud Director Task to complete. Retuns an error if the task status does not return "success".
#>
Function Wait-vCloudDirectorTask {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [ValidateScript({
            if (Test-StringIsUri -String $_.Task.href) {
                $true
            } else {
                throw "The '-Task' parameter does not have a Task.href subproperty of type URI."
            }

            if (-not ([System.String]::IsNullOrWhiteSpace($_.Task.status))) {
                $true
            } else {
                throw "The '-Task' parameter does not have a Task.status subproperty."
            }
        })]
        [System.Xml.XmlDocument]
        $Task,

        [Parameter(Mandatory)]
        [System.Collections.IDictionary]
        $Headers,

        [System.String]
        $TaskDescription = "Waiting for vCloud Director Operation to complete"
    )

    #Wait for the task to finish executing. Check on the task every 6 seconds.
    $loopIteration     = 1
    $maxLoopIterations = 20
    Do {
        Write-Progress -Activity $TaskDescription -CurrentOperation $Task.Task.operation -PercentComplete (Get-Percentage -Count $loopIteration -Total $maxLoopIterations)
        $taskStatus = Invoke-vCloudDirectorWebRequest -Headers $Headers -Method Get -Uri $Task.Task.href -Verbose:$false
        Start-Sleep -Seconds 6
        $loopIteration++

    } Until ($taskStatus.Task.status -eq 'success' -or $loopIteration -eq $maxLoopIterations)

    #If the task still hasn't completed after the alotted time then terminate.
    if ($taskStatus.Task.status -ne 'success') {
        throw "vCloud Director Task failed to complete in the alotted time. Operation: '$($Task.Task.operation)'"
    }
}
