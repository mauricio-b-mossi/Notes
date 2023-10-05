<<<<<<< HEAD
=======
### Introduction to C++
Hi, in this series I intend to introduce C++. I've found it that the best way 
to learn a programming language, is by pointing out its distinct and similar features and syntax
to other programming languages. This is beneficial as `a)` you do not learn 
the language, rather the patterns, `b)` knowing the pattern you can understand 
several programming languages at a time. Plus making documents like these help for 
a quick refresher to the language.

I've omitted things that are common across several languages such as conditionals,
`if`, `else`, `switch`, as they are similar to C like languages: Java, C#, JavaScript.

One important note, `switch` can only be used with integral types. Integral types are all 
integers. Real types are all fractional numbers. This concept of Integral and Real types 
is also seen in C#.

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

>>>>>>> f525278bee7ae2ad5368193dbf222faf1faa647d
### User Defined Types
User defined types are types that the user can define. The three broad categories of user 
defined types are **enums**, **classes**, and **unions**.

#### Enums
C++ has both Scoped and Unscoped enums. Scoped enums where introduced in C++ 11, to declare them
use `enum class`. Unscoped enums come from C, to declare them use `enum`. The difference between Scoped and Unscoped enums is that Unscoped enums,
as the name implies are Unscoped, and they can be converted to and from ints. On the 
other hand, Scoped enums are scoped, you need to access them through the enum's namespace, and 
they cannot be redly converted to and from ints.
```cpp
enum class Color{RED, GREEN, BLUE};
Color red = Color::RED;
int numRed = static_cast<int>(Color::RED);

enum Color{RED, GREEN, BLUE};
Color red = RED;
int numRed = RED;
```
Prefer Scoped enums over Unscoped enums.

> You can use `enum class` with `switch`. Even though `swich` only accepts integral types,
> under the hood, `enum class` have integral types associated with them.

```cpp
enum class Color {RED, GREEN, BLUE};                // Compiler chooses the underlying type.
enum class Size : short {SMALL, MEDIUM, LARGE};     // Specify underlying type as short.
```

#### POD Classes
Classes are user-defined types that contain data and functions. The simplest type of class
is the plain-old-data class, POD for short. As the name implies these data classes are used 
mainly to store data.
```cs
struct Book{
    char rating;
    int pages;
    char category;
}
```

PODs have some useful low-level features. C++ guarantees that members will be sequential in 
memory, although some implementations require members to be aligned along word boundaries.
If you know about data alignment, word length, and word boundaries, you might of spotted the mistake 
in the code above.

##### Detour to word boundaries
> What does 64 and 32 bit processors mean? This represents the size of data your CPU can fetch
> per cycle. It is important to note that the values are in bits. A 64 bit processor can fetch 
> 8 bytes per instruction, while a 32 bit processor can fetch 4 bytes per instruction.
>
> Here is where data alignment comes in. In the example above, `Book` contains the data types `char`,
> `int`, and `char`, in their respective order, given that I have a 32 bit processor, this means
> that per cycle, my CPU can fetch and process 4 bytes of data. To make processing efficient, some
> times data is ***aligned*** around word boundaries, sacrificing memory for speed. Think about it, if 
> I stored `Book` in a contiguous block of memory it would just take 6 bytes, but how would I process
> the `int`, or one of the `chars`? I would need to use two CPU cycles to process the char and calculate, 
> the offset to get the second char. Pretty inefficient. The solution is to align data. That 
> way I can easily get and process information. 

> The code below illustrates data alignment.

```cpp
struct Book{
    // Size should be 12
    char grade; // 1 byte
    int pages;  // 4 bytes
    char rating;// 1 byte
};

struct GBook{
    // Should be 8
    char grade; // 1 byte
    char rating;// 1 byte
    int pages;  // 4 bytes
};

int main() {
    printf("Should be 12: %zd\n", sizeof(Book)); // 12
    printf("Should be 8: %zd\n", sizeof(GBook)); // 8
}
```

#### Unions
Usually you would not use unions, they are containers of data that can only store 
one member at a time. Consequently, the size of the `union` depends on the size of 
the largest member of the type.
```cpp
union Box{
    char str[4];
    int num;
};
```
In the example above, since both `char str[4]` and `int num` have a size of 4 bytes,
`Box` will also have a size of 4 bytes. The problem with unions, or rather its feature,
is that all members point to the same location in memory. Consequently, is I set 
`Box.num{0x48454C4C4F}` and retrieve and iterate over `str`, I will get the string "Hello".
```cpp
union Box{
    int num;
    char str[4];
};

int main(){
    Box box{0x484F4C41};
    for(int i = 0; i < 4; i++){
        cout << box.str[4 - i - 1]; // *If your system saves data from least significant byte to most significant byte*
                                    // Prints "HOLA" to the console.
    }
}
```

