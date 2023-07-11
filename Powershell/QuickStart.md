## Here is a TLDR of PowerShell Language

Things to remember:

- PowerShell is case insensitive.
- Can use cmdlets within scripts.
- Everything an object.

Before running a script, for safety purposes, PowerShell requires you:

1. Specify explicitly the location of the script.
2. Have the adequate `Execution-Policy`. Execution-Policy must be at least
   `RequireSigned`.

A script is just a Sequence of Commands that executes from top to bottom. You can use
parameters, variables, expressions, conditionals, operators, cmdlets, error handling,
iteration, and more.

- Parameters: Specified at the beginning of a script with the `Param()` keyword
  inside the parenthesis, can be set to required with `[Parameter(Mandatory)]`, can
  have types and default values.
- Variables: Declared with `$<variable-name>`
- Expressions: Anything that returns a value. Can create an expression within an expression
  using `$(...)` called a subexpression.
- Conditionals: `IF`, `ELSEIF`, `ELSE`. Use them with operators such as `-gt`, `-lt`, `-like`.
- Operators: Vary widely from arithmetic `+`, `-`, to comparison `-gt`, `-lt`, assignment and more.
- Error Handling: `TRY`, `CATCH`, `FINALLY`. You specify the catching error with `[Error.Type]`
  and throw errors with the `THROW` keyword.

I'll just cover things that differ from common programming languages.

#### [Pipping](https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/04-pipelines?view=powershell-7.3)

When using pipes `|` everything that is not a side-effect gets pipped. A side-effect is anything
that modifiers the systems state. This includes, variables, files, etc. Remember, PowerShell, is
one big object-oriented thing.

```powershell
$a = 1           # Does not pipe as it produces a top-level side effect.
($a = 1)         # Does pipe

$a = $b = 0      # value not written to pipeline
$a = ($b = 0)    # value not written to pipeline
($a = ($b = 0))  # pipeline gets 0

++$a             # value not written to pipeline
(++$b)           # pipeline gets 1

$a--             # value not written to pipeline
($b--)           # pipeline gets 1
```

The second example pipes because any expression containing top-level side effects can
be enclosed in parenthesis to pipe a result. Note, must be parenthesis (), not subexpressions.

To check which cmdlets take the result you are pipping `Get-Member`, `Get-Help`, and `Get-Command` are your
friends.

- `Get-Memeber`: When you pipe a cmdlet to `Get-Memeber` it returns the information about the object you are
  piping. It returns the type, properties, methods, and more. This is important because the type is what the cmdlet
  returns.
- `Get-Help <cmdlet> -Full`: Use to see the inputs and parameters of a cmdlet. The parameters contains information
  of whether the parameter can be piped, by value or by property name. Think of by value as by type and by property name
  as by column name.
- `Get-Command -ParameterType <Type>`: Use to see which cmdlets accept the parameter type of your object.

```powershell
#Get-Help Out-File -Full
INPUTS
    System.Management.Automation.PSObject
        You can pipe any object to this cmdlet.
...............................................
 -LiteralPath <System.String>
     (...)
        Required?                    true
        Position?                    named
        Default value                None
        Accept pipeline input?       True (ByPropertyName)
        Accept wildcard characters?  false
```

#### [Types](https://learn.microsoft.com/en-us/powershell/scripting/lang-spec/chapter-04?view=powershell-7.3)

As eveything is an object, everything has a type as well, even cmdlets have types.
You can view the types by using `Get-Memeber` or some types have the method `getType()`.

##### Collections

Arrays are declared either with a list `$arr = 1,2,3`, however usually they are declared
`$arr = @(1;2;3)`. Access Arrays by index:

