### Objects
Objects have a unique identity and can have several names. Meaning several variables can refer
to the same object. This is known as alliasing in other programming languages. This allows the
passing of objects to be cheap as just the identity of the object is passed around: think pointers.
This is mostly important for mutable types such as `list`, `dict`, `set`, etc; and can be ignored
for immutable types such as `numbers`, `tuples`, `strings`.

> Assignments do not copy data — they just bind names to objects. The same is true for deletions. The statement `del x` removes the binding `x` from the namespace referenced by the local scope.

### Namespaces and Scopes
Namespaces are just a mapping between objects and names. Most namespaces are represented as
dictionaries in python. For example you can access the `global` namespace with `globals()` which
returns a dict of the global namespace.

Different namespaces are created at different moments. 
- `built-in`: Created at interpeter start. Never deleted.
- `global`: Created when **module** definition is read in. Normally lasts until interpret quit.
- `local`: Created when a function is called, and forgotten after a function is exited.

A scope is a textual region of code from which a namespace is directly accesible.
**Although scopes are determined statically, they are used dynamically**. Meaning,
which namespaces are accessible are determined textually, but which name to use is 
determined dynamically by searching within the directly accessible namespaces.

Any time during the execution of a python program there are 3 or 4 nested scopes:
- `local`: The scope that contains the local names.
- `enclosing`: The scopes of **any and all** enclosing functions.
- `global`: Next to last scope, **contains the current module's global names.**
- `built-in`: The outermost scope, searched last. It is the namespace containing `built-in` names.

> Note, blocks do not create scopes in python. Only `modules`, `functions`, and `classes` do.

Python has a resolution order in which it finds names when referenced in code: local, enclosing, global, built-in, or **LEGB**. 
**However, such names are read only. Trying to set a name contained in a directly accessible scope, creates a new name in the local namespace.**

To set a name contained in a directly accessible scope use `global` or `nonlinear` at the top level of the local scope. 
- `global x`: Specifies that any reference to `x` in the local scope refers to `x` in the global scope.
- `nonlocal x`: Specifies that any reference to `x` in the local scope refers to `x` in any but the `global` and `built-in` scopes.
```python
x = 'out'

def a():
    x = 'a'
    def b():
        nonlocal x
        x = 'b'
        def c():
            nonlocal x
            x = 'c'
            def d():
                global x
                x = 'in-d'
            d()
        c()
    b()
    print(x)

a()             # c
print(x)        # in-d
```

> Again, scopes are determined textually, where the global scope of a function, will always be the namespace of its module. No matter where you import the function to.

### Class Definition
When a class definition is entered a new namespace is created for all the names within the class. Once the class is 
executed a class object is created. The class object acts as a namespace for all the names in the class definition. The name of the class object is the same as the header of the class definition. 
For example if `class Car`, the name of the class object is `Car`.

### Class object
Class objects perform two types of operations:

**Attribute Access:** You can use the class object as a namespace to access attributes defined within the class, such as class variables or functions. 
However, methods are only accessible through instances, as a function object within a class is transformed into a method when it
is accessed via an instance.

**Instantiation:** A class can be called using function notation (e.g., MyClass()) to create an instance of the class.
This process produces a new object of that class.

> Note: By default, instantiating a class produces a new instance, which is an object of the class. Initially,
> this object is empty unless the class defines an `__init__` method, which is a special method intended to
> initialize the instance.

When a class defines an `__init__` method, this method is automatically called during instantiation. Any arguments
passed during instantiation are forwarded to the `__init__` method, allowing you to initialize the instance with
specific attributes or set it to a particular initial state.Class objects perform two types of operations: 
attribute access and instantiation.

### Instance object
Instance objects only understand attribute references. There are two types of attribute references:
- **data attributes**: Any attribute attached specifically to the instance, `inst.x`, or non-function object in method resolution order chain starting from the class from which the instance was created.
- **methods**: Any function-object accessed through the instance that is defined in the class, and not shadowed by the instance.

### Method object
A method object is a combination of a function object and an instance. When a method is called, the instance is automatically
passed as the first implicit argument to the function object, typically referred to as self. Only function objects
defined within the class or its base classes—not those directly attached to the instance—become methods when accessed
through an instance.

### Random Remarks
- If the same attribute ocurrs both is the class and instance, then attribute lookup prioritizes the instance.
```python
class Dog:
    bark = "woof"

toci = Dog()

print(Dog.bar)   # woof
print(toci.bark) # woof

toci.bark = "waff"

print(Dog.bar)   # woof
print(toci.bark) # waff
```
- There is no short hand to reference attributes of an instance, within a method: You need to use the instance `self.attr`.
    In other words there is no implicit `this`.