##### Detour to Endianness
> Endianness: Refers to how you computer saves data. Endianness is primarily expressed
> as ***big-endian*** or ***little-endian***. 
> - A big endian system stores the most significant byte of a word at the lowest memory address.
> - A small endian system stores the least significant byte of a word at the lowest memory address.

In the example above, I ran the program in a little-endian system, I the most significant byte,
48 in hex, or H in ASCII, was stored last. Therefore, I had to traverse from the back to the front 
of the string to get the string `"HOLA"`. Note, this is not the correct way to construct strings. 
As mentioned above, for C style strings, the last element must be null.

For further proof, if we set `Box.num{1}`, this would be the same as `0b00000001`. If I get the 
first byte and it is 1. This means that my system stores the least significant byte first.
```cpp
Box box{1};
if(box.str[0] == 1){
    cout << "SMALL ENDIAN"; // If the first item is 1, then system stores the LSB at the lowest address in memory.
}

// -- Or --

int n = 1;
if(*(char *)&n == 1) cout << "SMALL ENDIAN";
```

### Fully Features C++ Classes
`struct` and `class` can be used interchangeably, the only difference is the default accessibility
modifier. By default, `struct` members are public, while `class` members are private.
To manually set the accessibility modifier of `class` and `struct` members use `public:`
and `private:`.
```cpp
class Dog{
    int age;
    char name[10];

  public:
    void bark(){
        cout << "Woof" << endl;
    }
}
```

Constructor declarations don't state a return type, and their name matches the class's name. The constructor
is called automatically when a class is initialized. A user-defined types are ***always initialized*** by
calling their constructor. This differs from primitive types which are not initialized if declared.
```cpp
class Dog{
//-- snip --
    Dog(const char* name, int age){
        ...
    }
}
```


The Destructor is a clean up function, with the same name as the constructor but prefixed with 
the `~`. It runs clean up code when the object is destroyed. Note, the destructor cannot take arguments.
```cpp
class Dog{
//-- snip --
    ~Dog(){
        printf("Descructing %s", name);
    }
}
```

### Initialization
> Fully Featured Classes (not PODS) are automatically initialized using their default constructors
> if not explicitly initialized, while primitive types, especially when declared as global 
> or static variables, are not guaranteed to be initialized automatically, and their initial values are undefined.
> It's always good practice to initialize all variables explicitly to avoid unexpected behavior.

Hang on, initialization is a mess. There are several ways to initialize types in C++. As a rule 
of thumb, prefer brace initialization. You can initialize a fundamental type, primitive type, as 
follows:
```cpp
int a = 0;
int b{};
int c = {};
int d;
```

> Braced initialization ***zeroes*** uninitialized variables.

All the above initialize the variable to 0 but `d` which has undefined behavior: avoid initializing a variable like `d`.
Initializing to an arbitrary value is similar to initialing a fundamental type to zero:
```cpp
int e = 42;
int f{42};
int g = {42};
int h(42);
```

All the above initialize the variable to `42`. However you should avoid `h`, as if you get used to it, you 
might get the ***most vexing parse***. Where a `Type <variable>()` is not interpreted as an 
initialization but rather a function.

Brace initialization generates warnings due to ***narrowing conversion***: when the literal 
of a variable is truncated to fit the type.
```cpp
int a = 1.2;    // a = 1 
int b = {1.2};  // Error: double cannot be narrowed to int.
```

I really like brace initialization for PODS. You initialize the members in order, the members for which
no value is provided are zeroed.
```cpp
struct Person{
    char name[8];
    int age;
}; 

Person a{}; // name = "", age = 0;
Person b{"Jose"}; // name = "Jose", age = 0;
Person b{"Jose", 21}; // name = "Jose", age = 21;
```

##### Member initialization list
Member initialization lists allow you to initialize `const` members at runtime. As a side benefit
it also allows you to separate initialization logic with member value assignment. To use member
initialization list, in the constructor after the parameter list add a `:` and in a comma separated
list initialize the members inline.
```cpp
class Person{
    string name;
    int age;
  public:
    Person(string name, int age) : name{name}, age{age}{
        // Initialization Logic
    }
}
```

