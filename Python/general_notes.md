### Beware of parenthesis
Unlike other languages, parenthesis `()` in python are not only used for grouping and calling functions, they 
are also used to create tuples. 
- A parenthesis with a single expression within are considered a grouping: `isinstance((1+2), int)`.
- A parenthesis with a single expression and a comma is considered a tuple: `isinstance((1+2,), tuple)`

To illustrate the difference a comma makes consider the following example:
```python
assert(x > 0)                                          # Parenthesis groups expression, works as expected.
assert(x > 0, f"x must be greater than 0, got {x=}")   # Parenthesis creates tuple, assert is always true.
```

Even though it is unlikely, be careful with case like:
```python
for i in (1,10):     # Forgot to use range(1,10)
    ...
while(x > 0, y > 0): # Non-empty tuple always evaluates to True.
    ...
```
as they do not raise an error.

### `==`, `is`, `isinstance`
`is` **always** performs **identity** comparison. It does not check whether `obj is of type A`, to do this use
`isinstance(obj, typeclass)`. As the name suggests `isinstance` checks whether an object is an instance of a 
class. In other words `isinstance` checks for **is-a** relationship.

For all built-in types expect `==` to perform value comparison, not identity.
This includes containers, where a element wise comparison is performed.
```python
[1,2,3] == [1,2,3] # True
[1,2,3] is [1,2,3] # False
```

For instances of user defined classes, consult the specific documentation
for `__eq__`. When `__eq__` is not defined, the comparison defaults to
`is` which cannot be overridden.

User defined class objects, not instances, will always evaluate to `True`
when performing either `==` or `is`. This is because user **defined classes
become singleton objects once read in**.
```python
class C:
    pass

C == C # True
C is C # True
```

None is also a singleton object. This is why you can check whether an object is `None`
by either `obj is None` or `obj == None`. However, it is preferred to check with `is` 
as it is faster and more explicit about the intent.

### Generators to containers
You can convert a generator into a container by casting the generator to a container.
```python
class Box:
    def __init__(self, *args):
        self.items = args

    def __iter__(self):
        for item in self.items:
            yield item

args = ["sock", "bottle", "book", "pencil", "clock"]

b = Box(*args)

assert args == list(b)
```
