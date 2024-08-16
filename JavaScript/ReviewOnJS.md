## Chapter 3: Variables and Values
### Statements and Expressions
Statements perform some kind of action, while expressions produce a value. There are 
some instances in which it might be ambiguous whether something is an expression
or a statement. Take for example:
```javascript
// 1. Statement, function declarations.
function f(x, y){...}
// 2. Expression, setting g to the value returned by function f.
const g = function f(x, y){...}

// 3. Statement, creating a block
{}
// 4. Expression, creating and object literal.
const obj = {x, y}
```
In the first example `function` is a statement, it does not produce a value. In the 
second example `function` is an expression and does produce a value. In the third 
example `{}` is a statement. In the fourth example `{}` is a statement as it initializes
an object literal.

How can we disambiguate such syntax? Simple, if the line starts with `function` or `{}`
it is a statement. Else it is an expression and returns a value. So for example:

```javascript
(function sayHi(){console.log("Hi")})()
(function sayHi(){console.log("Hi")}())
({x, y})
```

Both are expressions as the line does not start with `function` or `{}`.

### Semicolons, where to put them?
Semicolons terminate statements. However, not all statements need semicolons. If the 
statement ends with a block it does not need a semicolon, since the compiler knows blocks
are statements. If you put a semicolon after a block, the compiler interprets it as an 
empty statement.

### Sloppy vs Strict Mode
To activate strict mode add the `"use strict"` directive at the top of your file.
Strict mode is activated by default in modules and classes.

1. In sloppy mode undeclared variables create properties on the global object. In strict mode
a `ReferenceError` is thrown.
2. In sloppy mode functions are function-scoped. In strict mode they are block 
scoped.
3. In sloppy mode changing immutable data fails silently. In strict mode it throws a type error.

### Scope and initialization
- `var` and `function` are function scoped.
- `var` is initialized to `undefined` upon entering the containing function's body until line of initialization (LOI) is reached.
- `function` is initialized to the function body upon entering the containing function's body.
- `const` and `let` are block scoped.
- `const` is a constant, the object it is bound to cannot change. Available until LOI is reached.
- `let` is a variable. Available until LOI is reached.

### Closures
A `function` can contain bound (defined internally) and free variables (defined externally).
When a function is created, it saves the free variables at the point of creation.

### Types
There are eight main types in JavaScript as specified by the ECMAScript specification.
- `undefined`: {`undefined`}
- `null`: {`null`}
- `boolean`: {`true`, `false`}
- `string`: {any string}
- `number`: {any number}
- `bigint`: {any large number}
- `symbol`: {any symbol}
- `object`: {any object}

Of the types all but `object` are primitives. 

### Null and Undefined
It might seem confusing to have both `null` and `undefined`. However, they have 
differing meanings. 

- `null` represents an intentional no value.
- `undefined` represents a no assignment.

### Primitives vs Objects
- Both `primitives` and `objects` are key-value pairs* (`undefined` and `null` cannot have properties).
- Unlike `objects` the properties of primitives are immutable.
- Both `primitives` and `objects` are passed by value.
- The value passed by objects is its identity, think pointer, like Java. 
- Equality of primitives is determined by value.
- Equality of objects is determined by identity.

```javascript
const a = []
const b = "string"

a.length // 0
b.length // 6

a.length = 20 // [] is an object, hence its properties are mutable.
b.length = 10 // Fails if in strict mode.

a.length // 20
b.length // 6
```

### typeof and instanceof
- `typeof` is for primitives. It is a unary operator. Given a binding it returns it's type.
- `instanceof` if for objects. It is a binary operator. Given a binding and
a class it determines whether the binding is an instance of the class by returning a `boolean`.

There are some quirks to `typeof`. It does not exactly return the 8 ECMAScript types.
It has one omission and one addition. 

```javascript
typeof null // "object"
typeof (function x(){...}) // "function"
```

`null` is not an object. It is the representation for no value.
`function` is an object. All functions are objects.

Just like in Java, `int` and `Integer` are different things. A primitive `number` is 
not an instance of  `Number`. In general, a primitive is not an instance of anything.

```javascript
123 instanceof "Number"         // false
"string" instanceof "String"    // false
```

