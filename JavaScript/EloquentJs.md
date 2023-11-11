### Var, const, and let:
`var` came before `const` and `let`. Pre 2015, only functions created  
new lexical scopes instead of blocks. Therefore, similarilty to python
a variable declared within an `if` becomes a global variable of the 
current scope. As a result, `const` and `let` are block bound variables,
where `const` represents a constant, and `let` a variable.

### Mutable and Immutable 
Strings, numbers and booleans are not objects and therefore they are immutable. This 
means, that unlike objects you cannot set properties to them, for example. 

### Hoisting
Hoisting is when a binding is lifted to the top of the ***thier*** scope, therefore it can be accessed
before it is declared. Examples of hoisted variables are `var` and `function`.

### Functions declarations vs function bindings.
Functions bindings in when you bind a value, in this case a function 
to a variable. When doing so you can reassing the variable to other things. 
In contrast, function declarations are ***hoisted***, meaning they are lifted 
to the upper most level on on execution. Therefore, for function declarations, you 
can use a function in the script before it has been declared.
```javascript
printHi() // Works
printBye()// Does not work

function printHi(){...}

const printBye = function(){...}
// Same as above: const printBye = () => {...}
```
An alternative way to write functions is using arrow functions. Arrow functions
are also function bindings and have no major advantage over functions bindings like 
the one shown above. Both are anonymous functions that are attatched to a value.

### Parameters
Javascript is permissive with its function parameters. Too many are passed? No problem.
Too few are passed? No problem. If too many parameters are passed, the excess are stored in the `arguments` object ***which 
is available inide all functions, and even to the global scope***. If too few are passed, 
the arguments passed are assigned in order, from left to right, the ones remaining are `undefined`.

> It has become common to, instead of using the `arguments` object, to be explicit and declare a ***spread, or varargs*** parameter like `...args`.

***You can also set parameters to default values*** by writing `(param = "Value")`.

> Note on parameters: obvious, but remember parameters are local bindings. Everytime you enter a function,
> new bindings are created for that function.

### Closures
Since Javascript creates and populates bindings when a function is created, 
you can do the following.
```javascript
function retFunc(n){
    return () => n
}
```
Weird, but it is not difficult to understand if you get the essentials. The code 
populates `n` and returns the newly created function.

### Properties
Almost every value in JavaScript is a property, except for `undefined` and `null`. You can 
access a property of an object in two ways, using the dot property accessor `obj.prop` or the indexed
`obj[prop]`. The difference between the indexer and the dot property accessor is that the 
indexer is evaluated, while the dot property corresponds to the literal name of the property.
Another way to put it, indexers are more dynamic.

### Objects 
A simple object is just a collection of properties, or key values. You declare an object literal 
within braces and add a comma separated list of properties, color, value. Remember, JavaScript is permissive,
so you can add properties to objects on the fly. In the same not, you can delete properties on the fly using the 
`delete` operator.
```javascript
let obj = {}
obj.thing = "Thing" // Adds thing.
delete obj.thing    // Deletes the thing property of object.
```

### Arrays methods.
- `push(el), pop()`: Treats array as a stack.
- `unshift(el), shift()`: Treats array as queue.
- `indexOf(el), lastIndexOf(el)`: Returns index of element or -1.
- `slice(start, end)`: Returns a section of the array.
- `concat(arr)`: Glues arrays together.

### String methods:
Even though strings are immutable and hence not objects, they have built in properties. They contain
properties and methods found in arrays such as `indexOf(str)`, `.length`, `slice(s, e)`.
- `trim()`: Trims white space.
- `padStart(num, char)`: Adds padding to the start of a string.
- `split(delimeter)`: Splits the string into array based on delimeter.
- `join("delimeter")`: Joins an array to a string.

### Rest and Spread
`...` not only spreads the properties or elements of an array, it also can be used as a parameter. When 
used as a parameter it means that all extra terms passed are collected into it, for example:
```javascript
function collect(...numbers){ // Collecting
    for(let num of numbers) console.log(num)
} 

let numbers = [1,2,3,4]
console.log(max(...numbers)) // Spreading.
```

### Math, your best friend namespace.
You'll likely never use the `Math` object as a value, rather it is a namespace containing
all Math related things. It contains constants like `PI`, functions like `cos`, `sin`, `arctan`,
`random`, and more.

### Destructuring
I did not know this but you can destructure both arrays and object. Destructuring is the process
of assigning names of items in an array or object container in order so they can be used directly
in the function. To do so, if the parameter is an array `func([p1, p2])`, if the parameter is an 
object `func({p1, p2})`. This creates bindings for the first and second values of the container named
`p1` and `p2` respectively.

### Json
Json is usefull for serializing data, it packages data in a standarized format that can 
be read by other computers. Javascript provides the `JSON` object, like `Math` it is more like
a namespace. The `JSON` object provides to main methods.
- `stringify`: Converts a JavaScript object into a JSON string.
- `parse`: Converts a JSON stirng into a JavaScript object.

