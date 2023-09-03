### Things I like about Python
Easy to prototype and test. I like that you can easily switch between Unit Test
and main program. You can simply run the unit test by running the unit test script
or the main by running the main. Remember to use `if __name__ if main`.

> Can run a module as script by using python -m <module> file.py. When you run a module,
> the module knows how to run your code, no need to instantiate. When used with `unittest`,
> no need for `if __name__ == "main"` nor object instantiation. The module does all that for 
> you.

With Unit Test I really like Pythons unittest module. Which as mentioned above can be 
easily integrated with no need of dependencies such as JUnit Jest and others.

> Languages that easily include Tests in their std are Go, Python, Rust and .NET.

### Basics
- Just declare variables, no curly braces, just indentation and colon.
- No parenthesis for `if`, `elif`, `else`, `for`, `while`.
- Functions are declared with the `def` keyword. Can contain default and named arguments.
- `try-catch-finally` is `try-except-else-finally` in Python. Where:
    - except represents catch, you can except specific errors.
    - else runs when no error is raised.
    - finally always runs.
- Something you might expect to be properties are actually standalone functions:
    - `len`: To get the length of a Sized object.
    - `max` `min`: To get the max or min of a collection.
- `for` iterates over a sequence (list, tuple, string, range) to create a sequence of 
numbers use `range`. `range(start, end, step)` generates a sequence from 0, if not specified, until
not including `end`.
- `pass` keyword is used mostly as TODO in other languages, such as Kotlin, 
or no Implemented Exception in C#.
- No short hand increment (`++`) in decrement (`--`) in Python, use `+=` and `-=`.
- `enumerate()` converts a sequence into a list of tuple, the first item is the index and the other the value.
```python
mynames = ["Mau", "Tete", "Val"]
for index, value in enumerate(mynames):
    print(index, value) # 0 Mau 1 Tete 2 Val
```
- `print` can receive varargs in Kotlin, params in C#. Varargs in Python are specified by *args which means 
multiple arguments. Keyword arguments or kwargs are accepted as **kwargs.

### Things To Remember
- Test for the `__name__ == main`. This means that the file is the main file of execution.
- When we import modules, all the code is run to generate functions, be careful with this.
```python
import pandas as pd         # pd.() To access pandas module.
from pandas import min, max # importing just a function called min and max from pandas module.
```

### Scoping
> Python variables are scoped to the innermost function, class, or module in which they're assigned.
> Control blocks like if and while blocks don't count, so a variable assigned inside an if is still 
> scoped to a function, class, or module.

Unlike other languages such as C#, Java, C, in Python you can achieve this:
```python
if True:
    y = 10
print(y) # Perfectly prints y. 
```
This is because variables are scoped to the innermost function class or module.

### Tuples Lists and Dictionaries
- Tuples are declared with `()`, they are immutable collection of values.
- Lists are declared with `[]`, they are mutable dynamic lists. They are implemented 
with vectors (dynamic arrays) in C. 
- Dictionaries are declared with `{}`, they are mutable and hold key value pairs. The 
key must be immutable. They are implemented with hash tables same as hash map.
```python
mytuple = (1,2,3)
mylist = [1,2,3]
mydict = {"one" : 1, "two" : 2, "three" : 3}

mytuple[0]    # 1
mylist[0]     # 1
mydict["one"] # 1
```

### Comprehensions
Comprehensions are a cool python feature. The structure is `[value for var in (sequence) if (condition)]`.
```python
names = ["Mauricio", "Ana", "Cristy", "Val"]
ages = [random.randint(12,21) for _ in range(len(names))]

mydict = {names[i]:ages[i] for i in range(len(names))} # {'Mauricio': 20, 'Ana': 12, 'Cristy': 20, 'Val': 20}
```

### List Slicing
List slicing allows you to get a portion of a list. The syntax is `[start:stop:step]`.
The default step is 1, if start or stop are omitted it meas to the end. You can omit
values to indicate the default behavior. Negative indices mean from the last nth position, 
where `-1` means last one, `-2`, second to last, and so on. 
```python
mylist = [1,2,3,4,5]
mylist[1:]       # [2,3,4,5]
mylist[:2]       # [1,2]
mylist[::-1]     # [5,4,3,2,1]
```

### Pass by Object Reference.
Python is pass by object reference, this means that a reference of the object is 
passed. However, it is not pass by reference as depending on type of  
the variable, the changes are reflected.
- If the object is mutable, Lists, Dictionaries, Objects, changes will persist.
- If the object is immutable, Strings, Numbers, Tuples, changes will NOT persist.
> ***TLDR*** Python passed by reference BUT depending on the type changes are reflected 
> on the reference. If the object is immutable, a local variable with the new value if 
> crated. If the object is mutable, the reference is altered.
```python
mylist = [1,2,3]
mynum = 1

def alterThing(thing):
    try:
        thing[0] = 100 
    except:
        thing = 100

alterThing(mylist) # [100, 2, 3]
alterThing(mynum)  # 1
```

### Object Oriented Programming
Variable declared in the class act as class variables. To declare properties on the instance
you have to declare them in the `self` parameter. The self parameter not necessarily has to 
be named `self` but it is better to follow the convention. `self` is passed implicitly to 
every method in an instance if not marked as `@classmethod` or `@staticmethod`. Class methods
can only access class properties (variables) passed implicitly to the first parameter of the function,
convention is to call this parameter `cls`, while a static method can access none, class and 
instance properties.

```python
class Person:
    instances = 0  # Static variable to keep track of instances
    
    def __init__(self, name):
        self.name = name
        Person.instances += 1  # Increment instances when an instance is created
                               # If you use self.instances += 1, you hide Person.instances 
    
    @classmethod
    def get_instances(cls):
        return Person.instances 

for(_ in range(3)):
    Person("Jose")

Person.get_instances() # 3
```

Even though both class and static methods can be called from the type, not only the instance,
the difference is that static methods cannot access neither the class members nor instance members.

Inheritance is done through the parenthesis:
```python
import unittest
class MyTests(unittest.TestCase): # Inherits TestCase
```

Method resolution order refers to how a function is resolved. Similar to Java you override a member
by hiding the super class implementation. To call the super class implementation use `super`. This is different
form C# where you can both hide with `new` and override virtual methods with `override`.

> Overriding in C# Hijacks the super class implementation of the method and always calls the overriden method
> from either the instance or base class.

##### Dunder
These methods provide a way to define how objects of a class behave in various contexts. 
They enable you to customize the behavior of built-in operations or operations that are context-specific,
such as arithmetic operations, string representation, and more.

An example, and the most frequent dunder is `__init__` which is called when an object is instantiated.

> To instantiate an object you do not need `new` keyword, just like Kotlin `Type(args)`.

Other dunder include 
- `__len__` called when `len` is used on the object. 
- `__str__`, equivalent to the `ToString` in other languages.

### unittest
To test your code its simple:
1. Import unittest.
2. Create a class that inherits from `unittest.TestCase`.
3. Create instance methods that use the `assertXXX` to test.
4. Run tests with either `python -m unittest <file-name>` or if main `python <file-name>`
```python
import unittest

class MyTests(unittest.TestCase):
    def test_one_plus_one(self):
        self.assertEquals(1 + 1, 2)

# python -m unittest <file-name>

if __name__ == "main":
    unittest.main()
```