### Reference Types
C++ provides two main reference types ***pointers*** and ***references***. Pointers, as the 
name implies point to a position in memory. References refer to an object in memory. Knowing this 
we can say that references are ***lvalues***: they are stored in memory. Pointers allow you 
to perform pointer arithmetic (increment and decrement), where the type of the pointer
defines the size of the jump of addresses. For example, if I have an `int*` then the 
jump in addresses will be 4 bytes, 32 bits, since that is the size of the `int` type.

```cpp
int hola{0x484F4C41};
for (int i = 3; i > -1; i--) {
cout << *(((char *)&hola) + i); // HOLA
}
```

This example illustrates pointer arithmetic of `char*`. Since `char` has a size of 1 byte, 8 bits,
increment or decrement operations on `char*` increase or decrease the address in multiples of 
1 byte. This is why through pointer arithmetic we can get the individual bytes of `int hola`.

With pointer you can dereference an address, in simple terms this means getting the value stored 
in that address. This is done with the dereference operator `*`. We used the dereference operator in 
the example above to get the value of `char *`.

References literal pass and get the reference to an object, the difference between a pointer and a reference
is that references cannot be set to reference another object in memory. The value of the reference represents 
the value of the reference object in memory. If used as a lvalue, you can modify the object being referenced,
if used as a rvalue, you get the value of the object being referenced.

##### Member-of-Pointer (->)
You might see the `->` operator, this is short hand notation for accessing members of a 
pointer object. To illustrate:
```cpp
struct Box{int items;};

int itemsInBox(Box* box){
    return box->items;
};

int p_itemsInBox(Box* box){
    return (*box).items;
};
```
Both, `itemsInBox` and `p_itemsInBox` do the same thing, the only difference is in the notation used.

Here is a sample Linked List implementation using pointers:
```cpp
struct Element {
  int value;
  Element *next{};
};

// -- use --

Element third{3};
Element second{2, &third};
Element first{1, &second};

Element* curr = &first;

while(curr){
    cout << curr->value << endl;
    curr = curr->next;
}
```

In most cases you use pointers when you need to change what you point to or perform pointer arithmetic; else use 
references.

##### Arrays and Pointers
> Pointers share several characteristics with arrays. Pointers encode object location.
> Arrays encode the location and length of contiguous objects. <mark>At the slightest provocation, 
> an array will decay into a pointer</mark>. A decayed array loses length information and 
> converts to a pointer to the array's first element.

When an array has not decayed to a pointer, you can use the `sizeof` operator to get the size in bytes
of the array. Every time you pass the array variable to a lvalue, the array will decay to a pointer.

From other languages you might of seen the `[]` notation for indexing arrays. The same works for arrays and 
pointers in C++. Indexing a pointer calculates the offset size and dereferences the pointer:
```cpp
int nums[3]{1,2,3};
cout << (nums[2] == *(nums + 2)) << endl; // true.
```

The code above prints 1 to the console, remember booleans can be readily converted to and from 
integers, where a true state converts to 1 and false converts to 0. 

##### Void and std::byte Pointers
- Void pointers are used when the pointed type is irrelevant. Since void holds no value, 
it is impossible to dereference a `void*`. For similar reasons since `void` does not have size,
pointer arithmetic is not possible with `void*`.

- `std::byte` pointers are sued when you want to interact with individual bytes of memory. This is 
especially handy when you consider that the smallest addressable unit of memory is the byte.

##### nullptr
***`nullptr` is the default value assigned to a pointer when you used brace initialization.*** It represents 
a pointer with no value. <mark>Pointers have an implicit conversion to `bool`. Any value
that is not `nullptr` converts implicitly to `true`, whereas `nullptr` converts implicitly to 
false</mark>.

##### References
> References are safer, more convenient versions of pointers. You declare references with 
> the `&` declarator appended to the type name. References cannot be assigned to null (easily),
> and they cannot be reseated (or reassigned).

Think of references as a dereferenced pointer to an lvalue. If you are familiar with C#, references
are the same, or similar, to `ref`.
```cpp
void changeName(&Student s){
    s.name = "Jose";
}
```
With references, you can only retrieve the value of the referenced object, or set the value of 
the referenced object. Unlike pointers, you cannot make a reference refer to another object after 
Initialization.

### Object Lifecycle
Put simply, objects are `lvalues`: They are a place in storage that holds a value. `rvalues` are not 
objects as they are not stored in storage but rather in the stack. In general:
1. Object first is assigned a storage location.
2. Object is constructed / initialized.
3. Object is used.
4. Object is deconstructed.
5. Object storage is deallocated.

#### Local Variables
Local variables have automatic storage, meaning, once the end of the scope enclosing the variable is 
reached, the vairable gets deallocated. This encludes functions, in which the variables within and even 
the parameters get deallocated when the end of the function is reached.

