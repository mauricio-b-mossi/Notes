### Things to Know
- Identifiers that begin with an underscore and either an uppercase letter or another
underscore are always reserved. For example `_Bool` was introduced in C99, anyone who used the `_Bool` identifier
was stuck with version prior to C99 or had to refactor.
- Indirection is the process of accessing a value indirectly through a pointer `*(address)`.
- Function pointers are not that difficult:
    - Declaration: `type (*name)(parameter-types)`.
    - Assignment: `name = func` or `name = &func`, both work.
    - Invocation: `name(args);` or `(*name)(args)`, both work.
- Macros: Macros (`#define`) are a way to define constants, expressions, snippets that are expanded at compile time.
   Basically, macros are substituted in by the compiler.
- Qualified == has a type qualifier: `const`, `volatile`, `restricted`.
- Header files just contain definitions. They are similar to typescript types.
- `#include` Copy pastes code into the compilation in place.
### Features I Like (and Don't)
- `Don't`: Do not like the ability to define type definitions `typedef int myint`.
- Function pointers: The idea is good, but can be implemented multiple ways.

### Pointers
A variable is a named location in memory that stores a value of a specific data type.
```c
// i stores 0;
int i = 0;
```
A pointer, on the other hand, is a variable that stores the memory address of another 
variable.

> The meaning of object according to the C Standard differers from how the word is used 
> in other programming languages. According to the C Standard, an object is a region
> of data storage in memory that can contain values. Objects have a type associated with 
> them, which determines the size and layout of the data they can hold.

***TLDR*** An object is a region of memory associated with a type. 

Unlike other programming languages, by default, you cannot have multiple variables 
pointing to the same object, for this you need pointers. 
- To get the address of the current variable use `&`.
- To dereference a pointer - which means to get the value the pointer points to - use `*<pointer>`. 
    This is known as the unary *.
- To specify that the type is a pointer use `<type> *<variable-name>`. Or in function prototypes
    `<type> *`.
> Remember, unary * dereferences, pointer type declarations `<type> *`, address `&`.

```c
#include <stdio.h>
#include <stdlib.h>

// swap requires two int pointer parameters.
void swap(int *, int *);

int main(void){
    int a = 1; b = 2;

    // passing the addresses of a and b.
    swap(&a, &b);
}

void swap(int *a, int *b){
    // setting temp to the value of pointer a.
    int temp = *a;
    // setting the value of pointer a to the value of pointer b.
    *a = *b;
    // setting the value of pointer b to temp.  
    *b = temp;
}
```

The code above works, however, here is a case that at first glance appears as if it should work. 
```c
void swap(int *a, int *b){
    int * temp = a;
    a = b;
    b = temp;
}
```
Why does it not work? Remmeber, C is pass by value, so we are passing the pointers by value,
this means that `int *a` and `int *b` represents the copies of the pointers. Therefore if 
we set the value of a and b, we are setting the local copies, not the actual values that the 
pointers point to. To illustrate in another language:
```cs
void SetStink(Cheese c){
    c = new Cheese(){Stink = true};
}

public class Cheese{
    public bool Stink{get;set;}
}
```
In the example above, `SetStink` accepts a Cheese, since C# is pass by value, we pass by value 
the reference of some Cheese. Once passed we set the local variable `c` to another Cheese with 
`Stink = true`. This does not affect the original as we have not modified anything in the 
value that the passed Cheese points to. 

The same concept applies to C, `int *a` is a copy of the pointer of a, which if dereferenced
accesses the value that a points to.

### Key points about pointers
When you dereference a pointer, you not only get the value, you get the specific value 
the pointer points to, this means if you set a dereferenced pointer, you set the value 
the pointer points to.

### Scopes and Lifetime
In 4 there are four types of storage durations: 
- ***Automatic Storage*** : Variables declared within a block or as a function parameter. The lifetime 
of these objects begins when the block in which they're declared begins execution, and 
ends when the execution of the block ends.
- ***Static Storage*** : Variables declared in the file scope or with the `static` modifier, 
life all throughout the execution of the program. Static objects must be initialized with a literal.

> Remember, object in C just means a region of data associated with a type.

### Object Types

