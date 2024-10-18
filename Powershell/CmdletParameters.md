### Parameters

###Parameter sets
Most PowerShell cmdlets, provide several Parameter Sets. Think of this
as function overload. Where the cmdlet is the same, however, the Parameters it
accepts are different. To view the Paramter sets per cmdlet use the `Get-Help`
cmdlet and go to SYNTAX.

### Types of Parameters

Using `Get-Help <cmdlet> -Full` we get the full Paramter list and their type.

- Required?
- Position?
- Default Value
- Accept pipeline input?
- Accept wildcard characters?

Another way to know the parameters and their types is using `Get-Help` and examining
the SYNTAX block.

```
SYNTAX
    Get-EventLog [-LogName] <string> [[-InstanceId] <long[]>] [-ComputerName <string[]>] [-Newest <int>] [-After <datetime>] [-Before <datetime>] [-UserName <string[]>] [-Index <int[]>] [-EntryType {Error | Information | FailureAudit | SuccessAudit | Warning}] [-Source <string[]>] [-Message <string>] [-AsBaseObject] [<CommonParameters>]

    Get-EventLog [-ComputerName <string[]>] [-List] [-AsString] [<CommonParameters>]
```

Parameters usually consist of pairs of `-ParameterName <ParameterType>`.
Switch Paramters just consist of the switch `[-Switch]`

- Mandatory Parameters are NOT surrounded by []. In the example above only `-LogName`
  is a mandatory parameter. Then everything else the switchs and other paramters are optional.

- Named and Positional Parameters are similar, if the ParameterName is surrounded by [],
  the parameter is a Named Parameter, if not surrounded by brackets it is a Positional Parameter.

##### TL;DR Brackets are for not required, no Brackets are for required.

- [ParameterPair] surrounding the whole parameter means the parameter is not required : optional.
- [ParameterName] surrounding the parameter name means the parameter name is not required : positional.
