> Note on scoping, variables are **function-level scoped**, meaning that
> iteration variables such as, say, `x` become available in the current
> function or module.

```python
for x in range(10):
    pass
    
print(x) # 9!

a = [list(map(lambda y : y ** 2, range(10)))]
print(y) # NameError: name 'y' is not defined.

a = [z for z in range(10)]
print(z) # NameError: name 'z' is not defined.
```

## Terminology
Sequence and collection are different things. A collection is a grouping of items, while
a sequence is a grouping of items in which order matters.
- lists, strings, and tuples are sequences.
- sets, and dictionaries are containers.

### Strings
Strings are immutable sequence of characters, therefore you cannot do:
```python
s = "rice" 
s[0] = "m" # TypeError: 'str' object does not support item assignment.
```
There is no character data type, characters are just strings of length `1`.

> Since Strings are sequence types, you can slice `[::]` and get its length `len`.

*Things to look up*
- Raw strings `r''`: Does not escape.
- Triple quotes `""""""`: Multi-line string.


### Lists
Lists are mutable sequences of several types. Since they are mutable and a sequence,
you can mutate, index, and slice elements.

If used in the `rhs`, slicing returns a shallow-copy slice of the list.
If used in the `lhs`, you can modify or extend a slice of the list by another list.

- `append(x)`: Adds to the end of the list, same as `a[len(a):] = [x]`
- `extend(iterable)`: Extends list, same as a[len(a):] = [x, y, z]
- `insert(x, i)`: Inserts element `x` before `a[i]`.
- `remove(x)`: Removes `x` from list. Raises `ValueError`.
- `pop([i])`: Removes the last element of the list if `i` not specified, else removes `i`th index. Raises `IndexError`.
- `clear()`: Clears the list, equivalent to `del a[:]`.
- `count(x)`: Counts occurances of `x` in list.
- `index(x[, start[, end]])`: Finds the index of `x` within the range if provided. Raises `IndexError`.
- `sort(*, key=None, reverse=False):` Sorts list in place.
- `copy()`: Returns a shallow copy of the list. Equivalent to `a[:]`
- `reverse()`: Reverses list in place.

##### Note assigning to an index and to a slice if completely different.
Assignment to an index is not flattened, while assignment to a slice is flattened. Therefore:
```python
a = b = c = [1,2,3]

a[0] = []  # [[], 2, 3]
b[:1] = [] # [2, 3]
del c[0]   # [2, 3]

len(a) = 3
len(b) = 2
len(c) = 2
```
You can use `del` to delete variables, items, and slices of a list. Just as what we did with slices
above.

> By convention, methods that modify the list have no return value, they return `None`.

##### Stacks with Lists
A list can function as a stack data strcuture if the `append(x)` and `pop()` methods are used.

##### Queue
Even though a list can function as a queue, it is suboptimal. Deleting from the start of a list, `pop(0)` can be done
but it is a costly operation. Use `collections.deque` which was design for fast appends and pops from both ends.
```python
from collections import deque

q = deque([1,2,3])
q.append(4) # [1,2,3,4]
q.popleft() # [2,3,4]
```

### List comprehensions
List comprehensions provide a consise way of generating sequences. It is achived via a combinantion of `for` and `if`,
where each `for` and `if` is nested inside the `for` and `if` to the left.
```python
a = [y for x in range(10) if x % 2 == 0 for y in range(x)]

b = []
for x in range(10):
    if(x % 2 == 0):
        for y in range(x):
            b.append(y)

a == b # True
```

##### Nested Comprehensions
You can also nest comprehensions, the example from the Python Docs illustrates this perfectly:
```python
matrix = [
    [1, 2, 3, 4],
    [5, 6, 7, 8],
    [9, 10, 11, 12],
]

at = [[x[i] for x in matrix] for i in range(len(matrix))]

bt = []
for i in range(len(matrix)):
    h = []
    for x in matrix:
        h.append(x[i])
    bt.append(h)

at == bt # True
```

##### Tuples
Tuples are immutable lists of coma-separated values. Even though a tuple is immutable, it may contain mutable objects
such as lists. One misconception is that a tuple needs parenthesis `(1,2,3)`, however `1,2,3` works as well. Parantheses
are included so tuples are interpreted correctly.
- `()`: Constructs an empty tuple.
- `x,`: Constructs a 1 value tuple.

