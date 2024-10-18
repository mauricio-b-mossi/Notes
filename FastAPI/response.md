### Overview
FastApi response model provides validate our data, provide documentation, and, most importantly, filter our responses.
By filtering our responses we might return our available type without extra computation while returning only what 
we desire from that type in our response: FastApi performs the heavy lifting of filtering our response.

There are two ways, or three depending on how you see it, to tell FastApi the return type of a *path operated function*.
- If we add a return type to the function, FastApi will consider that the return type.
- If we pass a type to the `response_model` argument in the decorator, FastApi will consider that the return type.
- If we pass both, FastApi will consider the `response_model` the return type. Adding both is just for IDE support purposes, as you'll see below.

Say we store `User` objects. We might have a query for users with a specific name, say `get_all_users`. However, we do not want to return
the matching `User` objects! They contain the password! We can then define a *response model* `UserOut` which is the same
as `User` but without the password.
```python
class User(BaseModel)
    name : str
    password : UUID

class UserOut(BaseModel)
    name : str

@app.get("/users", response_model=list[UserOut])
async def get_all_users(name : Annotated[str, Query(min_length=3)]) -> Any:
    return db.cursor("SELECT * FROM user WHERE name={name}")
```
The response model filters the data to match the according response type.

However, this is not as *"clean"*. As mentioned in the beginning here we add both `response_model` and a function return
type. The trick to avoid all this clumsiness is to use *Inheritance*.
```python
class UserOut(BaseModel):
    name : str

class UserIn(UserOut):
    password : UUID

@app.get("/users")
async def get_all_users(name : Annotated[str, Query(min_length=3)]) -> list[UserOut]:
    return db.cursor("SELECT * FROM user WHERE name={name}")
```

There are some cases where your response model might contain default values. To avoid sending default values in a response
use `response_model_exclude_unset=True`. Even though not recommended, you can perform filtration by using the
`response_model_include` and `response_model_exclude`, they specify only which to include, or only which to exclude.
For example `response_model_include={"username"}` *will only return the username, nothing else*,
and `response_model_exclude={"username"}` *will return everything but the username*.

In short, FastApi's response model is really useful, besides from documentation and response validation, we can filter
our response according.

### Status codes
To add a default status code on success per route use the `status_code` argument in the `@app.<operation>` decorator.
Remember each status code has specific meaning, is you don't remember the specific code, or for better readability 
you can use `from fastapi import status`. `status` provides all the status codes you'll need as constant. For example, `@app.post("/items/", status_code=status.HTTP_201_CREATED)`