### Wrapper Types
Every `primitive` except `null` and `undefined` have constructor functions. These functions
convert primitives to objects, act as a namespace for methods on `primitives`. Similar to Java*,
the name of the wrapper type is the name of the primitive type but staring with uppercase.

There are two ways to convert between types. 
1. Coercion, automatic conversion of types: `+"123"`.
2. Explicit conversion via constructor functions: `Number("123")`.

```javascript
Number.isInteger(123)           // true
Number("123")                   // 123
123.toString                    // Number.prototype.toString

new Number(123) === Number(123) // false
Number(123) === 123             // true
```
> Note, `new Number` constructs an object, while Number casts to primitive number.

### Operators
When using operators it is important to consider that
1. operators coerce operands to the appropriate type to perform an operation.
2. operators mostly work on `primitives`.

- `*`: Only works on `number`.
- `[]`: Only works on `string` and `symbol`.
- `+`: Only works on `string` and `number`. If one operand is a string,
it coerces the other to a string, else it coerces both operands to `number`.

### Strict (===) and Loose (==) Equality and Object.is()
- Loose equality coerces unequal types to boolean.
- Loose equality coerces objects to primitives if one operand is a primitive. It does not coerce if both are objects.
- Loose equality treats `null` equal to `undefined`.
- Strict equality does not coerce types.
- Strict equality does not treat `null` equal to `undefined`.
- Object.is is stronger than Strict equality for `NaN`.
```javascript
NaN === NaN         // false
Object.is(NaN, NaN) // true
```

> Note, equality in JavaScript is really quirky. Loose equality (==) coerces.
> Strict equality (===) does not coerce. Only `Object.is` compares `NaN` correctly.

Other operators:
- `,`: Accepts two operands, evaluates both, returns last one.
- `void`: Accepts an operand, evaluates the operand and returns undefined.

## Chapter 4: Primitive Values
### `undefined` and `null`
- `undefined`: Represents a no value assigned.
- `null`: Represents an intentional no value, or no meaningful value.
- `??`: Null coalescing operator, if lhs is `null` or `undefined` returns rhs.
- `??=`: Null coalescing assignment operator, if binding or property is `null` or `undefined`
it assigns the value on the lhs. 
```javascript
/*
    If the author property in the book object is null
    or undefined bind it to the string "(Unknown)".
*/
function normalizeBook(book){
    book.author ??= "(Unknown)"
}
```

One important thing to note is that `undefined` and `null` are the only two values / types that 
do not have properties. A `TypeError` is thrown when trying to access properties on both types.

```javascript
undefined.foo   // TypeError: Cannot read properties of of undefined (reading 'foo')
null.foo        // TypeError: Cannot read properties of of null (reading 'foo')
(1).foo         // undefined
"str".foo       // undefined
```
> This is why we use optional chaining (`?.`) to avoid such errors.

### `boolean` and Coercing
You can coerce any type to a `boolean` in JavaScript. Here are the rules for coercion:
- `undefined`: `false`.
- `null`: `false`.
- `boolean`: unchanged.
- `number`: `false` if `0` or `NaN`, `true` otherwise.
- `bigint`: `false` if `0`, `true` otherwise.
- `string`: `false` if `''`, `true` otherwise.
- `symbol`: always `true`.
- `object`: always `true`.

> Note, since arrays are of type `object`, even an empty array `[]` evaluates to `true`.

The conditional operator (`?:`) is the expression version of the `if` statement. Depending on the condition
only the correct side is evaluated: `<condition> ? <if-expression> : <else-expression>`. Since it has three
operands it is also known as the ternary operator. The conditional operator is short circuiting.

Binary logical operators AND (`&&`) and OR (`||`) are value preserving and short circuiting.  

- value preserving: Even though the operands are coerced into `boolean` the uncoerced value is returned.
- short circuiting: If the first operand determines the result the second operand is not evaluated.

Logical AND (`&&`) evaluation of `a && b`:
- if `a` is truthy return `b`.
- else return `a`.

Logical OR (`||`) evaluation of `a || b`:
- if `a` is truthy return `a`.
- else return `b`.

Logical NOT (`!`) evaluation of `!x`:
- if `x` is truthy return `false`.
- else return `true`.

### `number`
Every number in JavaScript is a 64-bit floating point number, as specified by the IEEE 754 standard.

