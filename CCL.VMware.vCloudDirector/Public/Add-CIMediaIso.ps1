<#
    .SYNOPSIS
        This function adds an ISO media file to a vCloud Director catalog.

    .DESCRIPTION
        This function adds an ISO media file to a vCloud Director catalog.
        Note: You must have the 'VMware.VimAutomation.Cloud' module installed and be connected to a vCloud Director organisation before running this command.

    .PARAMETER Path
        The path to the ISO media file that to upload to a vCloud Directory catalog. This must have a '.iso' file extension and be a valid path.

    .PARAMETER CatalogName
        The name of the vCloud Director catalog that will store the ISO media file. This must be a valid vCloud Director catalog name.

    .PARAMETER Description
        The optional description to add to the ISO media once it has been uploaded to the vCloud Director catalog.

    .EXAMPLE
        Add-CIMediaIso -Path 'C:\Temp\Windows2016Installer.iso' -CatalogName 'Christchurch Generic Catalog' -Description 'Official installation media for Windows Server 2016'

        Uploads the 'C:\Temp\Windows2016Installer.iso' ISO media file to the vCloud Director catalog 'Christchurch Generic Catalog' and adds a description.

    .EXAMPLE
        Connect-CIServer -Server vcloud.mycompany.co.nz -Org corp -Credential (Get-Credential)
        Add-CIMediaIso -Path 'C:\Temp\Windows2016Installer.iso' -CatalogName 'Christchurch Generic Catalog' -Description 'Official installation media for Windows Server 2016'

        Uploads the 'C:\Temp\Windows2016Installer.iso' ISO media file to the vCloud Director catalog 'Christchurch Generic Catalog'.

    .NOTES
        Developed with help from the following documentation:
        https://code.vmware.com/doc/preview?id=6899#/doc/GUID-4DAFB730-9C5B-406E-8348-E42B9036B49A.html
#>
Function Add-CIMediaIso {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)]
        [ValidateScript({(Test-Path -Path $_) -and ($_ -like '*.iso')})]
        [System.String]
        $Path,

        [Parameter(Mandatory=$true)]
        [ValidateScript({(Get-Catalog -Name $_).Count -eq 1})]
        [System.String]
        $CatalogName,

        [Parameter()]
        [System.String]
        $Description
    )

    Begin {
        #Disable the Progress Bar because the Invoke-WebRequest cmdlet runs very slowly if you don't.
        $ProgressPreference = 'SilentlyContinue'

        #Create authorisation headers used to connect to vCloud Director
        $headers = Get-vCloudDirectorLogonHeaders
    }

    Process {
        $file = Get-Item -Path $Path

        Write-Verbose -Message "Searching for catalog '$CatalogName'."
        $catalogInstance = Get-Catalog -Name $CatalogName

        #1 Find the add link for media in the target catalog.
        $catalogAddUrl = $catalogInstance.ExtensionData.Link | Where-Object {$_.Rel -eq 'add' -and $_.Type -eq 'application/vnd.vmware.vcloud.media+xml'}
        if (-not $catalogAddUrl) {
            throw "Unable to identify the add link for the target catalog. Confirm you have the correct permissions to perform this action."
        }

        #Define the XML data that will be used to create the media.
        $mediaXml = @"
<?xml version="1.0" encoding="UTF-8"?>
<Media
   xmlns="http://www.vmware.com/vcloud/v1.5"
   name="$($file.Name)"
   size="$($file.Length)"
   imageType="iso">
   <Description>$Description</Description>
</Media>
"@

        #2 POST an action/upload request to the URL.
        #The server uses this information to create a CatalogItem and corresponding Media object, then returns the CatalogItem in its response.
        Write-Verbose -Message "Creating a CatalogItem and corresponding Media object in '$($catalogAddUrl.Href)'."
        $response = Invoke-WebRequest -Uri $catalogAddUrl.Href -Headers $headers -Method 'Post' -Body $mediaXml -ContentType 'application/vnd.vmware.vcloud.media+xml' -UseBasicParsing -Verbose:$VerbosePreference
        [Xml]$responseXml = $response.Content

        #3 Use the URL in the Entity element of the CatalogItem to retrieve the Media object.
        $response = Invoke-WebRequest -Uri $responseXml.CatalogItem.Entity.href -Headers $headers -Method 'Get' -UseBasicParsing -Verbose:$VerbosePreference
        [Xml]$responseXml = $response.Content

        #4 PUT the media file contents to the upload:default link in the response.
        Write-Verbose -Message "Uploading '$($file.FullName)' to '$($responseXml.Media.Files.File.Link.href)'."
        $headers['Content-length'] = $file.Length
        $response = Invoke-WebRequest -Uri $responseXml.Media.Files.File.Link.href -Headers $headers -Method 'Put' -InFile $file.FullName -UseBasicParsing -Verbose:$VerbosePreference
    }

    End {}
}
