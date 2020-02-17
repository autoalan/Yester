function Get-Assertions {
    <#
    .SYNOPSIS
        Loads and parses the supplied YAML assertions file or directory.
    .DESCRIPTION
        Describe and Name keys are required at root. Describe may optionally contain a Context key with
        one or more nested lists. 
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        $Path
    )
    begin {
        if (-Not (Test-Path $Path)) {
            Write-Error 'The specified path does not exist'
        }  
    }
    process {
        try {
            $Assertsions = Get-ChildItem -Path $Path -Include '*.yaml', '*.yml' | Get-Content -Raw | ConvertFrom-Yaml -ErrorAction Stop
        } catch {
            Write-Error -Message ("Failed to import a valid YAML file {0}: {1}" -f $Assertsions, $_)
        }
        if (-Not ($Assertsions.Contains('Name') -and $Assertsions.Contains('Describe'))) {
            Write-Error -Message 'Describe and Name keys are required at root.'
        }
    } end {
        return Get-ChildItem -Path $Path | Get-Content -Raw | ConvertFrom-Yaml -ErrorAction Stop        
    }
    
}