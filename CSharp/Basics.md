### Things to Know
- By convention, parameters, local variables, and private fields should be in camelCase,
  and all other identifiers should be in PascalCase.
- The entry point of a program can be top-level statements, or a Main methods defined 
inside any class.
```cs
// --- Top Level ---
Console.WriteLine("Hello World");
// -- Main Method ---
class Program{
    static void Main(string[] args){
        Console.WriteLine("Hello World");
    }
}
```

### Predifined Types
Predifined types are types that are specially supported by the compiler (primitive types):
- int
- string
- bool

### Value and Ref Types
- Value types include all the basics: int, float, structs.
- Ref types include strings, arrays, objects.
Refs can assigned to the literal `null`, indicating that the reference points to no object.

If not initialized, ref type members default and structs to their zeroing bitwise value. For example,
an uninitialized array of integers of size 10, defaults to an array of size 10 with the value 
of `0` per each slot. 

Predefined types in C# alias .NET types in the `System` namespace. There is only a syntactic 
difference between these two statements:
```cs
int i = 5;
System.Int32 i = 5;
```

### Numeric Values
You have numeric types to represent numbers within 8 bits to 64 bits in intervals of 8, both 
signed and unsigned: `byte`, `short`, `int`, `long`. The unsigned are usually prefixed with a u.
As mentioned above, these types, being predefined types, reference .NET types in the 
`System` namespace. For example `SByte`, `Int16`, `Int32`, `Int64`, are what the types above reference.

Of the types above `int` and `long` are first-class citizens and are favored by both C# 
and the runtime. The other integral types are typically used for interoperability or 
when space efficiency is paramout.

Number literals can be prefixed with `0x` and `0b` to denote hexadecimal and binary. You can 
use exponential notaion with E:
```cs
int fifteen = 0b1111;
int fifteenX = 0xF;
double fifteenE = 1.5E01;
```

The arithmetic operators (+, -, *, /, %) are defined for all numberic types except the 
8 and 16 bit intergral types. Therefore, if you perform an operaton on these types, 
they are automatically cast to the lowest possible type: int32.
```cs
byte one = 1;
byte two = 2;
byte three = one + two; // Error: Byte is being assigned an int.
int three = one + two; // Do this.
byte three = (byte)(one + two); // Or This.
```

Floating point types have values taht certain operations treat specially. These are `NaN`, 
`+\infty`, `-\infty`, as well as other values (MaxValue, MinValue, and Epsilon).
> When using `==` a NaN value is never equal to another. To test use `float.IsNaN` or `double.IsNaN`.

### String
String interpolation is done by using the `$"{}"` syntax, where within the `{}` you 
can put any expression, under the hood, the `ToString` method of the expression is 
called.

Strings do not support comparisons with `<` and `>` instead use `CompareTo` method.

### Arrays
The type of an arrays is declared as `type[]`. There are several ways to declare an array.
The main ones are:
- `type[] name = new type[size];`
- `type[] name = {};`
The former, is called array initializaiton expression where the size of the array is the 
number of elements declared within the `{}`.

> Creating an array always preinitializes the elements with default values. If the element
> is a reference type, it is initialized to zero, if it is a value type, it is initialized to 
> the bitwise zeroing of memory.

You can access elements relative to the end of an array using `Index`. To declare an index,
prefix the number with `^`. This `^1`, refers to the last element, `^2` refers to the
second to last element, and so on.

You can also access ranges using `Range`. To declare a range, add the starting bound and the 
end bound exclusive, with `..` in between. This `2..4` refers to the from index 2 until (not including)
index 4. For ranges you can omit either end, this means from the start or until the end.

```cs
int[] arr = {1,2,3,4,5,6};
Index last = ^1;
Range firstToThird = 0..3;
Console.WriteLine(arr[last]);

int[] slice = arr[firstToThird];
foreach(int item in slice){
    Console.WriteLine(item);
}
```

> The `ToString()` representation of an array in C# returns the type, not the elements.

### Multidimensional Arrays
Multidimensional arrays can be either rectangular or jagged.
- Rectangular: Internally represented as a contiguous block of memory of w * h size. 
    Typed as `int[,]`; Declared as `int[,] rec = new int[3,3]`. This sets a contiguous block
    Of 9 ints.
- Jagged: Internally represented as an array of arrays, of size n. Each slot is a reference to 
    an array. Typed as `int[][]`; Declared as `int[][] jag = new int[3][]`.

> A rectangular array is a two-dimensional array, a jagged array is an array of arrays.

### Parameters
Methods can accept parameters passed by value and by reference, the default behavior is pass 
by reference. However, you can use parameter modifiers to override the defaults. The following
are modifiers to pass by reference. In all cases the modifier should be used in both args and params.
- `ref`: Passes value by reference.
- `out`: Method returns argument as reference.
- `in`: Method receives read-only reference.
```cs
int x = 0;

addTen(ref x); 

outTen(out int o); 

inTen(in x); // Prints 10.
inTen(in o); // Prints 10.

void addTen(ref int x) => x += 10;
void outTen(out int x) => x = 10;
void inTen(in int x) => Console.WriteLine(x);
```

