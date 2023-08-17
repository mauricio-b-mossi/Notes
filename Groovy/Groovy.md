# Groovy, the important things.

### Basics

- All variables are declared with the `def` keyword.
- Everything in Groovy is an object.
- Groovy is pass by value.
- You can use Java code in Groovy, therefore to use types, just declare as Java code.

###### Strings

- Single quote `''` store the string _literally_.
- Double quote `""` can access values.

```groovy
def name = "Mauri"
println('my name is ${name}') // my name is ${name}
println("my name is ${name}") // my name is Mauri
```

With groovy working with Strings (List) is a joy. It enables:

- Multiple selection: Can select multiple indexes from a list.
- List Slicing: Similar to Python, can take a slice of a list `[inclusive : Int, exclusive : Int]`. However,
  unlike python a the slice is defined by a **range** with the `start..end` inclusive syntax, similar to
  PowerShell.

```groovy
# Groovy
def name = "Mauri" // Strings are arrays of chars.
println("First and last of $name: " + name[0, name.length() - 1]) // Multiple index grab.
println("First three letters of $name" + name[0..2]) // Array slicing.
```

```powershell
# PowerShell
$arr = 1,2,3,4,5
Write-Host $arr[1..3] # 2, 3, 4.
```

```kotlin
// Kotlin
val arr = List(5){it + 1}
arr.slice(1..3).forEach(::println) // 2, 3, 4.
```

###### Arithmetic Operators and Strings

- String concatenation can be done using the `+` sign or the `concat()` method in Strings.
- Using the multiplication symbol `*` the String is repeated _n_ times.
- Using the subtraction symbol `-` the String after is subtracted from the String before.

```
println("hi" * 2) // hihi
println("hi".concat(" there")) // hi there
println("hi " + "there") // hi there
println("hi there" - "hi ") // there
```

###### Lists

Lists are dynamic, can hold multiple types.

```
def employee = ['Mauri', 20, 5.7, ["University of Florida", "Lamatepec", "ABC"]]
```

- To add values to a list you can use either the `add()` method or the `<<` operator.
- To concatenate lists you can use the `+`.
- To remove an item from a list you can use `-`.
  > `+` and `-` do not modify the list, they return a list with the transformations.

```
def primes = [1,2,3,4]
println(primes - [2]) // [1,3,4]
println(primes + [5,6,7,8]) // [1,2,3,4,5,6,7,8]
println(primes) // [1,2,3,4]
```

There are more of your typical methods for lists such as `intersect()`, `sort()`, `reverse()`.
However, you must be careful as some modify the list while others don't.

> Just as a note: I prefer Kotlin since the distinction between mutable and immutable methods are clearer.
> if it ends in _ed_ it is immutable, else it is mutable.

###### Maps

Maps are just containers for key-value pairs. You can access an element of a map using the bracket notation `['key']`
or the getter method `get('key')`.

```
def worker = [
    'name' : "Mauricio",
    'age' : 20,
    'major' : "CS",
    'address' : '2 Pinewood Street Dr',
    'phone' : [383112345, 25234452]
];
```

There are more of your typical methods for maps such as `put()`, `size()`, `containsKey()`.

###### Ranges

Ranges are similar to Kotlin ranges. The notation is the same: `initial..inclusive`.

```
def range = 1..10
range.forEach{print(it)} // 12345678910
```

These are the most common range methods:

- `size()`: Returns size of range.
- `get()`: Gets _n^th_ item from the range.
- 'contains()': Checks for membership in range.
- `getTo()`: Returns last element on the range.
- `getFrom()`: Returns first element on the range.

###### Conditionals

The conditional operators are the same as in Java and Kotlin. It supports the ternary
operator `<condition> ? <if true> : <else>`.

```
def age = 18
println(age >= 18 ? "Can vote" : "Cannot vote")
```

Groovy also supports a `switch` statement. Remember, if no `break` is added, the condition
will traverse though all the checks in the switch.

```
 def age = 18
  switch (age){
    case 1..5 : println("Child")
    case 6..12 : println("Kid")
    case 13..19 : println("Teen") // "Teen"
    default : println("Adult") // "Adult"
  }
```

An interesting behaviour is achieved when instead of `:` we use `->`. Arrows create a _Closure_,
therefore once the case is entered, the closure is returned. This explains the following:

```
def res = switch(age){
    case 1..18 -> "child"
    default -> "adult" // this is returned
}
println(res) // child
```

With `:` instead of `->` it is not possible to return a value from the switch.

###### Loops

Groovy contains all the basic for loops.

- `while`: Not much to explain, just your basic while loop.
- `for`: Normal for loop `for(i = 0; i < number; i++)`.
- `for in`: Similar to Kotlin `for(<var> in <container>)`.
```groovy
def names = ["Mauricio", "Valeria", "Cristy"]
for(name in names) println(name)
for(int i = 0; i < names.size(); i++) println(names[i])
```

> Under the hood, Groovy uses ArrayLists, therefore you cannot access the usual "length" property. Instead, use size.

###### Spaceship operator

The Spaceship operator compares two values. The possible return values are:

- A negative value if the left operand is less than the right operand.
- Zero if the left operand is equal to the right operand.
- A positive value if the left operand is greater than the right operand.

```
println("Ant" <=> "Banana") // -1
println("Ant" <=> "Ant") // 0
println("Banana" <=> "Ant") // 1
println(1 <=> 10) // -1
println(1 <=> 1) // 0
println(10 <=> 1) // 1
```

If that sound difficult to wrap your head around, here is a better explanation.

- Negative value ('-1'): Indicates that the _left-hand side value_ is **less** than
  the _right-hand value_.
- Zero ('0'): Indicates that the _left-hand side value_ is equal to the _right-hand side value_.
- Positive value ('1'): Indicates that the _left-hand side value_ is **greater** than
  the _right-hand value_.
