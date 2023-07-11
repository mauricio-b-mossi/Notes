## Fundamentals

PowerShell is a powerful, cross-platform task automation and configuration management
framework. It consists of a command-line shell and programming language. Here are the
most common uses:

- Task automation and orchestration.
- Configuration management.
- Servers and cloud management.
- Custom tool making.
- Scripting.

Key Ideas:

- PowerShell returns objects, in contrast to other command-lines.
- PowerShell is both a command-line shell and a scripting language.

Tips:

- Ctrl + Space shows suggestions.
- Ctrl + Home to delete everything before cursor.
- Ctrl + End to delete everything after cursor.

### Features

- Built-in help system
- Pipeline (but pipes objects)
- Aliases : Commands in PowerShell follow `Verb-Nound` convention, however it provides, and
  you can set aliases for those Noun-Verb commands. For example, `ls` is the alias for Get-ChildItem.
  You can see all the aliases with `Get-Alias` cmdlet (commands are known as cmdlets).
- Cmdlets: Commands in PowerShell are called cmdlets (pronounced commandlets). Cmdlets typically
  take object input and return object.
- Extendibility: You can extend PowerShell by using more cmdlets, scripts, and functions
  from the community and other sources, or you can build your own cmdlets in .NET Core or PowerShell.
- Types of Commands: Commands in PowerShell can be native executables, cmdlets, functions, scripts, or aliases.

Most of the time, even though the output you get looks like a table, it is an object.
Therefore, you can destructure it using the `.`.

Under the hood, output might look like a table as PowerShell pipes the result to `Out-Default`.
`Out-Default` searches for the default formater of the object, it can be of various types including,
`Format-List`, `Format-Table`, etc.

```powershell
> $PsVersionTable # A list
> $PsVersionTable.PsVersion # A table specific for the property.
```

### Locate commands

A cmdlet is a compiled command. Thousands of cmdlets are available in your PowerShell installation.
The challenge lies in discovering what they are and what they can do for you. As mentioned above,
cmdlets are named avoiding to Verb-Noun naming standard. This pattern is useful as it:

- a) Allows the user to understand what cmdlets do and how to search for them.
- b) Helps developers create consistent cmdlet names.

You can see the list of approved verbs by using the `Get-Verb` cmdlet.

### Core Cmdlets

- Get-Command: The `Get-Command` cmdlet lists all of the available comdlets on your system.
- Get-Help: Run the `Get-Help` core cmdlet to invoke a built-in help system. You can
  also run the alias `help` command to invoke `Get-Help` but improve the reading experience by paginating the
  response.
- Get-Member: When you call a command, the response is an object that contains many properties. Run
  the `Get-Member` core cmdlet to drill down into that response and learn more about it.

#### Get-Command

As `Get-Command` returns a huge list of objects, you can narrow down your search by:

- Getting list of cmdlets for a noun `Get-Command -Noun <Noun>`
- Getting list of cmdlets for a verb `Get-Command -Verb <Verb>`

```powershell
> Get-Command # Returns all commands.
> Get-Command -Noun Item* # Returns all cmdlets that contain the Noun "Item".
> Get-Command -Verb Get # Returns all the cmdlets that contain the Verb "Get".
```

Use wild cards when ever possible as you could miss plural nouns.

#### Get-Help

By using the built-in help system in PowerShell, you can find out more about a specific command.
You use the `Get-Command` cmdlet to locate a command that you need. After you've located
the command, you might want to know more about what the command does and various ways to call it.

Typically, you invoke the `Get-Help` by specifying it by name and adding the `-Name` flag that contains
the name of the cmdlet you wnat to learn about.

```powershell
> Get-Help -Name Get-Command
```

You can narrow down the result of `Get-Help` by using flags:

- Full: Returns a detailed help page.
- Detailed: Returns a response that looks like the standard response, but it includes a section for parameters.
- Examples: Returns only examples, if any exits.
- Online: Opens a web page for your command.
- Parameter: Requires a parameter name as an argument. It lists a specific parameter's properties.

