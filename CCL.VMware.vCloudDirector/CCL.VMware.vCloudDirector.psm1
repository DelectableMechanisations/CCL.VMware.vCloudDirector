###############################################################
# Avoid putting any additional logic in this PSM1 because if
# it the module is compiled into a monolithic PSM1, this file
# is created from scratch.
#
# Instead, initialization logic should go into Initialize.ps1.
# That file will be compiled into the PSM1 if that option is
# enabled in $PSBPreference.Build.CompileModule
###############################################################
# Dot source public/private functions
$public  = @(Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Public/*.ps1')  -Recurse -ErrorAction Stop)
$private = @(Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Private/*.ps1') -Recurse -ErrorAction Stop)
foreach ($import in @($public + $private)) {
    try {
        . $import.FullName
    } catch {
        throw "Unable to dot source [$($import.FullName)]"
    }
}

Export-ModuleMember -Function $public.Basename
