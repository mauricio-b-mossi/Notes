### Basics
Here I will cover the basics of JS for those who are new, or coming back to the language.

#### Variables
Variables can be declared in four ways: Automatically, `var`, `let`, `const`.
- ***Automatically*** : It is not recommended to do so.
- `var` : Legacy way of doing things.
- `let` : Variables, can change.
- `var` : Constants, cannot change.
> Prefer const over let.

#### Loops and Control Flow
Can use normal, `if`, `else if`, `else`, `for`, `while`, `do while`, and `switch`.
The above are pretty self explanatory, however, I'm going to cover those, who have "niche", 
implementations.
- `for` : Can use C like `for(init; condition; afterThought)`, to get the properties of 
an object use `for(prop in obj)`, to emulate for Each with iterables use `for(value of iterable)`.
- `switch` : Use C switch, `switch(expression){case expression:}`, remember to break, if not it will cascade.
> Property iteration with `for(... in ...)`, for Each iteration with `for(... of ...)`.

### Objects
Objects are just associative arrays, they can contain properties and methods. The most basic way to initialize an object
in JavaScript is with an object literal `{}`.
```JavaScript
const obj = {
    name : "Jose",
    age : 21,
    2 : "two",
    hello : function(){
        console.log("Hello")
    },
    world(){
        console.log("World")
    }
}
```
You can access the properties of an object via destucturing, also known as dot notation, or through bracket notation 
as with arrays.
```JavaScript
obj.name // "Jose"
obj[2] // "two"
```
Objects in JavaScript are dynamic, meaning I can add extra properties and methods to them. You can add properties and methods
using `bracket notation` or `dot notation`.
```JavaScript
obj.sayHi = function(){
    console.log("Hi")
}
obj["sayBye"] = function(){
    console.log("Bye")
}
```
To create objects on mass, it is inefficient to use object literals for everything, instead you can create factory function or use constructors.
- Factory functions simply create an object literal and return it. 
- Constructor functions are functions called with the `new` keyword. When we called a constructor, the body of the function 
is returned and `this` is binded to the body of the function.
```javascript
function Person(name){
    this.name = name
    this.sayHi = function(){
        console.log("Hi")
    }
}

function personFactory(name){
    return {
        name : name,
        sayHi(){
            console.log("Hi")
        }
    }
}
```
Note:
- For Constructor functions everything bound to this is returned as an object.
- For Object Literals, you cannot use this.property for keys.
```javascript
const obj {
    age = 21
    //this.name = "Hello" -> Invalid
    name = this.age // Valid
}

function Person{
    //this.sayHi(){...} -> Invalid
    this.sayHi = function(){...} // Valid
}
```

### Falsy
The following expression will always evaluate to false. Others will always be true: 
- `null`
- `undefined`
- `false`
- `NaN`
- `0`
- `-`0
- `On`
- `""`
Things you should now:
- `NaN` does not equal NaN, to test for `NaN` use `isNaN()`
- An undefined property of an object will return `undefined`.

### Playing with OR and AND
Logical Or and And are represented as `||` and `&&` respectively. These can have interesting behaviors. For example:
```javascript
const obj = {
    name : "Jose"
}

/*
 * As obj.age is undefined, it evaluates to false so 21 as it is true is returned.
 * This works kind of like the ?: in Kotlin.
*/
const age = obj.age || 21 // 21

// In React this is used to return a Component. Logical and if true, returns the thing on the right.
{age === 21 && <Component/>}
```
- `&&`: If left side true, returns right. Else returns false.
- `||`: If left side false, returns right. Else returns left.
