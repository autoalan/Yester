function Invoke-Yester {
    <#
    .SYNOPSIS
        Gets YAML assertions from a specified path
    .DESCRIPTION
        Yester makes Pester assertions from described in one or more YAML configuration files. The Describe and
        Name keys must exist at the root. The Context key is completely optional. All tests should contain the
        Name, Left, Right and Operator keys. If the Left or Right keys evaluate to $null with Invoke-Expression,
        the key value is assumed to be a string.

        ---
        Name: Description of the describe block
        Describe:
          Context:
            - Name: This is one of many possible contexts. The Context block is completely optional.
              It:
                - Name: This is the first test under the first context. This and subsequent keys are required.
                  Left: The left-most arguement for a test. Ex. "$Left | Should -be $true"
                  Right: The right-most argument for a test. Ex. "$Wrong | Should -be $Right"
                  Operator: One or more test operators including dashes. Ex. "$Left | Should $operator Right"
          It:
            - Name: This test does not have a context; however, it does have two operators
              Left: 5
              Right: 2
              Operator: -Not -BeLessThan
        ...
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        $Path
    )
    begin {
        $Assertions = Get-Assertions $Path
    } process {
        Describe $Assertions.Name {
            if ($Assertions.Describe.Contains('Context')) {
                $Count = $Assertions.Describe.Context.Count      
                for ($i = 0; $i -lt $Count; $i++) {
                    Context $Assertions.Describe.Context[$i].Name   {
                        $Assertions.Describe.Context[$i].It.GetEnumerator() | ForEach-Object {
                            [hashtable] $splat = $_
                            it $_.Name {
                                Invoke-Assertion @splat
                            }
                        }
                    }
                }
            }
            if ($Assertions.Describe.Contains('It')) {
                $Count = $Assertions.Describe.It.Count
                $Assertions.Describe.It.GetEnumerator() | ForEach-Object {
                    [hashtable] $splat = $_
                    It $_.Name {
                        Invoke-Assertion @splat
                    }
                }
            }
        }
    } end {
        return
    }
}