Use help if you want a paginated response. Under the hood `help` is just `Get-Help | more`. `More` is responsible
for the pagination.

#### Get-Member

The `Get-Member` cmdlet is meant to be piped on top of the command you run so that you can filter the output.

The first line of the `Get-Member` cmdlet indicates the type of the object, the other rows indicate members of the object.
You can use this type in combination to `Get-Command -ParameterType` to view possible commands that accept as input the type.

The response given by `Get-Member` can be quite verbose. You can filter it down using the `Select-Object` cmdlet.
The `Select-Object` cmdlet expects a list of comma-separated column names or a wildcard character, such as an
asterisk (\*), which indicates all columns.

```powershell
> Get-Process -Name 'name-of-process' | Get-Member # Returns the object the type is System.Diagnostics.Process
> Get-Command -ParameterType Process # Here "Process" references the type returned by Get-Process.
> Get-Process -Name "name-of-process" | Get-Member | Select-Object -Property Name, MemberType # Returns only the columns Name and Member Type.
```

##### Step to Find A Cmdlet.

- Ask yourself what action (Verb) do you want to perform. Use `Get-Verb` and search your action.
- If your desired action is there, use `Get-Command -Verb <Verb>` to find a list of cmdlets for your action.
- If your desired action is there, use `Get-Help -Name <Cmdlet>` to find how to use the cmdlet.
- To check the form, pipe the cmdlet to `Get-Member`: `<Cmdlet> | <Get-Member>`

### Selecting Data

By default, when you run a command that is going to output to the screen, PowerShell automatically adds the
command `Out-Default`. When the output data is a collection of objects, PowerShell looks at the object type to
determine if there's a registred view for that object type. If it finds one, it uses that view. The view
generally does not conatin all the properties of an object because it wouldn't display propertly on
screen, so only the most common properties are displayed.

#### Select-Object

You can override the default view by using `Select-Object` to select the properties you want and pipe those properties
to a formatter like `Format-Table` or `Format-List`.

```powershell
> Get-Process node | Format-List -Property * # Overrides the default formatter and display all properties.
```

Note there is a distinction between Presentation Names and Property Names. Presentation Names are used
when displaying output. However, the Presentation Names are not queriable. Use `Get-Member` to see the
Property Names.

```powershell
> Get-Process node
 NPM(K)    PM(M)      WS(M)     CPU(s)      Id  SI ProcessName
 ------    -----      -----     ------      --  -- -----------
      0     0.00       0.01       0.38     644 620 node
// NPM(K), PM(M), WS(M), CPU(s), are all Presentation Names. Querying Presentation Names often does not give desired results.
> Get-Process node | Get-Member -Name C* // Returns all Property Names with starting with C, which are Query-able.
```

#### Sort-Object

When you use `Sort-Object` in a pipeline, PowerShell sorts the output data by using the default
properties first. If no such property exist, it then tries to compare the objects themselves.
The sorting is either by ascending or descending order.

There are multiple ways to specify the sort.

- By Property: Specify the sort direction then the property.
- By Properties: Specify the sort direction then the properties.
- By Expression: Sort by expression is more customizable, here you specify the property and sort order in an @{} block.

```powershell
> Get-Process | Sort-Object -Descending -Property Name // Sorting descending on Name
> Get-Process | Sort-Object -Descending -Property Name, CPU // Sorting descending on Name and CPU
> Get-Process 'some process' | Sort-Object -Property @{Expression = "Name"; Descending = $True}, @{Expression = "CPU"; Descending = $False}
```

#### Where-Object

Where object is like a filter, it only selects the objects that satisfy the condition. Common conditions include:
`-like`, `-gt`, '-lt', to see more use the `Get-Help` cmdlet.

#### Filtering Left

In a pipeline statement, filtering left means filtering for the results you want as early as possible.
You can think of the term left as early, because PowerShell statements run from left to right.
The idea is to make the statement fast and efficient by ensuring that th edataset you operate on is
as small as possible.

