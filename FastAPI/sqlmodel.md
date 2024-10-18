SQLModel is a ORM that is built on top of Pydantic and SQLAlchemy.

> Note `SQLModel` borrows ideas from both Pydantic and SQLAlchemy.
> Most constructs you're familiar form Pydantic and SQLAlchemy are imported from SQLModel.
> SQLModel uses the same or sometimes adds a thin layer on top of those constructs.

```
from sqlmodel import Field, SQLModel, create_engine, Session
```

___
### In a hurry?
Here is the summary, any class inheriting from `SQLModel, table=True` is tracked by the SQLModel class, this 
is used to generate tables. Ignore `table=True`, if your curious look into Python meta classes. 

For *column types* use standard Python types, you know, `int`, `str`, `None`, etc.
For *column constraints*, use `Field`. To illustrate, `Field(primary_key=True, index=True, default=None)`.
You get the gist, the attribute names are the column names, the types are column types, the constraints are everything you set in `Field`.

To interface with a database *you need an engine*. To create an engine use `create_engine(URI, echo=True)`,
`echo=True` just echos all the SQL commands ran, that way you can get an idea about what is happening under 
the hood.

To generate all tables run `SQLModel.metadata.create_all(engine)`. Yes, I told you SQLModel tracks all classes
with `table=True`. You should see the table SQL query echoed if not already created.

Engines are global per application, there shall be only one. Sessions are local to a *method*. They encapsulate atomic
operations. You use context managers, perform operations, if mutable you must commit the operations. This ensures atomicity.

You interface with entries of the database using instances of your, em, "table class". To insert, update, delete, you must
provide the adequate instance. Queries return "table classes" plural or singular depending whether you use `.first`, `.one`, `.get`,
we will see this latter.

So to query an entries we would:
- Use the query builder `select(<"table class">)`. Think of this as the builder pattern, but for queries: Query builder.
- Tack as many modifiers as needed, `.where()`,`.where(or_())`, `.limit()`, `.offset()`
- Execute query, `session.exec(<query>)`
- Additionally you can use `.first` or `.one` on the *result* object.
    - `.one` errors if 0 or more than one results in *result*.
    - `.first` returns None if 0 or the first if 1 or more than one in *result*.

So to create an entry we would:
- Create an instance of the "table class".
- Use the `.add(instance)` method of the session object (`Seesion(engine)`).
- Commit the changes since the operation is mutable, `session.commit()`

So to delete, or update:
- Get the entry, yes this is painful.
- Use `session.delete(instance)` to delete.
- Modify instance and then `session.add(instance)`.
- Again, both operations are mutable so you must commit.

Ok this is obvious but not you Python instances are abstractions of the rows in the database. Any time
you instance is added or modified by the database you instance is invalidated. To validate again you can 
`session.refresh(instance)` or perform attribute access `instance.attr`. Both of this operations perform a 
query to get the up to date object. Be careful.
___


To construct tables, first build a `model` and make it inherit from `SQLModel, table=True`, yes
the syntax is weird but it has to do with Python meta classes and inheritance. Then define your types
normally, the syntax looks really similar to Pydantic, because in a way it is. You can use `Field`
to add information about the type, like `primary_key=True`.

```python
class Hero(SQLModel, table=True):
    id : int | None = Field(primary_key=True, default=None)
    name : str
    secret_name : str
    age : int | None
```

Now this is the table definition, to create the table through SQLModel we need an `engine`. Engines
come from SQLAlchemy, they are *singletons* that handle the connection with the DB and manage resources
through, for example polling. We instantiate the engine with `create_engine` and pass it the connection URI.

```
sqlite_url = f"sqlite:///{database_file}"
engine = create_engine(sqlite_url, echo=True) # echo shows the operations performed, useful for knowing what is going on.
```

