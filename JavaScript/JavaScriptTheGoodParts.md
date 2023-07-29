### Types
The primitive types include:

- string
- number
- bigint
- boolean
- undefined
- symbol
- null

> JavaScript has a single ***number type*** . Internally, it's represented as a 64-bit floating 
> point, the same as Java's double.

> JavaScript does not have a ***character type*** . To represent a character, make a string with just 
> one character in it.

To view the type of a variable use the `typeof` infix function, which produces the values 
`'number'`, `'string'`, `'boolean'`, `'undefined'`, `'function'`, and `'object'`. 

> Note, if the operand is an array or null, typeof will return `'object'`, which is wrong.

NaN is not a type, nothing is equal to NaN, not even NaN === NaN. To check for NaN use `.isNaN()`.

### Objects
Everything in JavaScript, except primitives are objects. 
This makes function objects as well, every object has a prototypal chain. Meaning that 
an object references another object called its prototype. When looking for a property, JavaScript 
searches in the object, if it finds the property it returns it, else it goes to its 
prototype and so on. A value of `undefined` is returned if the prototypal chain leads 
to an object, the `Object` object, whose prototype is null. This is prototypal inheritance 
in a nutshell. This means that in your object you can register a property with the same name 
as the prototype, in this case when called, the property returned is the one in the object. You can 
delete properties with the `delete` keyword. 
> To loop over the properties of an object use the `for(... in obj)`.
> Note, the standard way to get a prototype of an object use `Object.getPrototypeOf(...)` 
> Usually the pointer to the prototype is `__proto__` and the prototype of an object is `prototype`.

### Functions
As mentioned above, functions are objects as well, meaning that in their prototypal chain 
they contain the `Object` object. However, the prototypal chain of a function first references 
`Function.prototype` and then the `Object.prototype`. Each function, in addition to the 
declared parameters, receives two additional parameters: `this` and `arguments`. Where `this` refers 
to the context of the function, and `arguments` is represents the concept of `varargs` and `args` in 
other programming languages.

> No error will be thrown if more parameters or less parameters than expected are passed.
> The overflow will be caught by `arguments` and the non-defined arguments will be set to 
> `undefined`.

There are four different patters to invoke function: ***method invocation***, ***function invocation***,
***constructor invocation*** and ***apply invocation***. The difference between the invocation patters, is 
how the `this` is initialized.
> Note, even though it is obvious, `this` in functions is initialized at runtime. 
- ***Method Invocation***: `this` is bound to the calling object.
- ***Function Invocation***: `this` is bound to the global object.
- ***Constructor Invocation***: Invoked via the `new` keyword, `this` is bound to the function's prototype members.
- ***Apply Invocation***: Invoked via the `apply()` method. Takes two parameters, the first represents the `this`  and the second 
an array of parameters to be passed to the function.

```javascript
function sum(a,b){return a + b}
sum.apply(null, [1,2]) // 3
```
> ***TLDR***: Method, `this` binds to the calling object; Function, `this` binds to the global object; Constructor, `this` binds to the functions prototype; Apply, you decide explicitly what `this` binds to. 

> Tying it back to objects, ***all functions have a property called prototype***, when you call a function as a constructor 
> (`new Function()`) this property is set as the prototype of the newly constructed object (by 
> convention in the property named `__proto__`)

Think of it like this, all objects have a prototype. 
Objects might point to other objects prototypes and form a prototypal chain.
The pointer to the next prototype in the chain, by convention, is named `__proto__`
![Prototypal inheritance](https://developer.mozilla.org/en-US/docs/Learn/JavaScript/Objects/Object_prototypes/mydate-prototype-chain.svg)

### Clearing Confusion About Objects and Functions
Everything, except primitives are objects, even though event primitives have prototypes. In terms of terminology. All objects have a 
prototypal chain, where the chain ends where `null` is reached. There are several ways to get the prototype of an Object. However, the 
standard way is to use the static method `Object.getPrototypeOf()`. In browsers, objects by convention tend to have a property named 
`__proto__`, which does the same as `Object.getPrototypeOf()`: they both return the prototype of the object.

Now to functions, functions have a prototype of `Function` which then chains to `Object`. As functions have a prototype of `Function`, 
`Function` provides the `prototype` function. When using the constructor invocation of a function with the `new` keyword, everything in the 
`prototype` property of the function becomes the prototype for the object.

There are several ways to prototypes to an object. 
- `new`: The constructor invocation of a function add everything in the `prototype` of a as the nearest prototype.
- `Object.setPrototypeOf()`: Sets the prototype of an object.
- `Object.create()`: Creates an object with its prototype set to the argument.
- `Object.assign()`: Assigns an object to a property of an Object.
- `extends`: New syntax added, syntactic sugar to give the illsion of classical inheritance.

> Remember, the prototypal chain continues until a prototype points to `null`.

> The `prototype` prototype is only available in ***Constructor Functions*** and ***Classes***. Where all functions
> are Constructor Functions.

### Exceptions
Exceptions follow the same `try`, `catch`, form. When you `throw` an Exception, you can and should 
provide an object, this object can be accessed in the catch block as its parameter.
```javascript
try{
    throw{
        name : "Error name",
        message : "Error message",
        whatever : "hey"
    }
} catch(e){
    console.log(e) // {name : "Error name", message : "Error message", whatever : "hey"}
}
```
### Augmenting types
Similar to Kotlin, you can augment build-in types in JavaScript by editing its prototype. The difference 
between JavaScript and Kotlin is that JavaScript actually edits the structure of the object, while Kotlin 
extension function are syntactic sugar, where some Compiler Magic is performed. 
```javascript
Function.prototype.method = function(name, func){
    //Hide the prototype word with the method abstraction.
    this.prototype["name"] = func
    // To keep it functional, returning the objects allows for chaining.
    return this
}
```