```powershell
> Get-Process | Select-Object Name | Where-Object Name -eq "name-of-process" # Inefficient.
> Get-Process | Where-Object Name -eq "name-of-process" | Select-Object Name # More efficient.
> Get-Process -Name "name-of-process" | Select-Object Name # Most efficient.
```

#### Formatting Right

Formatting should be ideally done at the end, this is because formatting before can produce unwanted results.
This is because format commands alter the structure of the object that your results are contrained
in so that your data is no longer found in the same properties.

```powershell
> Get-Process 'some process' | Select-Object Name, CPU | Get-Member # Return type is System.Diagnostics.Process
> Get-Process 'some process' | Format-Table Name,CPU | Get-Member # Return type is a mess: FormatStartData, GroupStartData, FormatEntryData...
```

It is important to realize that when you use any type of formatting command (prefixed by `Format`), your data is
different.

##### TL;DR Filter first, Format Last.

- Filtering first makes the pipeline thiner, and therefore faster and more managable.
- Formating last preserves types, since formatting produces formatted types.

### Writing PowerShell

- Cmdlets are the main way to interact with PowerShell. They're written in a Verb-Noun format.
- Parameters take input so that a cmdlet can provide output or take action.
- PowerShell is a relaxed language. That is, it's case insensitive by default.
- PowerShell errors can help you identify issues, and reading errors carefully can save you time.
- Variables are used to store values that you want to use dynamically in your programs.

Most programs you write do the following:

- _Accepting_ input from a source. Input includes information that:
  - Comes from a user who's typing on a keyboard or selecting controls on an interface.
  - Is retrieved from a file.
  - Is called from another program or network connection.
- _Processing_ information, which includes:
  - Performing logic.
  - Performing mathematical calculations.
  - Manipulating data input to produce new data.
- _Outputting_ results, which includes information that is:
  - Displayed on a screen to a user.
  - Saved to a file.
  - Sent to another program.

#### Compiling code in PowerShell

Code in PowerShell is a mix of compiled and interpreted. First a PowerShell program, is
compiled into an AST (Abstract Syntax Tree) in order to find syntactical errors. Then
if it passes the checks it is interpreted. This approach is useful as it ensures that
your code will run correctly before it's run by the computer.

```powershell
$date = get-date
Write-Host "Today's date is $date."
$name = Read-Host "What is your Name? "
Write-Host "Today is the day $name began a PowerShell programming journey"
```

### Introduction To Scripting In PowerShell

PowerShell scripts are stored in `.ps1` files.

Overview of the Features in PowerShell:

- Variables: You can use variables to store values. You can use variables as
  arguments to commands.
- Functions: A function is a named list of statements. Functions Produce an
  output that displays in the console. Tou can also use functions as input for
  other commands.
- Control Flow: Control flow or flow control is how you control various execution
  paths by using constricts like `If`, `ElseIf`, and `Else`.
- Loops: Loops are constructs that let you operate on arrays, inspect each item,
  and do some kind of operation on each item. But loops are about more than array
  iteration. You can also conditionally continue to run a loop by using `Do-While`
  loops.
- Error Handling: It's important to write scripts that are robust and can handle
  various types of errors. You'll need to know the difference between terminating and
  non-terminating errors.
- Expressions: You'll freuqnetly use expressions in PoweShell script. For example,
  to create custom columns or custom sort expressions. Expressions are representations
  of values in PowerShell syntax.
- .NET and .NET Core integration: PowerShell provides powerful integration with .NET
  and .NET Core.

You need to be aware that some scripts aren't same. Therefore PoweShell attempts to
protect you from doing things unintentionally in two main ways:

- Requirement to run script by using a full path or relative path.
- Execution Policy: An execution policy is a safety feature. Like requiring a path
  of a script, a policy can stop you from doing unintentional things. You can set the
  policy on various levels, like the local computer, current user, or particular session.
  You can also use a Group Policy setting to set execution policies for computers
  and users.

These two mechanisms do not stop you from opening a file, copying its contents, placing
the contents in a text file, and running the file. They also do not stop you from
running the code via the console.

#### Execution Policy

You can manage exectuion policy using these cmdlets:

