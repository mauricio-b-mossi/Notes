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

> Slicing retruns a sliced copy of the list. Use it for copying.

### Control Flow
#### If
*If, elif, else*: Elif is short for else if to avoid unnecessary indentation.

#### For
- *for*: For statements iterate over items of any sequence.
- *for else*: For statements can have an else cause. It executes when a loop is exited gracefully: When the sequence is iterated.
- *break*: Exits innermost loop. Does not constitute a graceful exit.
- *continue*: Continues to the next iteration in the loop.
- *pass*: Does nothing. Used as a placeholder for doing nothing. 

> Remember, `for` iterates over *sequences*.

#### Match
Unlike `switch`, `match` does pattern matching. Only the first pattern that matches is executed: no need for `break.`
- `match val`: What will be matched on.
- `case val`: Matching case.
- `case _`: Catch all.

##### Cool features of pattern matching*
- `case int()`: Matches if `match arg` is of type int.
- `case (0, y)`: You can unpack and assign variables. To use in the `case` block.
- `case Point(x=0, y=y)`: Same as above. You can do this not only with unpackables but also classes!
- `case val if val > 0`: Guards, match the pattern if the condition is true. Note variable assignment / capture occurs prior to guard evaluation.

##### Key Takeaways pattern matching
- Standalone names in a pattern (e.g., var) are the variables that will be assigned values.
- Dotted names (like foo.bar), attribute names (like x=1), and class names (like Point) are
part of the pattern that helps determine the match but are not assigned any new values.

##### Unpacking
- `(x, y, *rest)`: Unpacking sequences can use *ags. Note, matches if sequence has at least 3 values.
- `{"car": c, "model": m}`: Captures the values of `["car"]` and `["model"]`. Unlike sequence, `*_` is not necessary.

### Functions
- To add documentation to a function, it's first statement must be a string.
- Python calls by *object reference*, meaning if passes the reference of the object. 
- When called a symbol table is created per function.

#### Default Values and Keyword Arguments (kwargs)
Functions can have default values to limit the amount of arguments needed for a function. Default values
are specified as follows:
```python
def print(*values, sep=" ", end="/n"):
    ...
print("hello") # hello
print("hello", "max", sep=", ", end="!\n") # hello, max!
```
Where `*values` is a required argument, while `sep` and `end` have default values. You can specify
the values for `sep` and `end` using keyword arguments like in the second example of print.

##### Important warning
Default values for functions are evaluated **only once** at the point of definition. This means that:
```python
def acc(n, L=[]): # Creates a binding L = [] once. L.append(n) appends to the existing L.
    L.append(n)

acc(1) # [1]
acc(2) # [1, 2]
acc(3) # [1, 2, 3]
```

All kwargs must follow positional arguments, and no argument can receive a value twice. The following would throw:
```python
print(sep="1", 1)       # SyntaxError: positional argument follows keyword argument
print(sep="1", sep="1") # SyntaxError: positional argument follows keyword argument 
```

Functions might have `**kwargs` and `*args` at the end of the list of parameters.
- `**kwargs`: Captures extra keyword arguments. 
- `*args`: Captures extra positional arguments.

For readability and performance the parameters of a function are must be defined in the following order:
```python
def f(pos1, pos2, /, pos_or_kwd, *, kwd1, kwd2):
      -----------    ----------     ----------
        |             |                  |
        |        Positional or keyword   |
        |                                - Keyword only
         -- Positional only
```
This is because the programmer can read from left to right, in the order of priority, which items must be passed.

> Note, `/` and `*` are literal symbols, which describe how arguments must be passed. If not present, arguments may be passed either by position or keyword.
- `/`:  Parameters before `/` are *positional only*.
- `*`: Parameters after `*` are *keyword only*.
- `in between`: Parameters after `/` or, and, before `*` are both positional and keyword arguments.

##### Unpacking
The reverse of `*args` and `**kwargs` is called unpacking. Both `*args` and `**kwargs` are defined as function
parameters and collect loose arguments into a `tuple` or a `dict`. Unpacking is when you want to pass
the values of either a `tuple` or `dict` to a function. 
- `*<tuple>`: Unpacks a `tuple`, passes its entries as positional arguments.
- `**<dict>`: Unpacks a `dict`, passes its entries as keyword arguments.

##### Lambdas
Lambdas are short, single expression functions, which can be used wherever a function object would normally be used:
```python
lambda x : x + 10
lambda pair : pair[1]
```

##### Annotations and Doctoring
Annotation are metadata for the function stored on `f.__annotations__`.
- Parameter annotations are defined as `f(a : int, b : int = 2):`
- Return annotations are defined as `f() -> int:`

Doc string are stored in `f.__doc__` and have the following formatting conventions.
- First line should include a short description of a function.
- If more lines are needed, the second line must be blank.
- Indentation is determined by the first non-blank line after the first line. This should be the min indentation.
