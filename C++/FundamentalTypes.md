### Introduction to C++
Hi, in this series I intend to introduce C++. I've found it that the best way 
to learn a programming language, is by pointing out its distinct and similar
with other programming languages. This is beneficial as `a)` you do not learn 
the language, rather the patterns, `b)` knowing the pattern you can understand 
several programming languages at a time. Plus making documents like these help for 
a quick refresher to the language.

I've omitted things that are common across several languages such as conditionals,
`if`, `else`, `switch`, as they are similar to C like languages: Java, C#, JavaScript.

One important note, `switch` can only be used with integral types. Integral types are all 
integers. Real types are all fractional numbers. This concept of Integral and Real types 
is also seen in C#.

> For ***switch***, something that threw me off guard: if a case is fulfilled, all the other cases will be fulfilled
> Therefore, all the case code blocks after the satisfied condition will execute. Use `break` to stop this cascading 
> behavior.

### Important Concepts
- `lvalue`: Left value, has a position in memory.
- `rvalue`: Right value, does not have a position in memory.
```cpp
string firstname = "Mauricio";          // lvalue = rvalue
string lastname = "Mossi";              // lvalue = rvalue
string fullname = firstname + lastname; // lvalue = (lvalue) + (lvalue) -> lvalue = rvalue.
// The addition of strings does not store a string in memory or mutates a string, rather it creates 
// a new string literal, therefore it is a rvalue.
```

This example, illustrates lvalue, and rvalue perfectly:
```cpp
Type& alterType(Type& t){   // Non-const lvalue reference to type 'Type' cannot bind to a temporary of type 'Type'
    return Type{20}         // Error, function should return lvalue but returns rvalue
}                           // Type& is rvalue, since it is a reference it is stored somewhere,
                            // and I am returning a Type which is not stored anywhere. Consequently
                            // I am returning an rvalue where a lvalue is expected.

Type& alterType(Type& t){
    t = 20;
    return t;               // Works, returning t which is a lvalue.
}
```


### The Compiler Tool Chain
After writing the source code for a C++ program, the next step is to turn
your source code into an executable program.
- The ***preprocessor*** performs basic source code manipulation, for example
handling directives such as `#include`, `#pragma`, `#define`, and produces a 
translation unit.
- The ***compiler*** reads the translation unit and produces an object file. 
Compilers work on one translation unit at a time.
- The ***linker*** generates programs from object files. Linkers are also 
responsible for finding the libraries you've included within your source code.

### Printf
We know that we can print constants like `"Hello World"` easily with `printf`. To 
print values other than strings, use format specifiers. The first argument of 
`printf` is always a format string. The format string provides a template for the 
string to be printed. Format specifiers tell printf how to interpret and format the 
arguments following the format string: `printf(<format-string>, <args>)`.

> `printf` has issues, and once you've learned `cout`, you should prefer it [...].
> Using cout means you do not need format strings, so you don't need to remember 
> format specifiers.

### Fundamental Types
Fundamental types are the most basic types of object and include integer, floating-point,
character, boolean, byte, size_t, and void. Some refer to fundamental types as primitive 
or build-in types because they're part of the core language and almost always available to you.
These types will work on any platform,but their features, such as size and memory layout,
depend on implementation.

#### Integer Types
Same as C, you have `short int`, `int`, `long int`, and `long long int`. All of the previous,
except for `int` itself can omit the `int` postfix. Also all the above can be either signed (positive and negative)
or unsigned (non-negative). By default, integer types are signed and int by default.

A literal is a hard-coded value in a program. You can use one of the four hard-coded, integer literal
representations:
- ***binary***: Uses `0b` prefix, `0b0011`.
- ***octal***: Uses `0` prefix, `03`.
- ***decimal***: Default `3`.
- ***hexadecimal***: Uses `0x` prefix, `0x03`.

> Be careful with things such as zip codes which might start with `0` as this `int zip = 021339` won't compile because 9 is not an octal digit.

For readability, integer literals can contain `'` to separate values, `1'000'000`.
Importantly, integer literals take up the smallest type that fits its value. You can 
specify the type in the declaration or in the literal:
```cpp
long ...
takeLong(123L);
```

Number format specifiers:
- short: `%hd`.
- unsigned short: `%hu`.
- int: `%d`.
- unsigned int: `%u`.
- long: `%ld`.
- unsigned long: `%lu`.
- long long: `%lld`.
- unsigned long long: `%llu`.
- hexadecimal: `%x`.
- octal: `%o`


#### Floating-Point Types
- float: single precision.
- double: double precision.
- long double: extended precision.

Floating-Point literals are double precision by default. If you need single or extended 
precision add the postfixes `f` or `l` to the literal.

Number format specifiers:
- printf chooses format: `%g`.
- decimal digits: `%f`.
- scientific notation: `%e`.

For double precision just prepend the letter `l` to the specifier: `%lg`, `%lf`, etc. 
For extended precision just prepend the letter `L` to the specifier: `%Lg`, `%Lf`, etc. 

#### Character Types
Character types store human language data. The six character types are: `char` (1 byte), 
`char16_t` (2-bytes), `char32_t` (4-bytes), `signed char`, `unsigned char`, `wchar_t`.