C# enables the use of named `func(name:arg)` and default parameters `type name = value`. Mandatory 
parameters must occur before optional parameters in the method declaration.
```cs
addNumbers(3);
addNumbers(o:5, t:5); 

int addNumbers(int o, int t = 0) => o + t;
```

The `params` modifier is serves the same function as `varargs` in Kotlin. The modifiers when used,
should be prefixed to an one-dimensional array type.
```cs
Console.WriteLine(addAll(1,2,3,4,5,6,7,8,9))                // 45
Console.WriteLine(addAll(new int[]{1,2,3,4,5,6,7,8,9}))     // 45

int addAll(params int[] x){
    if(x.Length < 1) return 0;
    int sum = x[0];
    for(int i = 1; i < x.Length; i++){
        sum += x[i];
    }
    return sum;
}
```

### Ref Locals and Ref Returns.
Ref locals and returns allow you to store references in variables and return references from methods.
To do this you need to modify the variable or method declaration with the keyword `ref`. To get the reference
of an item use the `ref` keyword.
```cs
Person person = new Person("Mauricio", 20);
ref int age = ref person.age;
Console.WriteLine(person.getAge()); // 20
age++;
Console.WriteLine(person.getAge()); // 21
public class Person{...}
```

### Dealing with `null`
There are several ways to deal with null in C#:
- Null Coalescing Operator `??`: Same purpose as Elvis operator in Kotlin, if the left hand side is null,
return the right hand side, else return the left hand side. 
- Null Coalescing Assignment Operator `??=`: Used for assignment, assigns the value to the variable, if the 
variable is null.
- Null Conditional Operator `?. or ?[]`: Known as the Elvis operator in C#, and safe call in Kotlin. It checks if 
the variable is null before accessing its members, if null, it short circuits to return null.
```cs
int? num = null;
num ??= 10;         // 10
num?.ToString()     // 10
```
> Reference types by default are nullable, value types are not. To treat a value type as nullable,
> use the nullable type `?`.
Unlike Kotlin, the compiler does not require you to check for nulls. 

### Control Flow
- Selection statements (`if`, `switch`).
- Conditional operator (`?:`).
- Loop statements (`while`, `do-while`, `for`, `foreach`).

***If statements*** 
Else statements apply to the immediately preceding if statement block. C# does not provide,
an elseif keyword, rather you use `if` and `else` to mimic this behavior. The compiler recognizes 
the else if pattern:
```cs
if (x == 2){...}
else if (x == 3){...}
else{...}

if (x == 2){...}
else
{
    if (x == 3) {...}
    else{...}
}
```
If you look closely both are the same.

***switch*** 
Switch statements for constants are similar to Java, this type of switch statement is 
restricted to build-in integral types: `boo`, `char`, `enum`, `string`, and integral types.

At the end of each `case` clause, you must specify explicitly where execution is to go next,
with some king of jump statement (unless your code ends in an infinite loop).
- `break`
- `goto case x`
- `goto default`
- Any other jump statement - `return`, `throw`, `continue`, `goto label`.

Labels are declared `labelName:`, you can go to a specific label using `goto labelName`. 

You can place cases that should execute the same statement block one on top of the other.
```cs
switch(x){
    case 1:
    case 2:
    case 3:
    case 4:
    case 5:
        Console.WriteLine("Five and Below");
    default:
        Console.WriteLine("Older than Five");
}
```

You can also, like Kotlin's `when{is Type -> ...}`, switch on types, this is known as a Pattern:
```cs
// type must be a SUPER TYPE of the case types, in this case an object type would work.
switch(type){
    case int i:
        Console.WriteLine($"Its an int {i}");
        break;
    case string s:
        Console.WriteLine($"Its a string {s}");
        break;
    default:
        Console.WriteLine("Not my type");
        break;
}
```
Like Kotlin, the `case`, downcasts the variable so it can be used as intended.

Each `case` clause specifies a type upon which to match, and a variable upon which to 
assign the typed value if the match succeeds. Unlike with constants, there's no 
restriction on what types you can use.

You can predicate a `case` with the `when` keyword.
```
    case int i when i > 10:
        ...
    case int i:
        ...
```
> You can mix and match constants and patterns in the same switch statement.

***switch expressions*** 
Switch expressions allow you to return an expression form the switch.
```cs
string? retCardName(int cardNumber)
{
    if(cardNumber > 13 || cardNumber < 1) return null;
    return cardNumber switch
    {
        13 => "King",
        12 => "Queen",
        11 => "Jack",
        1 => "Ace",
        _ => cardNumber.ToString()
    };
}
```
You can also pass tuples to switch expressions as follows:
```cs
string card = (cardNumber, suite) switch{
    (13, "spades") => "King of spades",
    _ => "Not important"
};
```

***while and do-while*** 
While and do while are the same as in Java, `while` checks the condition before each iteration,
`do{...}while` checks the condition after each iteration.

***for and foreach*** 
For loops are the same as in Java, the only exception, is that in the initialization clause you 
can initialize multiple variables.
```cs
for(initializaiton-clause; condition-clause; iteration-clause){...}
for(int idx = 0, prevFib = 1, currFib = 1; idx < 10; i++){...}
```

`foreach` is a special to C#, it iterates over an enumerable object. 
```cs
string name = "Mauricio";
foreach(type name in enumerable){...}
foreach(char letter in name){...}
```