- Data attributes may be reference both by clients and methods. This means Python does not enforce data hiding.
- Any function object that is a class attribute defines a method for instances of that class. The function object need 
not be textually enclosed in the class definition. This means that a name can be bound to a function object within the class
definition.
```python
def fun(self):
    print(type(self))

class C:
    f = fun

c = C()

c.f()   #<class '__main__.C'>`
```
- Methods may reference global names in the same way as ordinary functions. The global scope associated with a 
method is the module containing its definition. **A class is never used as a global scope**.
- Each value is an object, and therefore has a class (also called its type). It is stored as `object.__class__`.

### Inheritance
The syntax for a derived class looks like `class B(A):`, if the namespace of `A` is accessible where `B` is defined.
- There is nothing special about the instantiation of derived classes: `Derived()`.
- Method references are resolved recursively. The derived class is searched, followed by the base class. 
    This applies for all methods called form the instance. Therefore, even though a method is called form a base class,
    the base class unknowingly might call a method from the derived class if the derived class has overridden the method.
- There is a simple way to call the base class method directly: just call `BaseClass.methodname(self, args)`.

Python has two built-in functions that work with inheritance:
- Use `isinstance(obj, classinfo)` to check is `obj` is an instance of `classinfo`.
- Use `issubclass(class, classinfo)` to check if class is a subclass of `classinfo`.
> Use `isinstance` for instances of a class, `c = C()`, and `issubclass` for class objects.

### Multiple inheritance
Multiple inheritance solves attributes in a right to left depth first search, not visiting the same class twice: Python remembers which classes have been searched in the MRO.
For example:
```python
class D:
    def m(self):
        print("In d")
        
class B(D):
    pass
    
class C:
    def m(self):
        print("In c")
        
class A(B, C):
    pass
    
a = A()

a.m()               # In d

print(A.__mro__)    # (__main__.A, __main__.B, __main__.D, __main__.C, object)
```
In a tree structure the following would look as follows:
```
         A
        / \
       B   C
      /     
     D
```
If MRO was performed as a right to left breath first search, then `C.m` would have been called.
Since the MRO is a right to left depth first search, `D.c` is called.

### Private variables
There is no concept of a private variable in python since all attributes of a class and instance are visible to the 
client. However, there is a concept of **non-public** variables. Non-public variables are variables the client should 
avoid as they are not part of the API. They are identified by beginning with an underscore: `_attr`. 

However, **private variables are useful since they avoid name clashes with sub and derived classes.** Python provides
**name mangling** to greatly reduce the risk of name collisions in the inheritance tree. 

To use name mangling the attribute must start with double underscores and end with at most one underscore: `__attr[_]`. 
**Name mangling** reduces name collisions by textually replacing `__attr` with `_classname__attr`, where `classname` is 
the name where `__attr` is defined. Of course, someone could still shadow the attribute, but it would be intentional.
```python
import re

class C:
    __attr = 20

c = C()

attrs = str(dir(c))

x = re.search(r"\w+__attr", attrs)

x.group(0)      # _C__attr
```

### Odds and Ends
When you want to have a class that just stores data, you can use `dataclasses` for this purpose:
```python
from dataclasses import dataclass

@dataclass
class Employee:
    name: str
    dept: str
    salary: int

john = Employee("John", "Compute Lab", 1000)
```
The decorator `@dataclass` provides the `__init__` and `__repr__` special methods.
- `__init__`: Accepts ans sets initial values for all data attributes of the data class.
- `__repr__`: Prints the representation of the data class such that it can be copy pasted to instantiate a identical instance.
    For example: `print(person) # Person(name="Mauricio", age=21)`.

Look into the **Data Model and Protocols** to find all dunder methods. Instance method objects also have dunder methods defined:
- `m.__self__`: Refers to the instance object of the method.
- `m.__func__`: Refers to the function object corresponding to the method.

### Iterators and iterator protocol
You've notices how container objects can be looped over using a `for` loop. The for loop uses the **iterator protocol**,
which you can add to any class. The iterator protocol works as follows. 
- `__iter__()`: Method called by `for`. Method must return an iterator object.
- **iterator object**: An iterator object is any object that defines `__next__()`.
- `__next__()`: Is used to access one element at a time. When the end of iteration has been reach, `__next__()` raises the `StopIteration` exception.
- `StopIteration`: Exceptions that tells for loop to terminate.

You can call `__next__()` of any object by using the `next()` built-in function on the object.
```python
class Box:
    def __init__(self, *args):
        self.index = -1 if args else None
        self.things = args

    def __iter__(self):
        return self

    def __next__(self):
        if None or self.index == len(self.things) - 1:
            self.index = -1 if self.things else None #  To allow re-iteration.
            raise StopIteration
        self.index = self.index + 1
        return self.things[self.index]

b = Box("sock", "cheese", "rat", "rope", "watch", "pencil")

for item in b:
    print(item) # ... prints all the items.
```

### Generator
Generators are a simple and powerful tool for creating iterators. A generator function is a function that uses the 
yield statement to produce a sequence of values.
```python
class Box:
    def __init__(self, *args):
        self.index = -1 if args else None
        self.things = args

    def __iter__(self):
        for i in self.things:
            yield i  # This makes __iter__ a generator function, returning a generator object when called.
```

Once a generator function is called, it returns a generator object. The generator object implements the iterator 
protocol, which includes:
- `__iter__`: Must return the object itself (since the generator object is its own iterator).
- `__next__`: Must return the next value in the sequence or raise a StopIteration exception when the sequence is exhausted.

**Key Points:**

- Generator functions return generator objects.
- Generator objects implement the iterator protocol.
- You can pass any object that implements the iterator protocol to a for loop, including generator objects.

### Generator Expressions
Generators can also be created similar to list, set, and dict comprehensions. The only difference is that instead
of square brackets `[]`, for lists, or squiggly brackets `{}`, for sets and dicts, you use parenthesis `()`. Note 
generators expressions are designed for situations in which they are going to be consumed right away. They serve as 
a memory friendly alternative to list comprehensions.
```python
sum(i*i for i in range(10)) # 285
```