Now this is, not really, similar to the `cursor` for SQLite. To create the database from the tables use `SQLModel.metadata.create_all(engine)`.
Ok so what it is important to know is that every time you inherit from `SQLModel, table=True`, `table=True` sets metadata to the SQLModel
class. Essentially, it tells SQLModel to track the table, not really, think of it as a class attribute.

Normally you don't use your engine directly, rather you use `Session`, another abstraction provided by SQLModel. The idea is that `Session`s are 
local to the current `request/function/path operator function`. The main "feature" of sessions is that they perform *atomic* operations. 
This is, you add all the operations you want to perform, and then you commit them, ensuring all succeed or all fail.

```
with Session(engine) as s:
    s.add(hero1)
    s.add(hero2)
    s.commit()
```

And yes, each `hero(\d)` above is an instance of the `Hero` class. Any instance of a `SQLModel, table=True` can be added to the database, with procedures
similar to the one above.

*A major source of confusion regarding insertions is that instances are invalidated*. By this I mean the `binding/variable/name` is nullified. To make the
`name` valid again you perform attribute access or refresh it by using `session.refresh(instance)`. By doing this, a query is made to the database to get
the updated information. Weird, but some information of such instances is only set in the database, for example `SERIAL PRIMARY KEY`.
*Note this are extra queries to the database*.

> After insertion, perform attribute access or `session.refresh(instance)` to validate the instance.

### Queries
Queries follow a particular structure in SQLModel. First you initialize the session with a context manager. Then you 
build your `query/statement`, then you execute it.

#### Select
To construct a query you start with the `select` builder from `sqlmodel`.
```
with Session(engine) as s:
    query = select(Hero) # Equivalent to SELECT * FROM hero;
    result = s.exec(query) # Result is an iterable.
    all_results = result.all() # List of all results.
```

#### Where
You can add `.where` builders to `select` to construct more complex queries. Where accepts
comparators to perform data filtering. To avoid intelisense errors, you should use `col()` 
to wrap the columns of the table.
```
query = select(Hero).where(col(Hero.age) == 20) # Equivalent to SELECT * FROM hero where hero.age == 20;
query = select(Hero).where(or_(col(Hero.age) > 20, col(Hero.age) < 30)) # Equivalent to SELECT * FROM hero where hero.age == 20 AND ;
```
You can add `AND` clauses by tacking more `.where` or you can just add multiple expressions the one 
`.where(<exp1>, <exp2>, ... <expn>)`. You can also user `OR`, in this case you need to wrap you expressions
in `.where(or_(<exp1>, <exp2>, ... <expn>))`.

### One single row
To get one single row use `.first` on the response, not on the query rather the response from executing the query.
If we want *only* one use `.one` on the response. The difference between `.first` and `.one`:
- If no rows are in the response, `first` returns `None`, `.one` raises an error.
- If more than one row are in the response, `.first` returns the first one, `.one` raises an error.

Getting one row by `id` is such a common operation that the following are equivalent. If no match is found,`None` is returned.
```
session.exec(select(Hero).where(col(Hero.id) == 1)).first()
session.get(Hero, 1)
```

### Limit and Offset
Similar to `.where`, `.limit` and `.offset` modify the `select` object. This is, in a sense a query builder. Where we
get a query object via `select()` and all other methods modify the `select object`. This maps to the `SELECT * FROM table WHERE expr AND expr LIMIT int OFFSET int`.

### Update
Yes, updating using SQLModel is *really* inefficient. First you retrieve the row. You modify it. You save it.
```
results = session.exec(select(Hero).where(col(Hero.name) == "Superman"))
hero = results.one()
hero.name = "The Superman"
session.add(hero)
session.commit()
```
Yes, all that to update an entry. You can, however, use `session.execute("UPDATE hero SET name =: name", {"name" : "The Superman"})` and 
it will do the same trick.

### Delete
Yes, delete is similar to `UPDATE`, really inefficient. First you retrieve the row. You delete the row.
```
results = session.exec(select(Hero).where(col(Hero.name) == "Superman"))
hero = results.one()
session.delete(hero)
session.commit()
```