##### Sequence unpacking
Sequence unpacking works for any sequence on the right-hand side. There must be as many variables on the left side,
as on the right side.
```python
a, b = b, a
```
The example above, evaluates the `rhs` and creates a tuple containing `(b, a)`: tuple packing. Then those values are 
unpacked into the variables `a` and `b`, effectively changing the variables *without needing an auxiliary variable.

> Note that to check for membership in a sequence, use the in operator. You might have noticed that lists do not have a contains method. This is because in is a general-purpose operator for checking membership in all sequence types in Python.

### Sets
Sets are unordered collections of unique values. They are mainly used to remove duplicates and check for membership.
To construct a set you can use `set([iterable])` or `{}`. However, to construct an empty set you **must** use `set()`
since `{}` constructs an empty dictionary.
- `in`: Checks if the given value is in the `set`.
```python
s = set([1,2,3]) # Passing a list
1 in s
```


### Dictionaries
Dictionaries are associative arrays. The keys must be immutable types, either strings, numbers or tuples. To create
a dictionary use `{}` or `dict()`. If a key already contained in the `dict` is set to a value, the previews value is
replaced.
- `in`: Checks if the given key is in the `dict`.
- `list(d)`: Returns a list of the keys in the `dict`.
- `del d["abc"]`: Deletes the key-value pair `d["abc"]`.

```python
# All dict constructor functions.
dict(**kwargs)
dict(mapping, **kwargs)
dict(iterable, **kwargs)
```

> If `{}` has a comma separated list of values it is a `set`. If it has a comma separated list of key-value pairs, it is a `dict`.
They are mainly used to store and retrieve a value given a key.

```python
d = {"mau" : 21, "vale" : 22, "ana" : 18}
"mau" in d # True

d["cristy"] = 15 # {"mau" : 21, "vale" : 22, "ana" : 18, "cristy" : 15}
d == dict(mau = 21, vale = 22, ana = 18, cristy = 15) # True
d == dict([("mau", 21), ("vale", 22), ("ana", 18), ("cristy", 15)])
```

### Looping Techniques
- To iterate over tuples of keys and values of a **dict** use `d.items()`.
```python
for k, v in d.items():
    print(k, v)
```

- To iterate over tuples of index and values of a **sequence** use `enumerate(sequence)`.
```python
for i, v in enumerate([0, 1, 4, 9]):
    print('({0}, {1})'.format(i, v)) # (0,0) (1, 1) (2, 4) (3, 9)
```

- To iterate over multiple sequences at the same time use `zip()`. `zip()` pairs entries in each list based on their index.
```python
for shirt, pant, shoes in zip(["Polo", "Button-up", "Tank"], ["Khaki", "Jean", "Jorts"], ["Samba", "Superstar", "Stan Smith"]):
    print(shirt, pant, shoes) # Polo Khaki Samba...
```

- To loop through a sequence in reverse, first specify the sequence in the forward direction, then call `reversed()`.
```python
for i in reversed(range(1, 11)):
    print(i) # 10, 9, 8, 7...
```

- To loop through a sequence in sorted order use `sorted()`.
```python
for i in sorted([3, 6, 2, 1, 8, 9, 4]):
    print(i) # 1, 2, 3...
```
> Note, functions finishing in `ed` do not mutate the original sequence: `sorted`, `reversed`.

### More on Conditions
Conditions inside `while` and `if` can contain more than just the usual comparison operators (`<`, `>`, `==`, `!=`, `<=`, `>=`).
- `in` and `not in`: Test for membership of one value in a container.
- `in` and `not in`: Test for the identity of two objects.

Comparison operators have lower precedence when compared to numerical operators, such that `1 + 1 == 2` would evaluate
`(1 + 1) == 2`.

Boolean operators have even lower precedence than comparison operators, with `not` having the highest and `or` the lowest,
such that if `A and not B or C` is equal to `(A and (not B)) or C`.

Boolean operators are short-circuiting, meaning values are evaluated, until the result is determined. If the result is
determined before evaluating all values, the remaining values will not be evaluated. When used in a general expression,
boolean operators return the last value evaluated.
```python
a = False and True          # a = False
b = False or True or False  # b = True
```

### Sequence comparison
Sequences with the same type can be compared in lexicographical order: first the first two items are compared and so on. 
