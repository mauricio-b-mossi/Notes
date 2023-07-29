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
