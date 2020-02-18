# Yester

Yester is a Pester wrapper for executing tests defined in YAML. The goal of this is project is to enable simple, repeatable tests for infrastructure engineers with little understanding or want to learn PowerShell and Pester. Yester only requires a basic understanding of YAML to compose tests. 

## Installation
> Yester depends on  [Pester]([https://github.com/Pester/Pester](https://github.com/Pester/Pester)) and [powershell-yaml]([https://github.com/cloudbase/powershell-yaml](https://github.com/cloudbase/powershell-yaml))


At this point in time, Yester only exists on GitHub, so you will need to install Yester from this repository. However, I may eventually publish it to the PowerShell Gallery.

To locate a suitable module path, see    `$Env:PSModulePath`. 

## Usage
The `Invoke-Yester` commandlet will execute the tests identified using the `-Path` parameter.

`Invoke-Yester -Path .\my-tests.yml`

You can also load multiple YAML test files by specifying a folder containing one or more YAML files with a `.yml` or `.yaml` extension.

`Invoke-Yester -Path .\my-tests\`

The resulting output should be familiar.
```yaml
Describing Example Yester Configuration Test

  Context Yester Environment
    [+] We should be using the console 33ms
  [+] 10 should not be greater than 100 2ms
```


### YAML Specification
Each YAML file represents ***a single*** Describe block. The Describe and Name keys at the root must be defined.

```
Name: This is the description for the Describe block
Describe:
```
Optionally, one or more Context blocks can be defined.
```
Name: This is the description for the Describe block
Describe:
  Context:
    - Name: Context Block 1
      It:
        ...
    - Name: Context Block 2
      It:
      ...
```
As you would expect, you can make multiple asserts in a given context. For an assertion, all keys are required.

```
Name: This is the description for the Describe block
Describe:
  Context:
    - Name: Context Block 1
      It:
        - Name: 10 should not be greater than 100
	  Left: 10
	  Right: 100
	  Operator: -Not -BeGreaterThan
```
This configuration is the same as the expression `$Left | Should -Not -BeGreater than $Right` or  `10 | Should -Not -BeGreaterThan 100` when expanded.

Of course, expressions are also welcome.
```
Name: This is the description for the Describe block
Describe:
  Context:
    - Name: Context Block 1
      It:
        - Name: We should be using the console
	  Left: (Get-Host).Console
	  Right: Console
	  Operator: -Be
```
Finally, Invoke-Expression is used to execute the actual Pester tests. If `Left` or `Right` is evaluated to `$null` by Invoke-Expression, the value is treated as a string.
