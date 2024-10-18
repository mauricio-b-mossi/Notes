### Overview
Cookies and Headers are really similar to all request oriented constructs in FAST: `Query`, `Path`, `Body`, etc.
You can add validation in the specific functions, the name of the variable defined in the *path operator function*.
This is an exception however for *HTTP headers* since they are case insensitive, and some are separated by hyphens (`-`)
which are invalid in python identifier, yikes. So to solve it, any header sent in the request is parsed to match the casing
in the *path operator function* with type `Annotated[type, Header()]`, furthermore, any `-` in the *HTTP header* is parsed into
`_`. Therefore, for example:
```
Headers:
Content-Type: application/json
------------------------------
async def route(content_type = Annotated[str, Header()])
async def route(Content_Type = Annotated[str, Header()])
async def route(CONTENT_TYPE = Annotated[str, Header()])
```
Remember, the type information in this case is really important. As described in `basics.md`, by default, if not specified,
FastApi infers where to extract the parameter from the URL based on its type. Just for review purposes:
- *request body*: From any parameter extending a Pydantic model.
- *request path*: From any parameter named as the dynamic URL segment defined in the path (`/route/{id}`).
- *request query*: From any other parameter with primitive data type.

Therefore, we must specify `Cookie` and `Header` explicitly, again via the `Annotated` type which if you remember correctly
just adds metadata to the type: the *"real type"* is the first type in `Annotated[type, meta]`.

### Technicalities
Sometimes headers have multiple values. For example the cookie header, which you should handle with `Cookie`, can contain multiple 
cookies. To get them all you can just specify `Annotated[list[str], Header()]`.

> Remember, `from fastapi import Query, Path, Body, Header, Cookie` are all function that return the type. Yes, the type identifier
> is also the function name. Therefore, to use them in `Annotated` you have to make the function call.

### Groups of Cookies and Headers.
It might occur that you have a group of related cookies/headers. You can define a group as a Pydantic model and funnel and 
FastApi will extract the appropriate group from the request.
```
class Cors(BaseModel):
    access_control_allow_origin : str
    access_control_allow_headers : str
--------------------------------------
def async route(auth : Annotated[Cors, Cookie()])
```
Note in this case the name of the parameter is just for you, the caller does not care about the name `auth`. As with 
all Pydantic models, you can add the `model_config = {'extra': 'forbid'}` attribute to error when given extra attributes.