The character types `char`, `signed char`, and `unsigned char` are called narrow characters, 
whereas `char16_t`, `char32_t`, and `wchar_t` are called wide characters due to their storage requirements.

Characters by default are of type `char` to declare a literal of a different type, prefix
the character literal with `L` for `w_char_t`, `u` for `char16_t`, and `U` for `char32_t`.
For example: `'A'` is a `char`, but `L'A'` is a `w_char_t`.

Character format specifiers:
- char: `%c`.
- wchar_t: `%lc`.

> `char`, `unsigned char`, and `signed char` can, and are used, in C like a byte type. 
> You can perform arithmetic on arithmetic on chars. To avoid performing unsafe operations
> on chars, C++ provides the `std::byte` type, which actually represents a byte.

##### Escape Sequences
Some characters don't display on the screen. Instead, they force the display to do 
things like move the cursor to the left side of the screen (`\r`), or move the 
cursor down one line (`\n`). To put these characters into a `char` use escape sequences.

#### Boolean Types
Boolean types have two states: true and false. The sole boolean type is `bool`. 
To initialize boolean types use the `true` and `false` literals. 

> Integer types and the bool types convert readily: the true state converts to 1, 
> and the false converts to 0. Any non-zero integer converts to true, and 0 converts to 
> false.

As boolean types are integers, the format specifier is also `%d`.

Operators on Boolean types can be unary, binary, or ternary, it depends on how many operands
the operator takes.

#### std::byte Type (C++17), <cstddef>
This type does not have an exact corollary type in the C language. Like C++, C has `char`
and `unsigned char`. These types are less safe to use because they perform arithmetic  on a 
`char` but not a `std::byte`.

> The odd-looking `std::` prefix is called a namespace. That is why when you use
> `using namespace std;` you avoid specifying the namespace each time. 

#### size_t Type, <cstddef>
The `size_t`, encodes the size of objects. It guarantees to store the maximum 
size in bytes of all objects. Technically this means that `size_t` could take 2
bytes or 200 bytes depending on the implementation.

> The type `size_t` is a C type in <stddef> header, but it's identical to the
> C++ version, which resides in the std namespace. Occasionally you will see the 
> technically correct construction `std::size_t`.

To print sizes use the `%zd` format specifier for decimal, and `%zx` for hexadecimal.

##### sizeof
The `sizeof` operator method takes a type of operand and returns the size in bytes of that 
type. The `sizeof` operator always returns a `size_t`. To get the size of an array use `sizeof(arr) / sizeof<type>`.

#### Void 
The type void has an empty set of values. Because a void object cannot hold a value,
C++ disallows void objects. You use void in special situations, such as the return type 
for functions that don't return any value.

### Arrays
Unlike other programming languages, there is no such thing as an array type. Arrays are 
just sequences of identically typed variables. When you initialize an array in C++, 
by specifying either its size or elements, the compiler uses the provided elements to 
determine the size of the array. In this case, the size is known at compile-time.
However, when you pass an array to a function, the size information is not passed along 
with it. The function receives just the pointer to the first element and has no 
inherent knowledge of the array's size.

> Array declaration in C++ is different from other languages. If a specific size is needed,
> you can either declare the array with size `int nums[3]` or if you know the default values
> use braced initialization `int nums{1,2,3}`.

Depending on your compiler the following code will provide warnings. As added as a comment
of the function `getSize`. Note, compiler warnings is not the same as compiler errors.
```cpp
void getSize(int arr[]);

int main() {
  int arr[] = {1, 2, 3, 4, 5};
  printf("The size of the array is: %zd\n", sizeof(arr) / 4);
  getSize(arr)
}

void getSize(int arr[]) {
  // Sizeof on array function parameter will return size of 'int *' instead of 'int[]'
  printf("The size of the array is: %zd", sizeof(arr) / 4);
}
```

You can iterate through an array several ways:
```cpp
// C++
int arr[] = {1,2,3};

for(int i = 0; i < sizeof(arr) / sizeof(int); i++) printf("%d", num);

for(int num : nums) printf("%d", num);
```

For certain objects like arrays, `for` understands how to iterate over the range
of values within an object. Above it the syntax for a ***range-based loop***. If you 
come from Java, it is the same syntax. Just for the sake of comparison, here is the same
done in Java.

```java
// Java
int[] nums = {1,2,3};

for(int num : nums) System.out.println(num);

for(int i = 0; i < nums.length; i++) System.out.println(nums[i]);
```

The main difference is that Java does have array types, and that as the array type has 
a property length, which stores the length of the array. Being types, arrays in Java can 
be passed around without loosing information. In theory, in Java we could also declare `nums`
as `int nums[]`, but this is highly discouraged.

### Stings
C-style strings are contiguous blocks of characters that are terminated via a 0 byte, known 
as the null char `\0`. String literals in C are immutable, while char arrays are mutable. If you 
use a string literal, just declare it, and the compiler automatically adds the null character to the 
end. If you use a char array, you must be mindful to allocate the size of the string + one, the one 
representing the null character.

The format specifier for narrow strings - strings made up of narrow `char` - is `%s`.

Not recommended for use, but consecutive string literals get concatenated together, and 
any intervening white space or newlines get ignored:
```cpp
char mystr[] = "my "
             "name "
             "is "
             "Mauricio";
printf("%s", mystr); // my name is Mauricio
```
