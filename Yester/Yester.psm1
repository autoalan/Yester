Import-Module Pester
Import-Module powershell-yaml

$PrivateFolder = 'Private'
$PublicFolder = 'Public'

if (Test-Path $PSScriptRoot\$PrivateFolder) {
    $Private = @(Get-ChildItem -Path $PSScriptRoot\$PrivateFolder -Filter '*.ps1' -Recurse) | Sort-Object -Property Name
}

if (Test-Path $PSScriptRoot\$PublicFolder) {
    $Public = @(Get-ChildItem -Path $PSScriptRoot\$PublicFolder -Filter '*.ps1' -Recurse) | Sort-Object -Property Name
}

if ($Private) { 
    foreach ($ScriptFile in $Private) {
        try {
            . $ScriptFile.FullName
        } catch {
            Write-Error -Message ("Failed to import private function {0}: {1}" -f $ScriptFile.FullName, $_)
        }
    }
}

if ($Public) {
    foreach ($ScriptFile in $Public) {
        try {
            . $ScriptFile.FullName
        } catch {
            Write-Error -Message ("Failed to import private function {0}: {1}" -f $ScriptFile.FullName, $_)
        }
    }
}

Export-ModuleMember -Function Invoke-Yester
