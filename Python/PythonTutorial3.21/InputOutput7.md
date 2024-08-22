### Format Strings
There are three distinct ways to format strings: f-strings, `str.format()`, `string % values`. The first being the newest and the third being the oldest.

##### f-strings
F-strings start either with a `f""` or `F''` followed by string quotes. Within brackets `{}` in the f-string literal
you can place Python expressions to be evaluated. Furthermore, format specifiers can follow the expression. To look
at all possible format specifiers look into `Format Specification Mini-Language`. The general structure of an f-string
is `f"{expression:format}"`.
```python
f"You have ${12.536:.2f} dollars." # You have 12.54 dollars.
f"{"center":*^20}"                 # *******center*******
```
> f-strings are faster than `str.format` since the expressions in brackets `{}` are evaluated at runtime. No `.format()`,
> function needs to be called.

Self documenting expressions are of the form `f"{var = }" == f"var = {var}"`. Where the space within the `{}` is respected.
```python
name = "Jose"
print(f"{name = }") # "name = 'Jose'"
print(f"{name=}")   # "name='Jose'"
```

##### str.format()
`str.format()` is similar to f-strings in the sense that it uses the `Format Specification Mini-Language`. One difference,
if that `str` is a string of place holders, such that when `str.format()` is called the values passed into `format()`, fill
the place holders. Similarity to f-strings, placeholders are represented by brackets `{}`. The difference is that the 
brackets can have several things within.
- `{:format}`: If the default ordering of the variables passed into `format()` is to be used.
- `{int:format}`: Indicates that the `i^nth` item passed into `format()` should be placed within that bracket.
- `{key:format}`: Indicates that if `kwargs` are passed into `format()`. The `kwargs[key]` must be placed within that bracket.

### Reading and Writing Files
Handling files in python is surprisingly easy, `open(file[, mode [, encoding]])` returns a file object. The modes represent, 
the way in which the file object will be used.
- `r`: Default flag, read.
- `r+`: Write and read.
- `w`: Write.
- `a`: Append.

Files by default are opened as text, to open as binary add a `b` to the end of the flags above. For example, `rb` reads
a binary file.

When writing and reading form a file in text mode platform specifics are standardized.
- When reading in Windows, `\n\r` is read as `\n`.
- When writing in Windows `\n` is converted into `\n\r`.

What this means is **do not think about platform specific behavior while writing, Python knows your platform and will transform accordingly**.
In other words, if you are in Windows, use `\n` when writing to files and `\n\r` will be read as `\n`.

##### Opening and closing files
> It is good practice to use the with keyword when dealing with file objects.
> The advantage is that the file is properly closed after its suite finishes,
> even if an exception is raised at some point. Using with is also much shorter 
> than writing equivalent try-finally blocks:
```python
with open('workfile', encoding="utf-8") as f:
    read_data = f.read()

# We can check that the file has been automatically closed.
f.closed
```
Else you will have to close the file manually with `f.close()`.
**After a file has been closed**, either by exiting the scope of `with` or `f.close()`,
**attempts to use the file object will fail**.

##### File methods
 Reading:
- `read([size])`: Reads, returns, `size` characters from file. If negative or `None` reads to EOF.
- `readline()`: Reads, returns, a line of the file. Each line returned ends with `\n`. If `readline()` returns empty string EOF has been reached.
- `readlines()`: Converts each line into an entry of a list.
- `for line in f:` Iterates over all lines in file.
- `list(f)`: Converts each line into an entry of a list.

Writing:
Everything written into a file must be either **binary or string** depending on the mode.
- `write(string)`: Writes string to file, returns number of characters written.

Movement:
- `f.tell()`: Returns integer giving the current position of an item in the file. 
    - If opened in binary, returns the number of bytes from the beginning. You can use this in `f.seek(offset [,whence])`
    - If opened in text, returns an opaque number. Surprisingly, you can also use it with `f.seek(offset [,whence])`, as it is used to navigate the file consistently.

Opaque means that the number doesn't have a straightforward interpretation in terms of the number of characters or 
bytes. Instead, it represents a position within the internal buffer that Python uses to handle text files.

- `f.seek(offset [,whence])`: Used to change the file object's position.
    - `offset`: Offset from reference point described by whence. Can be positive or negative.
    - `whence`: Sets reference point for offset. Can be:
        - `0`: Represents the beginning of the file.
        - `1`: Represents the current position in the file.
        - `2`: Represents the end of the file.

> In text files (those opened without a b in the mode string), only seeks relative to the beginning of the file are allowed (the exception being seeking to the very file end with seek(0, 2)) and the only valid offset values are those returned from the f.tell(), or zero. Any other offset value produces undefined behaviour.

### Saving data with `json`
With the `json` module you can serialize structured data to JSON and deserialize it back into data.
- `dumps(x)`: Returns the JSON representation of an object.
- `dump(x, f)`: Dumps the JSON representation of an object into a file.
- `load(f)`: Loads JSON from file.

> JSON files must be encoded in UTF-8. Use encoding="utf-8" when opening JSON file as a text file for both of reading and writing.

`json` can handle dictionaries, and lists but more complex structures like classes might need a bit of work.
