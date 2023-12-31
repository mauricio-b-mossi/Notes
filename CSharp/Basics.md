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
- Multiple assignment can be achieved based on the same type:
```cs
int age = 20, dob = 17_03_03; 
```
- The default for all methods and properties is to be private. It is implied by the lack of accessibility modifiers.
- Use `_` to discard values.
- If a method only performs one statement or expression you can use the fat arrow syntax. Where if an 
expression, the last value is returned.
```cs
string fullName => $"{firstName} {lastName}";
void PrintFullName =>  Console.WriteLine(fullName);
```
- `nameof` returns the name of the instance. `GetType` gets the type of an instance at 
runtime. `typeof` gets information about a type at compile time.

> `typeof` does not work on instances, it only works on Types.

- To hide implementation details of an interface, you can explicitly implement the interface 
members. The only way to access these explicitly implemented interface memebers is by casting 
to the interface.

> As a note, I tend to use Java code style instead of C#/C++/C code style.
```cs
// --- Java style ---
class Person{
    ...
}

// --- C style ---
class Person
{
    ...
}
```

### Features I Like
- `is` operator and pattern variable: When downcasting you can use `is` to check if it is of the type
and if true, assign it to a variable of the type checked.
```cs
if(animal is Dog d) Console.WriteLine($"It is a dog {d.Bark()}");
```
- Hiding and overriding: When you want to hide a variable use `new` to indicate intent, use `override` 
to override virtual and abstract members. Hiding is the same as overriding in Java, while overriding in C#
overrides the implementation of the current and the base class.
- Switch statements and expressions: Switch can be used either as an expression or statement.
- Partial Classes: Allow you to define a class in multiple files.
- Default accessibility for members of a class is `private`.

### Predefined Types
Predefined types are types that are specially supported by the compiler (primitive types):
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

> Floating point types are known as *real types*, while Integer types are known as *integral types*.

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

The arithmetic operators (+, -, *, /, %) are defined for all numeric types except the 
8 and 16 bit integral types. Therefore, if you perform an operation on these types, 
they are automatically cast to the lowest possible type: int32.
```cs
byte one = 1;
byte two = 2;
byte three = one + two; // Error: Byte is being assigned an int.
int three = one + two; // Do this.
byte three = (byte)(one + two); // Or This.
```

Floating point types have values that certain operations treat specially. These are `NaN`, 
`+\infty`, `-\infty`, as well as other values (MaxValue, MinValue, and Epsilon).

The floating point types include `float`(32), `double`(64), `decimal`(128). When using 
the decimal point `.`, the compilers infers the type of the real type to be a double. Use 
prefix `f` to specify a float type and `m` to specify a decimal type.

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
The former, is called array initialization expression where the size of the array is the 
number of elements declared within the `{}`.

> Creating an array always preinitialises the elements with default values. If the element
> is a reference type, it is initialized to null, if it is a value type, it is initialized to 
> the bitwise zeroing of memory.

You can access elements relative to the end of an array using `Index`. To declare an index,
prefix the number with `^`. This `^1`, refers to the last element, `^2` refers to the
second to last element, and so on.

You can also access ranges using `Range`. To declare a range, add the starting bound and the 
end bound exclusive, with `..` in between. This `2..4` refers to, from index 2 until (not including)
index 4. For ranges, you can omit either end, this means from the start or until the end.

