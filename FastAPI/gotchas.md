### `from fastapi import Query, Path, Body, File, Cookie, Header`
Remember, all these are not used as types (they are types and function), they are just used *meta-data*.

### Union gotcha
Since *python 3.9+* we can use `|` instead of the `Union` type annotation. However, this is only read properly
for *annotations*. This comes to light in FastApi when we use `Annotated[type, class]`. We cannot pass `|` into 
`Annotated` as it will be interpreted as a value rather than an annotation. This means python will try to perform a 
*bitwise or*. 

This is occurs for example with `response_model=<type>`. The attribute expects a value, therefore `|` is evaluated
as an expression. However, this is not the case for, say, `file : Annotated[bytes | None, File()]`. This is because
in this case `|` is a annotation not a value.