#### Boolean types
From the start of C, there was no explicitly way to specify a `bool`. Therefore, a `0`
represented `false`, while `1` represented true. Not only that, any number that is not `0`
is considered truthy.
```c
  for (int i = -5; i < 5; i++) {
    if (i) {
      printf("Number %d is truthy", i);
    }
  }
```
The code above prints all numbers **except** 0.

Therefore in C99, the `_Bool` type was introduced. This is mostly for semantics. That 
way you can explicitly specify that you expect a boolean type. Furthermore, with the 
`<stdbool.h>` header, you can also spell this type as `bool` and assign it the values
true (which expands to the integer 1), and false (which expands to the integer 0).

#### Char types
There are three different character types in C: `char`, `signed char`, `unsigned char`. Each 
compiler implementation will define `char` to have the same alignment, size, range, 
representation, and behavior as either signed char or unsigned char.

> Char under the hood can be either a `signed char` or `unsigned char`. This is compiler specific.

You can but should not use `char` to store small integer values, as the underlying implementation
might make you code not compatible with other compilers. Instead, prefer `unsigned char` or `signed char`.

#### Integer types 
Signed integer types include: `signed char`, `short int`, `int`, `long int`, `long long int`.
The `int` word for all integer declarations except `int` can be omitted. For each 
signed integer type, there is a corresponding unsigned integer type. 

> The size of the integer is determined by the CPU architecture, use <inttypes.h> for
> specific integer types.

#### Floating types
C supports three floating point types: `float`, `double`, `long double`. Again, the implementation
is compiler dependent.

#### Enum types
An enumeration allows you to define a type that assigns names to integer values. The actual 
enumeration constant must be representable as an `int`, buts its type is implementation defined.
For example, GCC uses as `unsigned int`, whereas Visual C++ uses a `signed int`.
```c
// Months starting at int 1.
enum month{jan = 1, feb, march, april, ...}
```

#### Void types
Void by itself, means "cannot hold any value", you can use it to indicate a function returns 
no value or that a function accepts no arguments. On the other hand, `void*` indicates
that the pointer can reference any object.

### Derived types

#### Function Types
Function types are derived types, meaning their type is derived from other types. In the 
case of a function type, the type is derived from the return types, the number and types 
of parameters.

At the top of a file you can have your function declarations, these just specify the shape
of the function not the underlying implementation.

Some things to keep in mind while declaring functions. 
- Even though not necessary, you should declare the function with parameter identifiers.
- Never have an empty parameter list, this indicates multiple arguments in C and no arguments in 
C++, you should opt for `void` instead.
```c
int add(int a, int b);
void takeNothing(void);
```

#### Pointer types
A pointer type is derived from the function or object that it points to, called the 
reference type. You can use the `&` to get the reference of an object or a function.
To dereference, get the value, of a pointer you use the `*` operator on the pointer type.
The result of a dereferencing is the type of the value.
```c
// Creating a variable of type int a, and setting it to 10.
int a = 10;
// Creating a variable pa of type int pointer, and setting it to the address of a.
int *pa = &a;
// Setting the int pointer pa to the reference of the value of pa. 
pa = &*pa;
// Setting the value of pa to 20.
*pa = 20;
// Printing a which should be 20, as the value a points to was modifier by pa.
printf("A: %d", a); // 20
```

#### Array Types
You declare an array type as `type array-name[size]`. This is different form other languages.
```c
// C
int nums[10];
// C#
int[] nums = new int[10];
```
When declared, the array variable is automatically converted to a pointer to the first 
member of the array. The subscript (`[]`) operator and addition operator are defined so that 
`nums[i]` is equal to `*(str + i)`. This works because as you know, an array is a contiguous 
block of memory. Therefore, by adding `i` we are pointing to the starting address + i. If 
we dereference the address, we get the value at that address.

To declare a matrix do `type array-name[size][size]`. This creates an array of arrays. If you 
access `array-name[1]`, you will get an array as a result. If you access `array-name[1][1]` you 
will get an item as a result.
> In C# you have the concept of Jagged and Rectangular Arrays, a matrix is considered a rectangular array as it is defined statically.

