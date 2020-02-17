function Invoke-Assertion {
    <#
    .SYNOPSIS
        Invokes each Pester test
    .DESCRIPTION
        If $Left or $Right evaluate to $null when called by Invoke-Expression, the value is treated as a string.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        $Left,

        [Parameter(Mandatory = $true, Position = 1)]
        $Right,

        [Parameter(Mandatory = $true, Position = 2)]
        [string]
        $Operator,

        [Parameter(Position=1, ValueFromRemainingArguments)]
        $Remaining
    )
    process {
        try {
            [void] (Invoke-Expression $Left)
        } catch { 
            $Left = """$Left""" 
        }
        try {
            [void] (Invoke-Expression $Right)
        } catch { 
            $Right = """$Right""" 
        }
    } end {
        return Invoke-Expression "$($Left) | Should $($Operator) $($Right)"
    }
}