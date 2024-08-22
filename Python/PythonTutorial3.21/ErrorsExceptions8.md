### Errors and Exceptions.
There are two types of errors in Python: Syntax Errors and Exceptions.
- Syntax errors are fatal. They print a message showing the offending line and place. These are easy to fix.
- Exceptions are not always fatal and can be handled.
```
# SyntaxError example.
>>> while True print('Hello world')
  File "<stdin>", line 1
    while True print('Hello world')
               ^^^^^
SyntaxError: invalid syntax

# Exception example.
>>> 10 * (1/0)
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
ZeroDivisionError: division by zero
```
All built in exceptions print the same message structure: Stack trace, offending line and file, exception type and message.

Built-in exceptions have an `args` attribute that stores the arguments. For convinience built-in exceptions define `__str___()`
to print all arguments without specifically accessing `args`.

### Handling Exceptions `try-except`
Exceptions are handled with `try` blocks. Within the `try` block you place statements that might raise an Exception. 
- If the `try` block executes without an error, the `except` clauses are skipped.
- If the `try` block encounters an error, it skips the rest of the `try` block and is handled **if** one of the `except`
clauses handles the type of error thrown. 
- If handled, the execution continues after the `try/except` block.
- If not handled, the exception is propagated to outer `try` blocks, if any. If there is no handler execution stops with an error message.
```python
while True:
    try:
        x = int(input("Please enter a number: "))
        break
    except ValueError:
        print("Oops!  That was no valid number.  Try again...")
```

##### except
- There can be one or more `except` clauses after a `try` block.
- An `except` clause can catch, one or multiple exception types, if placed in a tuple.
- A class in an `except` clause matches instances of itself or its derived classes.
- A `except` clause only handles exceptions from coming from its same level `try` block.
- The `except` clause may specify a variable after the exception type. The variable stores the specific instance of the exception.

Exception handlers do not handle only exceptions that occur immediately in the try clause, but also those that occur 
inside functions that are called (even indirectly) in the try clause.

### Exception Hierarchy
- `BaseException` is the base class for all exceptions. Therefore, catches all exceptions.
- `Exception` is the base class for all non-fatal exceptions. Therefore, catches all non-fatal exceptions.

Exceptions that are not subclasses (derived from) Exception are typically not handled, these include `SystemExit` and `KeyboardInterrupt`.

### Else
A `try-except` block can also have an `else` block following all except blocks.
**The `else` block only runs when the `try` block does not raise an exception.**
```python
for arg in sys.argv[1:]:
    try:
        f = open(arg, 'r')
    except OSError:
        print('cannot open', arg)
    else:
        print(arg, 'has', len(f.readlines()), 'lines')
        f.close()```

### Finally
A `try-except-else` block can also have a `finally` block at the end. The `finally` block is **always** ran before 
exiting the current `try-except-else` block. For example:
- If any of the `try-except-else` blocks returns or breaks, `finally` is run prior.
- If an exception is re-raised, `finally` prior to re-raising the exception.
- If `finally` has a break or a return, that return or break will **always** be taken.

In short, `finally` always runs before exiting, for what ever reason, the `try-except-else` block.

### Raise
The `raise` statement allows a programmer to force a specified exception. 
- The argument to `raise` indicates the exception to be raised, it can be an instance or a type of exception. If an exception type is provided, it is implicitly instantiated by calling its constructor with no arguments.
- If you want to re-raise an exception within a `except` clause just add a `raise` statement. It will re-raise the same exception of the handler.

### Exception Chaining
Unhandled exceptions raised from within an exception handler will have the exception being handled attached to it.
```
try:
    open("database.sqlite")
except OSError:
    raise RuntimeError("unable to handle error")

Traceback (most recent call last):
  File "<stdin>", line 2, in <module>
FileNotFoundError: [Errno 2] No such file or directory: 'database.sqlite'

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "<stdin>", line 4, in <module>
RuntimeError: unable to handle error
```

To indicate that an exception is a direct consequence of another, the raise statement allows an optional from clause:
```python
# exc must be exception instance or None.
raise RuntimeError from exc
```

### User-defined Exceptions
User-defined exceptions should usually be derived from the `Exception` class. By convention exception classes should end with `Error`.

### Predefined Cleaning Actions
Some objects, like files, have predefined cleaning actions and will indicate it in their respective documentation. To 
use the objects cleaning action use the `with` statement. These objects often implement `__enter__()`  and `__exit__()`
methods as part of the context management protocol.

### Exception Groups and except*
`ExceptionGroup` is a build in exception that contains a message and a list of exceptions. To selectively handle some of 
the exceptions in `ExceptionGroup` use `except* Error`.
```
def f():
    excs = [OSError('error 1'), SystemError('error 2')]
    raise ExceptionGroup('there were problems', excs)

 + Exception Group Traceback (most recent call last):
 |   File "<stdin>", line 1, in <module>
 |   File "<stdin>", line 3, in f
 | ExceptionGroup: there were problems
 +-+---------------- 1 ----------------
   | OSError: error 1
   +---------------- 2 ----------------
   | SystemError: error 2
   +------------------------------------

try:
    f()
except* OSError as e:
    print("There were OSErrors")
except* SystemError as e:
    print("There were SystemErrors")
```

### Adding Notes
Exception have a method `add_note()`. The standard traceback rendering includes all notes, in the order 
they were added, after the exception.