```cs
int[] arr = {1,2,3,4,5,6};
Index last = ^1;
Range firstToThird = ..3;
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
by value. However, you can use parameter modifiers to override the defaults. The following
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

The `params` modifier serves the same function as `varargs` in Kotlin. The modifiers when used,
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

### Difference between ref in C# and pointers in C.
`ref` in C# literal passes the reference to the object. This means that changes made 
to the ref within the function will reflect in the variable as they both point to the 
same address in memory. C# places more emphasis on safety. When you pass an argument
with the `ref` modifier, you are passing a reference to the original variable. This 
prevents certain types of pointer related errors, like null references and buffer overruns.

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

### Constants and static readonly
A constant is evaluated statically at compile time, and the compiler literally substitutes its 
value whenever used. A constant can be a `bool`, `char`, `string`, any of the built-in numeric 
types, or an enum type. A constant must be initialized with a value. 

> This is important with libraries for example, if your library has a `const`, it will literally
> be compiled into the consumers binary. If you later change the `const`, the effects will not 
> reflect in the consumers code UNTIL the consumer recompiles the whole program.

Both `const` and `readonly` cannot be changed after assignment. However, there are not 
interchangeable:
- Use `const` when you know the constant value.  
- Use `readonly` when you dynamically get a non changing value.

### Methods
A method's signature must be unique within the type.
> A method's signature is comprised by its name and parameter types ***in order***.
> This does not include the parameter names (just types) and the return type.

### Local Methods
Local methods are just methods within methods. They signal the reader that the method is 
not used elsewhere. When used they can make code more readable. You can add them within 
other local methods, inside lambda expressions, constructors, property accessors: Basically 
within any method.
```cs
int CalculateCube(int x){
    return Cube(x);

    int Cube(int x) => x * x * x;
}
```

Adding the `static` modifier to a local method prevents it from seeing the local variables
and parameters of the enclosing method. 

> If your define a "function" (because it is a method) within the `main` method of the program or as a top-level statement 
> (which is inserted within a `main` method by the compiler), the function is a local method. Therefore, if you add the static modifier 
> to it, it cannot access the identifiers within the scope.

Also, importantly, local methods cannot be overloaded.

> An overloaded methods is a method with the same name but different signature.

### Overloading methods
When overloading methods you cannot have the two methods with the same signature. A method's
signature is made up of the method name, and parameter types (`ref int` is not the same as `int`).
Importantly, the return type and the params modifier are not part of a method's signature:
```cs
void Foo(int x){...}
float Foo(int x){...} // Compile-time error

void Goo(int[] x){...}
void Goo(params int[] x) {...} // Compile-time error

void Baz(int x){...}
void Baz(ref int x){...}
void Baz(out int x){...} // Compile-time error as ref int and out int are the same parameter type signature.
```

### Constructor
- C# provides a default constructor for all classes, if no other constructor is specified.
- You can refer to overloaded constructors with `this(params)`. The compiler identifies the constructor by its method signature. 
- Field initialization occurs before the constructor is executed.

### Deconstructor
The deconstructor acts as the approximate opposite to a constructor: whereas a constructor 
typically takes a set of values and assigns them to fields, a deconstructor does the reverse
and assigns fields back to a set of variables. A deconstructor method must be called 
`Deconstruct` and have one or more `out` parameters:
```cs
Person me = new Person();
(string name, int age) = me;

Console.WriteLine(name); // Mauricio
Console.WriteLine(age); // 20

class Person{
    string name = "Mauricio";
    int age = 20;

    public void Deconstruct(out string name, out int age){
        name = this.name;
        age = this.age;
    }
}
```
The deconstructor call used above is syntactic sugar for:
```cs
// --- First ---
me.Deconstruct(out string name, out int age);

// --- Second ---
string name;
int age;
me.Deconstruct(out name, out age);
```

### Fields and Properties
Fields just store values, Properties control the access and updating of a backing field.
A backing field is just a field that stores the value exposed and updated by the Property.
This is the same as in Java, where you have a backing field, whose access is managed with 
getter and setter methods. In C#, a property is declared like a field but with `get` `set`
block added.
```cs
public class Person{
    int name;

    public string Name{
        get{
            Console.WriteLine($"name accessed from Name's get");
            return name;
        }
        set{
            Console.WriteLine($"name set to {value} from Name's set");
            name = value;
        }
    }
}
```
For simplicity, it is easier to use public fields rather than public properties. However, in a 
real application you should favor public properties to promote encapsulation.

You can set a read-only property by just specifying a `get` accessor, and a write-only
by just specifying a `set` accessor.

> Even though you can make your own getter and setter methods like Java, C# provides Properties
> as an alternative. A Property is like a method but it lacks the `()`. This tells the compiler
> that it is a property and can have `get` and `set` within it.
```cs
// --- Method ---
string Name(){
    return name;
}

// --- Property ---
string Name{
    get{return name;}
    set{name = value;}
}

// --- Constructor ---
public Person(name){
    this.name = name;
}
```

Resist the temptation to think in Java. 
- Properties look like methods, but without the `()` and can access `get` and `set`.
- Constructors are not named, they just contain the return type.

If your implementation of a property is a getter and/or setter that simply reads and writes 
to a private field of the same type as the property. An automatic property declaration 
instructs the compiler to provide this implementation.
```cs
// --- Automatic property ---
public string Name{get;set;} // Compiler generates backing field, getter and setter.

