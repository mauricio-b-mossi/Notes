### Note on the client side
Remember, from the client side you need to set `enctype=`:
- `application/x-www-form-urlencoded`: The initial default type.
- `multipart/form-data`: The type that allows file `<input>` element(s) to upload file data.
- `text/plain`: Ambiguous format, human-readable content not reliably interpretable by computer.

### Forms
Most of what is needed for basic requests was covered in `basics.md`. However, using `Body` assumes the data
is in `JSON` format. What do we do if this is not the case? 

For example, `<form></form>`s send their data 
as `Content-Type: x-www-form-urlencoded`. The format is just a string with key value pairs separated by ampersands
`key=value&key2=value2`. This is why when you submit a form, and the form method is *get* the form information
will be added to the URL as query parameters, which also follow the format `key=value&key2=value2`.

To tell FastApi how to handle such cases we use `from fastapi import Form`, again it is similar to all other request 
handlers. You can extract the individual keys by naming the *path operator function parameter* the same as the key of the 
form or you could construct a form model by using Pydantic. The same holds, as for all request handlers, you want to
do `username : Annotated[str, Form()]` or `user : Annotated[User, Form()]`.

### Files
FastApi makes it really easy to just work with files. The *"primitive"* FastApi provides is `from fastapi import File`.
To accept a file the *path operated function* must look as follows: `async def route(file : Annotated[bytes, File()])`.

> Note, if you declare the type as `Annotated[bytes, File()]`, FastApi will store *all* the contents of the file *in memory* as bytes.
> therefore this works well for small files. Define small however you wish.

FastApi also provides a higher level abstraction to the `bytes`, namely `UploadFile`. `UploadFile` is strictly a type, it is not used
as *meta-data* as is the case of `File`, so you use it as `async def route(file : UploadFile)`.

`UploadFile` has several advantages over `bytes`, namely:
- It has a file-like interface, meaning that it exposes all the methods you expect from file-like objects: `write`, `read`, etc.
- It *spooled*, meaning the file is kept in memory *up to a limit* at which the file is written to disk to allow further reading. 
This has several advantages as it does not hog all the memory.

Furthermore, `UploadFile` provides an `async` API for its file-like methods: `read`, `write`, `seek`, `close`.

> Remember `UploadFile` is a type, if your *path operator function* is complex, it might be convenient to use `Annotated[UploadFile, File()]`.
> For you it is obvious that `UploadFile` is the body, but remember FastApi does all the parsing and deserializing, might aswell be explicit.