#### Structs
A structure type contains sequentially allocated memory objects. Each object has its own 
name and may have a distinct type. To access the members of a struct object use the structure 
member operator (`.`) to access members from a struct pointer use the structure pointer operator (`->`).
```c
struct person{
    int age;
} me, *pme; // Creating an struct object me, and a pointer of type struct named pme.

pme = &me;  // Assigning the pointer to the address of the object.

me.age = 20;

printf("%d", me.age == pme->age); // 1
```

The person `struct` declaration above might seem tricky, but we have seen this type of declaration 
before. What we are doing is declaring two variables, one of type person and another 
a pointer to a person type. This is similar to the following:
```c
// Same pattern:
int x, *y;

struct person{
    int age; 
} x, *y;
```

#### Unions
Unions are somewhat similar to structs. However, the union can only have one value at a time.
The size of the union, is the same as the largest member. Unions are mainly used to save
memory.
```c
// The box is of size 4 and can only store either an int or a char[4] array.
union Box{
    int i; // 4
    char c[4]; // 4
}
```

As with structs, you can access a member with `.`, and using a pointer union you can 
access the member with the `->` operator.

Unions are usually used with "flags" or something similar to indicate the type.
```c
union box{
    struct {
        unsigned char type;
    } n;
    struct {
        unsigned char type;
        int i;
    } ni;
    struct {
        unsigned char type;
        float f;
    } nf;
};
```

A common error I committed when I started with C is that I declared structs instead of 
creating structs. In the example above, since the names `n`, `ni`, `nf` are after the 
struct body, the name is an identifier, if the name is before the struct body it declares 
a tag.

#### Things to remember about unions and structs
In C, the -> (arrow) operator is used to access members of a structure or a union through a
pointer to that structure or union. It provides a way to access members when you have a pointer
to the structure, while the . (dot) operator is used when you have an actual instance of the structure 
or union.

You might see structs created and defined in several ways.
```c
// Struct with tag.
struct person{...};
// Anonymous struct creation.
struct {...} person;
// Anonymous struct and pointer creation.
struct {...} person, *p;
```
1. The first example can be used to create instances of `person`.
2. The second example creates an anonymous struct `person`.
3. The third example creates an anonymous struct `person` and a pointer to the anonymous struct.

Tags are a special naming mechanism for structs, unions, and enumerations. By itself, a
tag is not a type name and cannot be used to declare variables. Instead, you must decare 
variables of this type as:
```c
// Assuming there is a person and a box declaration.
struct person p;
union box b;
```

Tags are the reason why you cannot create instances of structs, unions, enums as follows:
```c
person p;
box b;
```

Importantly, tags are defined in a separate namespace from ordinary identifier. This allows 
a C program to have both a tag and an identifierwith the same spelling in the same scope.
```c
struct person{...};
struct person person; // Declaring a struct person named person.
```

If you want to achieve the behavior of structs as types use `typedef`: 
```c
typedef struct {...} person; // Creating a person type.
```

Remember, even though the struct and pointer have been created, their values have not been set. 
Therefore, for example, `*p` is a pointer to an anonymous struct, but it does not point to any 
anonymous struct yet.

### Function Pointers 
Function pointers as the name implies are pointers to functions. To declare a function pointer use 
`return-type (*func-name)(parameter-types)`:
```c
/* 
 * Created a function pointer named func that accepts the address of a 
 * function with signature void(int, int).
 */ 
void (*func)(int, int);
```
Here is where it might get confusing. There are two ways of setting a function pointer.
```c
void printRes(int a, int b);

// 1. Directly assigns the address of printRes.
func = printRes;

// 2. Explicitly assigns the address of printRes.
func = &printRes;
```
In C, when you use the function name without parenthesis, it effectively represents 
the address of the function. This allows the syntax in the first example. So both 
`printRes` and `&printRes` refer to the same memory address.

When calling a function through a pointer, you can either dereference the pointer explicitly
of use the function pointer directly without dereferencing.
```c
// Both are the same.
(*printRes)(1,2);
printRes(1,2);
```

##### Type Qualifiers
Type qualifiers change the behavior when accessing objects of the qualified type. The type qualifiers 
are: `const`, `volatile`, `restrict`. The qualified and unqualified version of types can be used 
interchangeably as arguments to functions, return values from functions, and members of unions.

##### Strings
Strings are quite complex in C, String literals and Character Constants. A string literal, is represented 
as a pointer to the first character