// --- Compiler Generates ---
string name;

public string Name{
    get{return name;}
    set{name = value;}
}
```

Just like field initialization `string name = "Jose";`, you can initialize properties `public string Name{get;set;} = "Jose";`

> So if automatic properties are practically identical to fields, why should I use them? You should use automatic 
> properties as they enable extensibility of your program. Without modify the identifier of the property, you can 
> change its internal behavior. Thing you cannot do with a field.

### Object Initializers for fields and properties
Object Initializers provide an alternative to optional arguments (default arguments) and named arguments. With Object initialization
you can initialize public fields and properties as follows:
```cs
// --- Object Initializers Fields ---
Person me = new Person() {name = "Jose", age = 21};

public class Person{
    public string name; // Has to be public.
    public int age;
}

// --- Object Initializers Properties ---
Person me = new Person() {Name = "Jose", Age = 21};

public class Person{
    public Name{get;set;} // Has to be public and have set.
    public Age{get;set;}
}

// --- Optional Arguments and Named Arguments ---
Person me = new Person(name:"Mauricio", age:21);

public class Person{
    string name; // Has to be public.
    int age;

    public Person(string name = "Jose", int age = 21){
        this.name = name;
        this.age = age;
    }
}
```

The drawback is that for Object Initializers, the fields cannot be read only. Under the hood, C# does something as follows:
```cs
Person temp1 = new Person();
temp1.name = "Jose";
temp1.age = 21;
Person me = temp1;
```
Therefore, fields must be public.

For Properties, you can make properties read-only by using `init` instead of `set`.
```cs
Person me = new Person(){Name = "Mauricio", Age = 21};

public class Person{
    public string Name{get;init;}
    public int Age{get;init;}
}
```
Init Properties cannot be set from anywhere other than the object initializer, constructor or another 
init-only accessors.

> In Kotlin terms, think of `public type Property{get;set;}` as `var` and `public type Property{get;init;}` as `val`.

An alternative to init only properties is to have read-only  properties that you populate via a constructor:
```cs
public class Person{
    string Name{get;}
    int Age{get;}

    public Person(string name, int age){
        Name = name;
        Age = age;
    }
} 
```

***TLDR*** Historically, a combination of optional arguments and named parameters simplified 
object construction and allowed both properties and fields to remain read-only. Object initializers
did not permit this as an intermediate object was created, as seen above. However, in C# 9
the init modifier was introduced which allows us to achieve read-only properties with 
object initializers.

### Indexers
Indexers allow you to access members of a class by index. To declare an index define 
a property called `this`, specifying the arguments in square brackets:
```cs
Sentence s = new Sentence();

Console.WriteLine(s[3]);                            // moo
s[3] = "???"
Console.WriteLine(s[3]);                            // ???

public class Sentence{
    string words[] = "The fox says moo".Split();

    public string this [int index]{
        get{return words[index];}
        set{words[index] = value;}
    }
}
```
You can use types `Index` and `Range` as parameter types for your index. 
```cs
public string this [Index index] => words[index];
public string[] this [Range range] => words[range];
```

### Static Constructor
A static constructor executes once per type rather than once per instance. A type can define 
only one static constructor, and it must be parameterless and have the same name as the type:
```cs
new Person();       // Initialized!

public class Person{
    static Person(){Console.WriteLine("Initialized!!");}
}
```
The runtime automatically invokes a static constructor just prior to the type being used. 
Two things trigger this:
- Instantiating the type.
- Accessing a static member in the type. 

Static fields are initialized before static constructors. Therefore you can do:
```cs
new Person();       // Initialized!, the max population is 1000000

