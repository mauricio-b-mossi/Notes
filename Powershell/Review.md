# Essentials
The essentials you need for PowerShell are:
- Everything in PowerShell is an object*. Unlike other shells, PowerShell returns Objects instead of text.
This means that the returned objects have methods and properties which you can use.
- Pipelining: The pipeline operator is the pipe `|`. The pipe passes the returned value to the next cmdlet (`Get-ChildItem | Where-Object{$_.Name} | Write-Host`).
- Understanding command structure: When getting help, you need to be able to understand
the documentation.
    - Square brackets `[]` denote something is required.
    - Chevrons `<>` are used to denote the type of the parameter.
Within a command you have parameters, which can be optional or mandatory, within those commands
they can be named or positional. The format of a parameter is `[[-Name] <Type>]`. Where `-Name` 
denotes the name of the parameter and `<Type>` the type of the parameter. Say we have a parameter
for a number input it would look something like `[[-A] <Int>]`. The form above represents a `required`
and `named` argument. Meaning it must be included and specified via its name. If the surrounding brackets
are removed the parameter is optional (`[-A] <Int>`) but named. If the brackets surrounding the name are removed
only then the parameter is positional and required (`[-A <Int>]`). If both brackets are removed, the parameter is both
optional and positional.
- Understanding command conventions: Commands follow the `Verb-Noun` convention, where the noun is singular: `Get-Process`, `Get-ChildItem`.
- Understanding how to get help: To get help use the `Get-Help` cmdlet.
- Understanding how to search for commands: To search for commands, use the `Get-Command` cmdlet.

# Getting Help in practice
For the next section we will be selecting, sorting and filtering. So I know what I want to do, I want to select something form an object. I know,
that PowerShell follows the `Verb-Noun` convention for therefore we use the `Get-Help` command or the `Get-Command` to filter for commands. For example,
we could run the command `Get-Help *select*`, where `*` are wildcards. Or more correctly we could use `Get-Command -Verb Select`. How do I know these 
commands can do this? I used `Get-Help Get-Help` and `Get-Help Get-Command`.

# Filtering, Selecting, Iterating and Sorting
You filter with the `Where-Object` cmdlet, you select with the `Select-Object` cmdlet, you iterate with `ForEach-Object` and sort with `Sort-Object`.
Hopefully you notice the pattern, everything that acts on a generic object has the noun `Object`. Therefore, to see all the actions you can perform on an 
object you can run `Get-Command -Noun Object`. 

### Getting Values and Not Objects with Select-Object
If you use `Select-Object` you can either the `-Property` parameter to specify the properties to be selected, or you could use the
`-ExpandProperty` to get only the values of the selection. ExpandProperty is like bash, it returns the string value of the property.

# More into objects
As mentioned above, everything* in PowerShell is an object. Therefore, you can access its properties and methods. To view the members of an object you 
can use `Get-Member`, to view the type of an object you can use the `.GetType()` method in the object. To view the signature of a method you just type
the methods without calling it (`"str".Replace`). 

# Common Data Structures
- Arrays: You can create arrays just by making a list of comma-separated values `1,2,3` or you 
could initialize an array with `@(1,2,3)` both are equivalent in most cases.
- Hashtables: You can create a hash table like `@{Key = Value; K2 = V2}`. Hash tables can be converted 
into PowerShell objects if casted to `[PSCustomObject]`. It creates a Object type, with the 
added `NoteProperties` in the Hashtable.

# Looping: For, ForEach, Ranges
You can loop with `foreach($Var in $Iterable)`, `Iterable.forEach()`, or with `for(<init>;<condition>; <repeat>)`.
One cool feature is ranges, just like Kotlin you can use `1..100` to generate a range from `1` to `100`. This is easier,
than building a loop that repeats 10 times. You can just do `1..10 | %{}`.

# Operators
Unlike other languages, PowerShell does not provide the common `>=, <=, ||, &&` instead you have the more 
verbose `-le` `-ge` `-or` `-and`. You can check the full list of operators in the Docs. One cool feature of 
PowerShell is that it has pattern matching operators like `-like` `-match` meaning you can 
compare strings without to much hassle.