- `Number`, `Number.parseInt`, `Number.parseFloat`, `+` convert type to number.
- `_` is a valid separator between two digits.
- `NaN`, `Infinity`, and `-Infinity` are error values.
- `NaN` is the result of a failed casting and failed operation. 
- `Infinity` is the result of division by zero and large values.

- `0b` prefix for binary number literals.
- `0o` prefix for octal number literals.
- `0x` prefix for hexadecimal number literals.
- `eN` to represent `x10^N`.

- `/` for floating point division. Use `Math.floor` or `Math.ceil` for integer division
- `**` for exponentiation.
- `%` for remained, not modulo: `-7 % 3 = -1` and `7 % 3 = 1`

You can cast any type to a `number` in JavaScript. Here are the rules for type casting:
- `undefined`: `0`.
- `null`: `0`.
- `boolean`: `0` if `false`, `1` if `true`.
- `number`: unchanged.
- `bigint`: `0` if `0n`, etc.
- `string`: `0` if `''`, `number` if parseable, `NaN` else.
- `symbol`: throws `TypeError`.
- `object`: returns result `valueOf` method on object. Override method to specify type cast.

```javascript
Number({valueOf : function(){return 123}}) // 123
```

Beware of `NaN`. `NaN` is the only value that is not strictly equal to itself. There are several options to check for NaN:
```javascript
const x = NaN

x === x             // false
x !== x             // true
Object.is(x, x)     // true
Number.isNaN(x)     // true
```

> Be careful while checking for `NaN` in arrays since `NaN !== NaN`.

`Infinity` is equal to itself. There are several ways to check for `Infinity`:
```javascript
const x = Infinity

x === x             // true
Object.is(x, x)     // true
Number.isFinite(x)  // false
```

#### (Advanced) More on `number`
**Safe integers**, since JavaScript uses 64-bit floating point numbers according to the IEEE 754 standard for all
numbers. There is a range of continuous integers available. This range is given by `[-2^53 + 1, 2^53 - 1]`. The 
reason for this range is that according to the standard, a 64-bit floating point number is made up of:
- 1 bit sign
- 11 bit exponent
- 52 bit mantissa

Any integer number has an exponent of zero, therefore the mantissa and sign bits determine the value of the integer.
- `Number.MAX_SAFE_INTEGER`: Returns `2^53 - 1`, the largest safe integer.
- `Number.MIN_SAFE_INTEGER`: Returns `-2^53 + 1`, the smallest safe integer.

**Bitwise operations** operate on 32-bit numbers. Therefore, before performing the operation, operands are converted
to 32-bit numbers. The result is reconverted to a 64-bit number.

### Bitwise operations
Bitwise operations are performed on **32-bit two's compliment integers'**. Meaning, numbers will be coerced
into 32-bits before the operation.
```javascript
2**31           // 2147483648
2**31 >> 0      // -2147483648
2**31 >>> 0     // 2147483648
```
- `>> and <<`: Signed shift. Interprets result as **32-bit two's compliment**.
- `>>> and <<<`: Unsigned shift. Interprets result as **32-bit unsigned integer**.

> Note, for `BigInt`, bitwise operations interpret negative sign as an infinite two's compliment. Therefore,
> unsigned shift right is not allowed since there is no "zero from the left" resulting form the operation.

### `bigint`
`bigint` is a primitive type that represents integers. The container grows dynamically to accommodate the integer.
This is useful since the biggest `Number.MAX_SAFE_INTEGER == 2**53 - 1`. To represent larger numbers use `bigint`. 
Arithmetic between `bigint` and `number` is incompatible since `BigInt` can only represent integers of arbitrary size,
not fractions. However, comparison between both types is allowed. `bigint` can perform most operations `number` can, 
with the exception of unary plus and unsigned shift right. 

`bigint` provides methods to set the bit width of integers via:
- `bigint.asIntN(width, theInt)`: Casts `theInt` to `width` in bits (signed).
- `bigint.asUintN(width, theInt)`: Casts `theInt` to `width` in bits (unsigned).

> Note, `bigint` cannot be stored in JSON.

### string
`string` is an immutable type. There is no character type in JavaScript, characters are strings. However, JavaScript 
interprets 16-bits chunks of a string as characters. It is important to make a distinction between:
- `JavaScript character`