public class Person{
    static int maxPopulation = 1_000_000;
    static Person(){Console.WriteLine($"Initialized!!, the max population is {maxPopulation}");}
}
```

### Finalizers 
Finalizers are class-only methods that execute before the garbage collector reclaims the 
memory for an unreferenced object. The syntax for a finalizer is the name of the class
prefixed with the ~ symbol:
```cs
class Person{
    ~Person(){...}
}
```
This syntax is short hand for `Object.Finalize` method.

### Partial Classes
Partial types allow type definitions to be split - accross multiple files, the same file, etc. The split type has 
access to everything in the type. This allows the class to be augmented from different parts.
```cs
Person me = new Person(){Name = "Mauricio", Age = 21};
public partial class Person{public string Name{get;set;}}
public partial class Person{public int Age{get;set;}}
```
As basically evrything is merged into one class. You cannot have conflicting members. Unless 
one of the members is a partial method. Think of partial methods as loose abstract methods.
If used, they need to be implemented, else the compiler throws the parial method away to avoid bloat.
```cs
public partial class Person
{
    public string Name { get; set; }
    public partial void Introduce(); // Definition.
}
public partial class Person
{
    public int Age { get; set; }
    public partial void Introduce() => Console.WriteLine($"Hello my name is {Name} and I'm {Age} years old."); // Implementation.
}
```

### Inheritance
Upcasting never fails, downcasting is a bit tricky. To downcast, you can use `(Type)a` or `a as Type`.
The difference is that `as` if the downcast is not possible returns null, while the other throws an 
InvalidCastExeption.
```cs
A a = new A();
Letter l = a;
l.Pronounciation;        // Error
()(A)l).Pronounciation;  // "aaa"
(l as A).Pronounciation; // "aaa"

public class Letter{}
public class A : Letter{public string Pronounciation{get;} = "aaa"}
```

`is` tests whether a variable matches a pattern, where a type name follows the is keyword. Unlike Kotlin, 
no automatic downcast is made by the compiler. However, you can introduce a pattern variable to 
achieve similar behavior.
```cs
// --- Pattern ---
if(l is A){
    (l as A).Pronounciation; // "aaa"
}

// --- Pattern With Pattern Variable ---
if(l is A a){
    a.Pronounciation;        // "aaa"
}
```
The pattern variable is available for immediate consumption as seen in `switch`. It also remains 
in the outside scope so it can be used elsewhere.
```cs
if(a is Stock s && s.Price > 1000){...}
s.Tic                        // msft
```
To better understand the pattern variable is equivalent to this:
```cs
A a;
if(l is A a){
    a = (A)l;
}
```

### Virtual Members and Override
Methods, properties, indexers, and events can all be declared `virtual`. Anything marked 
with `virtual` can be overridden by subclasses using the `override` keyword.
```cs
public class Person { public virtual string Greet() => "Hello"; }
public class Mauricio : Person
{
    public string Name { get; } = "Mauricio";
    public override string Greet() => $"Hello my name is {Name}";
}
```

### Covariant return types
With virtual methods, you can return a more derived class than the virtual methods signature 
because this does not break the contract: The derived class is still the class:
```cs
public class Animal{public virtual Animal Reproduce => new Animal();}
public class Dog : Animal{public override Dog Reproduce => new Dog();}
```
In the example above, a Dog is still an Animal.
> Remember: invariant List<Number> !> List<Int>; covariant List<Number> > List<Int>; contravariant List<Int> > List<Number>

### Hiding Inherited Members
What we would call overriding in Java is Hiding members in C#. We saw the `override` and `virtual` 
keywords above. To sum it up, `virtual` basically tells the programmer that the member can be overriden
with the `override` keyword. Unlike `abstract` members, `virtual` members provide a default 
implementation. 

Hiding a member usually happens by accident so the compiler throws a warning. To remove the warning
you add the `new` keyword after the access modifier, therefore indicating your intent to the compiler.
```cs
public class A{public void Spell => Console.WriteLine("Aaai");}
public class B : A{public new void Spell => Console.WriteLine("Beee");}
```

### Hiding vs Overriding 
When overriding, even though the class is upcasted, the overridden method is the one evoked.
When hiding, when the class is upcasted, the types method is called.
```cs
B b = new B();
A a = b;

b.Overriden();
b.Hidden();
a.Overriden();
a.Hidden();

public class A
{
    public void Hidden() => Console.WriteLine("A: This method will be Hidden");
    public virtual void Overriden() => Console.WriteLine("A: This method will be Overriden");
}