- `[-1]` returns the last
- [#,#,#] returns an array with the #,#,# indices from the array.
- [1..5] returns a range slice from first to end.

HashTables are declared with `$tab = @{FirstName = "Mauricio"; LastName = "Mossi"}`.
Access HashTables by `.` deconstuctor or by `[name]`.

> Note when using the @() or @{} items are separated by `;`.

The @() and @{} are called array expressions and hashtable expressions. Think
of them as builders, they hold values that are returned to the pipeline.

```powershell
$j = 20
@($i = 10)             # 10 not written to pipeline, result is array of 0
@(($i = 10))           # pipeline gets 10, result is array of 1
@($i = 10; $j)         # 10 not written to pipeline, result is array of 1
@(($i = 10); $j)       # pipeline gets 10, result is array of 2
@(($i = 10); ++$j)     # pipeline gets 10, result is array of 1
@(($i = 10); (++$j))   # pipeline gets both values, result is array of 2
@($i = 10; ++$j)       # pipeline gets nothing, result is array of 0

$a = @(2,4,6)          # result is array of 3
@($a)                  # result is the same array of 3
@(@($a))               # result is the same array of 3
```

You can access static variables and methods with the `[type]::variable`.
You can access instance variables and methods with the `(object).variable`

#### [Comparison Operators](https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/05-formatting-aliases-providers-comparison?view=powershell-7.3)

Unlike other languages, PowerShell does not use symbols for comparison. It uses
characters prefixed by `-`:

- `-eq`: Equal.
- `-neq`: Not equal.
- `-lt`: Less than.
- `le`: Less than or equal
- `-gt`: Greater than.
- `-ge`: Greater than or equal.
- `-like`: Like matches with `*` (wildcard, one or more chars) and `?` (wildcard, one).
- `-match`: Match matches with regular expressions.
- `contains`: Determines if a collection contains a specific value.
- `NotContains`: Determines if a collection DOES NOT CONTAIN a specific value.
- `in`: Determines if a specific value is in a collection.
- `NotIn`: Determines if a specific value is in a collection.
- `Replace`: Replaces the specific value.

All of the above are case insensitive by default, to make case sensitive, prefix
the opeartor with `c`: `-ceq`. To make the above explicitly case insensitive use `i`.

#### Looping

There are multiple ways to loop in PowerShell.

```powershell
ForEach-Object{$_} # ForEach-Object cmdlet, $_ represents current item in pipeline.
foreach(<var> in <collection>)  # Used mostly in script blocks.
for(<var>; <condition>; <increment>) # Typical C for loop.
while(<condition>) # While loop
do{}while(<condition>){} # Do while
```

You also have access to labels, and break, continue and return statements.

```powershell
:label for(...){
    if(...){break :label}
}
```

### Error Handling

You can use regular `TRY`,`CATCH`, `FINALLY`. You catch a specific exception by
specifying the type in the `CATCH [ERROR.TYPE]`. After catching the error, you
can inspect the error's:

- Message
- StackTrace
- Offending Row

You inspect all the above, by using the `$_` variable available in the `CATCH` block.
This variable represents the current object in the pipeline. It is commonly used in
combination with cmdlets, such as `ForEach-Object`, to refer to the object currently
being processed.

```powershell
$fruits = "apple", "banana", "orange" # Specifying an Array.
$fruits | ForEach-Object { if ($_ -ne "banana") { Write-Host "I like $_" } }
```

#### Raising Errors

You can Rise two types of error `Non-Terminating Errors` and `Terminating Errors`.

- Non-Terminating Errors: Are thrown with `Write-Error`, these just alert something
  is wrong but execution continues. They are by default not caught by `TRY` and `CATCH`.
- Terminating Errors: Are throw with the `THROW` cmdlet, these can be caught with `TRY`, `CATCH`.

```powershell
Try {
   If ($Path -eq './forbidden')
   {
     Throw "Path not allowed"
   }
   # Carry on.

} Catch {
   Write-Error "$($_.exception.message)" # Path not allowed.
}
```

#### Providers and Drivers

A Provider allows access to data and components that would not otherwise
be easily accessible at the command line. The data that the provider exposes
appears on a drive.

<b>TLDR</b> A provider is a part you of your system you could not access otherwise, and
the driver is what exposes the variables from the provider.

| Provider    | Driver Name | Description                          |
| ----------- | ----------- | ------------------------------------ |
| Alias       | Alias:      | PowerShell aliases                   |
| Environment | Env:        | Environment variables                |
| FileSystem  | A:,B:,C:    | Disks drives, directories, and files |
| Function    | Function:   | PowerShell functions                 |
| Variable    | Variable:   | PowerShell variables                 |

```powershell
$Env:Path # Returns the Path
$C:viminfo # Returns viminfo
$Alias:cat # Get-Content
```

To get more info use the cmdlets:

- Get-PSProvider
- Get-PSDrive