### Static Storage
Static storage duration lasts for the entirety of the program. You declare a variable with
static storage duration using the `static` keyword. The `static` keyword is used in global static
variables, static members and local static variables. **Global static** variables can be accessed within
anyplace in the translation unit. **Static Members** can be accessed using the `::` scope resolution operator.
**Local Static variables** can be accessed only within the local scope.
```cpp
// Global Static.
static int thing = 0;
// Static Member.
struct Employee{
    static int NumberOfEmployees;
};
// Local Static.
void DoSomething(){
    static int Count;
}
```
It is important to note that, for example, even though we can call `DoSomething` several times, or create 
multiple instances of `Employee`, there exist only one `Count` and `NumberOfEmployees` respectively.
The lifetimes of both **Local Static** and **Static Members** begin upon first invocation.

>> All static variables have a **single** instance.

#### Dynamic Memory
This is the fun part. It might be easy as you might be so used to it, but how does it really work. Dynamic memory, 
as the name implies is dynamic, you control it. Remember the object lifecycle form above? Basically, 
memory is assigned to a variable, a variable initializes the memory with some value, the variable is used,
the variable is destructed, memory is deallocated. For dynamic memory you have to do all this by your self.
You petition some memory with the `new` operator followed by the type of memory you want. The `new` operator
returns a pointer to the storage location in the **heap** where your object is stored. After use, you deallocate the 
object using the `delete` operator and passing the pointer containing the storage location of the object. Note,
`delete` returns void, while `new` returns a pointer of the type of memory you petitioned.
```cpp
// Long way, petitioning size and then setting the value.
int* a = new int;
*a = 10;
// Short way, petitioning size and setting the value at the same time.
int *a = new int{10};
// Delete
delete a;
```
Something that might throw you off is what actually does the `new` and `delete` operators do. They might seem simple,
but people tend to have misconceptions about them. First of all `new` just returns a pointer to a storage of memory you can 
use. Keep in mind this in no way ensures the memory given is "empty", it can have some values that are no longer in use. Something
similar is true for the `delete` operator, it just returns that memory to a memory pool, the same from which the pointer you got with 
`new` came from, and calls the Deconstructor of the type. In no way shape or form does it clean the data, think about this, it would be 
inefficient.
```cpp
int *a = new int;
cout << *a << endl; // Some random integer.
delete a;
cout << *a << endl; // Another, or possibly the same integer.
```
In the example above we can see a **dangling pointer**: a pointer that points to a freed memory location. One 
famous error caused by dangling pointers is the **use after free error**.

#### Dynamic Memory and Arrays
You can also dynamically allocate arrays, doing so follows a similar process as outlined above. You set
an array on the heap using `new T[size]`, this returns a pointer to the first element of the array in the heap.
To delete the array you use the `delete[] array`. Note it is important to distinguish between `delete[]` and 
`delete`. 

If you are curious as me you might ask, and how does C++ know how many elements to delete with `delete[]`? Here is the 
answer:
> When you allocate memory on the heap, your allocator will keep track of how much memory you have allocated.
> This is usually stored in a "head" segment just before the memory that you get allocated. 
> That way when it's time to free the memory, the de-allocator knows exactly how much memory to free.

### Exceptions
Exception handling is achieved thru `throw`, `try`, `catch`. You can throw any object as an error, however it is 
a good practice to throw an error from the exception library `<stdexcept>`. You catch exceptions within `try` blocks
in `catch` blocks. The `catch` block specifies the type of exception caught. You can use ellipsis `(...)` to catch
all exceptions.
```cpp
// #include<stdexcept>
void throw_err(){
    try{
        thorw std::runtime_error("I'm going to make you an exception");
    } catch(int &e){...}
    catch(std::runtime_error& e){
        std::cout << e.what() << std::endl;
    }
    catch(...){
        std::cout << "Catching All Exceptions" << std::endl;
    }
}
```

Remember, you can throw any object as an exception. However, you should mostly prefer to 
throw a `stdlib` exception class as convention. Stdlib classes rely on inheritance where 
the base class of all `stdlib` exceptions is the `exception` class found. Exceptions are divided
into three main sub classes: `logic_error`, `runtime_error`, and language support_error. Each of
these subclasses contain other subclasses.
- You use `logic_error` to represent when a precondition is not satisfied. 
- You use `runtime_error` to represent exceptions outside the scope of a program.
- You usually wont use language support errors as they indicate the failure of a language feature.

> The `exception` class is the base class of all `stdlib` exceptions.