public class B : A
{
    public new void Hidden() => Console.WriteLine("B: This method was Hidden");
    public override void Overriden() => Console.WriteLine("B: This method was Overriden");
}
// --- Result ---
B: This method was Overriden
B: This method was Hidden
B: This method was Overriden
A: This method will be Hidden
```
However, with `base` (the same as `super` in other programming languages), you can access methods of 
the base class nonvirtually. Meaning you can get the original definition of a virtual and hidden method.

### Base Class Constructor 
To instantiate the base class constructor use the `base` keyword as follows:
```cs
// With numbers I've marked the order of initialization.
public class Person{...} // 3.
public class Employee{
    string company = "Msft"; // 1.
    public Employee(string name) : base(name); // 2.
    // 4.
}
```

### Boxing, Static and Runtime type Checking
Boxing is the act of wrapping value types into objects. This is done because C# has an unified type system. Where every 
object extends from the `object` type. This includes value types, which can be boxed into objects. The process of 
making a value type a reference type is called boxing and the opposite is called un-boxing. Obviously, this 
is intended for value types as all user-defined types extend object by default.

Programs in C# are checked both at compile time and at runtime. Static typing enables type checking at compile type. At 
runtime, type checking is achieved as each object in the head stores a reference to `System.Type`. To get the type
of an object you can use the `typeof` operator, which evaluates at compile time, and the `GetType` method on an instance, 
which evaluates at runtime.

### Structs
- A struct is a value type, whereas a class is a reference type.
- A struct does not support inheritance.
- A struct can have all of the members that a class can, except for a finalizer. 
- A struct cannot be subclassed, members cannot be marked as virtual, abstract or protected.
- A struct always has a default constructor that performs a bitwise zeroing of all its members.
If you define your own default constructor, you can still access the default constructor 
using `default`.

Prior to C# 10, structs were further prohibited from defining field initializers and parameterless constructors.
```cs
struct Person{
    // Field Initializers
    int age = 20;
    string name;

    // Default constructor
    public Person(){name = "Juan"}
}
```
This is because you can by pass everythin above just using the `default` keyword.
```cs
var person = new Person(); // {name = "Juan", age = 20}
Person def = default;      // {name = null, age = 0}
```

Structs, to provide compiler optimization can have `readonly` methods, properties, and fields.
To enforce that the whole struct is readonly, add the readonly modifier to the class.
Classes just provide readonly fields. To make a property `readonly` omit the `set`.

> You can also use readonly on methods to specify that the method should not modify data.

To specify that a struct must always live in the Stack declare the struct as `ref struct`.
- If a value type appears as a parameter or local variable, it will reside in the Stack.
- If it appears in a reference type (Array, Objects), it will reside on the Heap.

> Using the `ref` modifier with structs seems weird as they are value types. However, in this context 
> it indicates that the struct cannot live in the heap, or within a reference type.

### Access Modifiers
- Public: Fully accessible. This is the implicit accessibility for members of an enum or interface.
- Internal: Accessible only within the containing assembly or friend assemblies. This is the 
default accessibility for non-nested types (classes). (Within the same package / module for Kotlin).
- Private: Accessible only within the containing type. This is the default accessibility
for members of a class or a struct.
- Protected: Accessible only within the containing type or subclasses. (Within subclasses).

> An assembly is a compiled unit of code that can be a DLL (Dynamic Link Library) or an EXE (Executable). 

### Accessibility Capping
At first it might seem hard to understand but the members of a class are capped (limited), by the 
class' Access Modifier. This makes sense if you think about it. If the class is internal, why should 
the members be public? 

### Interface
- An interface can only have functions not fields. 
- Interface members are implicitly abstract. However, an exception are Default Interface Members.
- A class or struct can implement multiple interfaces. In constrast a class can only inherit 
from a single class, and a struct cannot inherit at all.
- Interface members are always public. This means that when you implement members, they must contain 
the `public` access modifier. Implementing an interface means providing a `public` implementation for all 
of its members.

> An intereface can contain only methods. Remember, indexeres, properties all are transformed
> by the compiler into methods. For properties `get_XXX` and `set_XXX`, while for indexers `get_Item`
> and `set_Item`.

There is a difference between explicit implementation of an interface, and implicit implementation of an interface.
- When an interface in implemented explicitly, the only way to call the implemented members is to cast the object to the 
interface you want to call. Members implemented explicitly cannot be marked as public. 
- When an interface in implemented implicitly, you can mark it as public.
If you have signature collisions for interfaces, you must implement them explicitly. You can implement one implicitly, becoming 
the default for the object.
```cs
var letter = new Letter();

((B)letter).Spell(); // B
letter.Spell();      // A
letter.Demo();       // This is a Demo

class Letter : A, B
{
    public void Demo()
    {
        Console.WriteLine("This is a Demo");
    }

    public void Spell()
    {
        Console.WriteLine("A");
    }

