Fast API is really easy and cool. It uses Pydantic under the hood to perform data validation. It 
has some really nice features, like automatic request body, path, and query conversion from JSON
to python objects when you get them (deserizlizaton). Furthermore, it has automatic serialization 
when you respond.

The API is really intuitive, you declare paths + operations with `@app.<operation>(<path>)`. The path 
operation function is the function decorated. The function can be sync or async. If sync, `def`, it is 
awaited in a external thread pool. If async, `async def`, it is launched on the main thread. Within them
function you can access all data associated with the request. You use the parameters of the function to
represent query, path, and request body.
```python
@app.post("/api/{id}")
async def(id : Annotated[int, Path(gt = 0)], lang : Annotated[Lang, Query()], body : Body)
```
In general all but the *request body* must match exactly from the URL.
- `id` is an `int` that is required to be greater than `0`, we use `Path` to be specific that this is a path paremter *and to add validation*.
- `lang` is a `Lang(Enum)`, we use `Query` to be explicity that this is a query parameter.
- `body` is of type `Body(BaseModel)`.

The cool thing is that, if the shape of the arguments does not match precisely, and error is throw. Not any error
a verbose error about what went wrong. Furthermore, with all these type annotations, FastAPI generates some really 
nice docs.

The paramters can have default values, or be declared optional by setting the default value to `None`. To add validation
to Pydantic models use the default value `Field`.

> If not explicity specified via `Query`, `Path` and `Body`, any Pydantic class is considered a *request body*, any variable matching
> the placeholder in the URL represents a *path parameter*, any other primitive type represents a *query parameter*.

You can add multiple Pydantic classes to the path operation function and it will expect a JSON object with two fields, 
the ones specified in the request body.
```
{"user" : {"name" : "Mauricio", "age" : 21}, "job" : {"company" : "Exxon", "position" : "Manager"}}
-------------------------------
class User(BaseModel):
    name : str
    age : int
class Job(BaseModel):
    company : str
    position : str
-------------------------------
@app.post("/")
async def route(user : User, job : Job)
```

If you expect to extract a specific key from the *request body* use `Body(embed=True)`. To illustrate:
```
{name : "Jose"} and {"user":{"name": "Jose"}}
-------------------------------
class User(BaseModel):
    name : str
-------------------------------
def async route(user : User) # Only matches the first case.
def async route(user : Annotated[User, Body(embed=True)]) # Only matches the second case.
```

Pydantic models can themselves contain other models allowing you to better tailor the expected *request object*. These 
are known as nested models.

> To any Pydantic model you can "tack" the property `model_config = {"extra" : "forbid"}` to throw when extra keys are provided.