- `Get-ExecutionPolicy`: Returns the current execution policy.
- `Set-ExecutionPolicy`: Sets the execution policy. There are few possible values.
  - Default: Sets the execution policy to `Restricted` on Windows clients and
    `RemoteSigned` on Windows Server.
    - `Restricted`: Means you cannot run scripts. You can only run commands.
    - `RemoteSigned`: Means that scripts written on the local computer can run.
      Scripts donwleaded from the internet need to be signed by a digital signature
      from a trusted publisher.

#### Variable and String Interpolation

Using double quotes in a String allows for variable interpolation, while single
quotes print the literal string.

```powershell
$PI = 3.14
> Write-Host "The value of PI is $PI" # The value of PI is 3.14
> Write-Host 'The value of PI is $PI' # The value of PI is $PI
> Write-Host "The value of `$PI is $PI" # The value of $PI is $PI
```

The backtick (`) lets you escape what would be an interpolation. You can also write an 
expression within `$()` construct.

```powershell
Write-Host "Today is $(get-date)" # Today is 07/01/2023 13:47:39
```

#### Scopes

- Global Scope : When you create constructs like variables in this scope, they
  continue to exist after your session ends. Anything that's present when you start a
  new PowerShell seesion can be said to be in this scope.
- Script Scope: When you run a script file, a script scope is created. For example, a
  variable or a function defined in the file is in the script scope. It will no longer
  exist after the file is finished running.
- Local Scope: The local scope is the current scope, and can be the global scope
  or any other scope.

- Items are visible in the current and child scopes. You can change this
  behavior by making the item private within the scope.

- Items can only be changed in the created scope. You can change this behavior by
  explicitly specifying a different scope.

#### Profiles

A profile is a script that runs when PowerShell starts. You can use a profile to
customize your environment. PowerShell will apply these changes to each new session you
start.

##### Profile Types

PowerShell supports several profile files. You can apply them at various levels.
|Description|Path|
|---|---|
|All users, all hosts | $PSHOME\Profile.ps1|
|	All users, current host	|$PSHOME\Microsoft.PowerShell_profile.ps1|
|Current user, all hosts |$Home[My ]Documents\PowerShell\Profile.ps1|
|Current user, current host	|$Home[My ]Documents\PowerShell\Microsoft.PowerShell_profile.ps1|

There are two variables here: `$PSHOME` and `$Home`.

- `$PSHOME` points to the installation directory for PowerShell.
- `$HOME` points to the current user's directory.

#### Create a profile

When you first install PowerShell, there are no profiles, but there is a $Profile variable. It's an object that points to the path where each profile to apply should be placed. To create a profile:

1. Decide the level on which you want to create the profile. You can run `$Profile | Select-Object *` to see the profile types and the paths associated with them.

2. Select a profile type and create a text file at its location by using a command like this one: `New-Item -Path $Profile.CurrentUserCurrentHost`.

3. Add your customizations to the text file and save it. The next time you start a session, your changes will be applied.

#### Paramters

To declare a parameter for your script use the `Param` keyword with an open and close
parenthesis containing the parameter names.

You can specify the type of the parameters and even set default values:

```powershell
#PrintName.ps1
Param(
[string]$Name = "Mauricio"
)
Write-Host "Printing the name $Name"
```

There is a problem with this approach, all parameters are optional by defualt. This
might lead to script errors if this is not the intended behavior. To fix this you
can:

- Use `If/Else` to check the value of a parameter and decide what to do.

```powershell
Param(
$Name
)
If($Path -eq ''){
    Write-Error "Parameter -Name is required"
} Else{
Write-Host "Printing the name $Name"
}
```

- Use the `Parameter[]` decorater. A better way which requires less typing.

```powershell
Param(
   [Parameter(Mandatory)]
   $Path
)
New-Item $Path
Write-Host "File created at path $Path"
```

You can imporve the decorator by providing a Help message users will see when they
run the script:

````powershell
[Parameter(Mandatory, HelpMessage = "Please provide a valid path")]```

You can also assign a type to the parameter.
```powershell
Param([string]$Path)
````