    // Implemented Explicitly.
    void B.Spell()
    {
        Console.WriteLine("B");
    }
}

// The signature for Spell collides.
interface A{void Spell(); void Demo();}
interface B{void Spell();}
```
> The only way to call an explicitly implemented member is to cast to its interface.
> Another reason to implement members explicitly is to hide members that are highly specialized and 
> distracting to a type's normal use case.
```cs
var secret = new Secret();

class Secret : ISomehting
{
    // If public modifier is omitted, this would not be the Interface's member.
    public void NotSuperSecret()
    {
        Console.WriteLine("Not Super Secret");
    }

    // Public accessibility modifier is prohibited in an explicit implementation of an Interface.
    void ISomehting.SuperSecretOperation()
    {
        Console.WriteLine("Something Secret is Happening");
    }
}

interface ISomehting{void SuperSecretOperation(); void NotSuperSecret();}
```
> Members that are declared explicitly are private; Members that are declared implicitly are public.

### Implementing Interface Members
Once an interface member is implemented, by default it is `sealed`. If you want to be able to override the implementation 
in subclasses, mark the implementation with the `virtual` or `abstract` keyword.  

> Remember, virtual provides implementation but can be overridden; abstract provides no implementation and can be overridden; new hides the implementation in the subclass.
> To override an abstract or virtual function (as only functions can be abstract or virtual) use the `override` keyword. To 
> avoid a member to be overridden, use the `sealed` modifier.

As a reminder, when calling the interface overridden member through either the base class or the interface calls the
subclass’s implementation.

An explicitly implemented interface member cannot be market virtual, nor can it be overridden 
in the usual manner. It can, however, be reimplemented.

Interface reimplementation, as the name implies reimplements the interface.
```cs
var rtb = new RichTextBox();

rtb.Undo();              // RichTextBox.Undo
((IUndoable)rtb).Undo(); // RichTextBox.Undo

public class RichTextBox : TextBox, IUndoable{public void Undo() => Console.WriteLine("RichTextBox.Undo");}
public class TextBox : IUndoable{void IUndoable.Undo() => Console.WriteLine("TextBox.Undo");}
public interface IUndoable{void Undo();}

// --- If TextBox implemented implicitly ---
rtb.Undo();              // RichTextBox.Undo
((IUndoable)rtb).Undo(); // RichTextBox.Undo
((TextBox)rtb).Undo();   // TextBox.Undo

public class TextBox : IUndoable{public void Undo() => Console.WriteLine("TextBox.Undo");}
```

However, even with explicit member implementation, reimplementing interfaces should be avoided. Why? 
1. Because the subclass can never call the base class method.
2. The base class author might not anticipate that a method would be reimplemented
and might not allow for the potential consequences.

A better alternative is to design classes such that reimplementation will never be required.
- When implementing a member, mark it `virtual` if appropriate.
- When explicitly implementing a member, use the following pattern if you anticipate 
that subclasses might need to override any logic:
```cs
public class TextBox : IUndoable
{
    void IUndoable.Undo()           => Undo(); // Calls method below.
    protected virtual void Undo()   => Console.WriteLine("TextBox.Undo");
}
```
If you don't anticipate subclassing, you can mark the class as `sealed` to preempt 
interface reimplementation.

### Default Interface Members
Default interface members are pretty cool. Even though they are a feature in Kotlin and Java, C# 
makes you explicitly declare the intent by casting the object to the interface to call the member. 
```kotlin
// Kotlin
var doer = Doer();
doer.SayHi();       // Hey!

class Doer : IDoSomething{}
interface IDoSomething{
    fun SayHi(){
        println("Hey!");
    }
}
```
```cs
// C#
var doer = new Doer();
((IDoSomething)doer).SayHi(); // Hey!
class Doer : IDoSomething{}
interface IDoSomething{
    void SayHi() => Console.WriteLine("Hey!");
}
```
> C# is cool because it makes you specify your intent: To hide a method add new, and the example above.

### Writing a Class Versus an Interface
As a guideline:
- Use classes and subclasses fro types that naturally share an implementation.
- Use interfaces for types that have independent implementations.
> As interfaces can only have functions, we could say that we use functions for behavior, and classes for behavior and implementation.

### Enums
An enum is a special value type that lets you specify a group of named numeric constants.
- Since they are constants they do not need to be initialized just assigned.
- Each enum member has an underlying integer value. By default is an sequence that starts at zero and increases by 1.
- You can convert between integer representations and enums. Just cast them.

Knowing that enums are just integer constants, you can use them as flags to combine them. Flags use the same concept as Unix 
file permissions. You store the flags within a value, therefore better utilizing memory. Each bit represents a permissions.
```cs
var me = new User(){Permissions = FilePermissions.Read | FilePermissions.Write}; // Flag represents 0011.

