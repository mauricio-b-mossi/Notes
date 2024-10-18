### Javascript and Prototypes
Javascript prototypal inheritance can be confusing for someone comming from 
common object oriented languages such as Java, C#, etc. But in the end it is quite 
simple. To give a brief overview prototypal inheritance is just a chain of prototypes 
where all the objects you create have atleast the `Object` prototype. So prototypes are 
just objects, and they for a chain which terminates with the `null` prototype. Prototypes allow 
inheritance since the method and property resolution is done through a traversal of the 
prototypal chain.

In Javascript there are multiple ways to do the same thing, and this is not the exception
for object instantiation. You can instantiate objects through several ways, to name a few:
object literals `{}`, `Object.create()`, `new <constructor>`. Every object has a `__proto__`
property. The `__proto__` is a pointer to the prototype of the object.

There is always confusion between the difference of the `prototype` and `__proto__` properties:
- `prototype` is a property of constructor function, and by extension classes which are syntactic sugar
for constuctor functions. In other words, the `prototype` property is only available on factory functions.
- `__proto__` is a property of all objects that points to the objects prototype.

##### Constructor functions, Object.create(), and Object.setPrototypeOf()
Constructor functions and `Object.create()`, and `Object.setPrototypeOf()` are the "primitive"
ways to create prototypal chain. 

The Constructor function is a function that when called `new <Function>()`, returns the inner "scope"
of the funciton as an object, and hence creates an object. The object return becomes attatched to the binding.
The properties attatched to the Constructor functions' prototype via `Constructor.prototype` become the prototypes
of the object.

> Why use prototypes? Prototyes allow code reusability and refactoring. The `__proto__` points to a single object.
> Hence, for example, if you want to change a behavior, you just change it on the prototype, even after 
> the object has been created. This is because the prototypal chain is solved dynamically.

```javascript
function Person(name, age){
    this.name = name;
    this.age = age;
}

Person.prototype.greet = function(){
    console.log(`Hi there. I am ${this.name} and I am ${this.age} years old.`);
}

const me = new Person("Mauricio", 21);

me.greet(); // -> Hi there. I am Mauricio and I am 21 years old.

Person.prototype.greet = function(){
    console.log("Changed the prototype")
}

me.greet(); // -> Changed the prototype.
```

With `Object.create()` you just pass the object you want as a prototype to the function.

With `Object.setPrototypeOf()` you just pass your object and the prototype you want to assign to 
that object.

##### This
Everything assigned to `this` is a property of the object, not of the prototype.