public class User{public FilePermissions Permissions{get; set;} = 0;}

[Flags]
public enum FilePermissions{
    None = 0,
    Read = 1,
    Write = 2,
    Execute = 4
}
```
> Add the Flags attribute (annotation), to get a nice `ToString` method. It also specified your intent to other programmers.

To toggle a flag use XOR (`^`), to check for a flag use AND (`&`), to add a flag use OR (`|`).
```cs
me.Permissions;                                 // 0011.
me.Permissions ^= FilePermissions.Read;         // 0010.
me.Permissions & FilePermissions.Write != 0     // true. (means has flag)
```

> By convention, a combinable enum type is given a plural rather than a singular name.

### Nested Types
Nested types have the following features:
- It can access the enclosing type's private members and everything else the enclosing type can access.
- You can declare it with the full range of access modifiers rather than just `public` and `internal`.
- The default accessibility for a nested type is `private` rather than internal.
- Accessing a nested type from outside the enclosing type requires qualification with 
the enclosing type's name.

All types (classes, structs, interfaces, delegates, and enums) can be nested within either a class 
or a struct.

> As a recap of defaults:
> - The default accessibility for classes is internal.
> - The default for members of a class is private.
> - The default for members of an interface in public. 

### Generics
Whereas inheritance expresses reusability with a base type, generics express reusability with a 
"template" that contains "placeholder" types.

We say that Class<T> is an open type, whereas Class<int> is a closed type. At runtime, all generic 
type instances are closed - with the placeholder types filled in. The creation of closed types 
occurs at runtime.

Generic methods introduce type parameters:
```cs
T Pop(){...}                        // Not a generic method. Does not introduce Type paramaters.
void Swap<T>(ref T a, ref T b){...} // Generic method. Intruduces Type paramter T.
```

Type parameters can only be introduced in the declaration of classes, structs, interfaces, delegates and methods.
Other constructs, such as properties, cannot introduce a type parameter, but they can use one.

To constraint a generic use the `when` keyword to specify the constraint. The following can be read as a Garage
that can hold any type of Vehicle.
```cs
class Garage<T> where T : Vehicle{...}
```

Where the constraints for a generic can be:
```
where T : base-class // Base-class constraint
where T : interface  // Interface constraint
where T : class      // Reference-type constraint (must be a reference type)
where T : class?     // (see "Nullable Reference Types" in Chapter 1)
where T : struct     // Value-type constraint (excludes Nullable types)
where T : unmanaged  // Unmanaged constraint
where T : new()      // Parameterless constructor constraint (the type has a parameterless constructor).
where U : T          // Naked type constraint
where T : notnull    // Non-nullable value type, or (from C# 8)
                     // a non-nullable reference type
```

### Generic Type Casting
You need to be careful with typecasting Generics as the cast operator can perform several kinds 
of conversion, including:
- Numeric Conversion
- Reference Conversion.
- Boxing/Unboxing conversion.
- Custom conversion.

The decision as to which kind of conversion will take place happens at ***compile time***, based 
on the know types of the operands. Therefore, several alternatives to this:
- First upcast to `object`, and then downcast to the type. This is because all objects can
be upcasted to `object`, and conversion to and from object are assumed not to be custom.
- Use `is` pattern not to cast the variable, but to create a new variable with the cast.
- When dealing with value types, cast to object to perform boxing and then unboxing.
- Alternative, use `as` but you run the risk of having `null` of `NullPointerException` instead of `InvalidCastException`, 
which makes debugging hard.

### Variance
Only ***arrays, interfaces, and delegates*** support covariance. By default, arrays a covariant, which as Java,
can produce undesirable results. Same as Kotlin, use `in` and `out` modifiers, on interfaces or delegates,
to specify whether the Type parameter is consumed (`in`) or outputted (`out`). 

> `out` modifier on T indicates that T is used only in output position. Method parameters marked as `out` are not eligible for covariance.
