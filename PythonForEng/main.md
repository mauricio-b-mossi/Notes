# Introduction
Numpy, numerical Python, is a package that deals with scientific computing in Python. The main object is
the multidimensional array called the `ndarray` or also known by its alias `array`. Numpy's `ndarray` is
*homogeneous*, memory efficient, and highly optimized for vectorized operations.

> Note, if a method is used it comes without an explicit namespace, the namespace is `numpy`.

# Basic Properties of `ndarray`
Each `ndarray` has:
- `ndim`: Number of axis.
- `shape`: Tuple of size `ndim` where each item represents the size of the axis, for example `(2, 3)`.
- `size`: The product of all the elements in `shape`. Represents the number of items in the structure.
- `itemsize`: The size of each item in the array in bytes.
- `data`: The buffer containing all the data.
- `dtype`: The datatype of the structure. You can set the specific type at construction, use `dtype=np.<datatype>`, else it is inferred.

# Array Creation
You can create an `ndarray` in several ways.
- Using the `array()` and providing *one* iterable.
- Using constructors such as `zeros()`, `ones()`, `empty()`, given a shape it constructs the specified structure.
- As sequence using `arange()` or `linspace()`.

The key distinction between `arange` and `linspace` is that `arange` is like Python's `range`. It constructs a structure 
accordingly. On the other hand, `linspace` constructs a linear space with `n` given intervals. For example, `linspace(0, 1, 100)`
constructs a structure with 100 floats linearly increasing from 0 to 1. Usually you use this for functions to represent continuous data.
As a rule of thumb, if you need discrete steps use range. If you need pseudo continuous steps use `linspace`, where the larger the `n`, the 
more *"continuous"* the structure.

# Shape manipulation
- `ravel()`: Flattens a structure.
- `reshape()`: Given a shape, if compatible with the size of the structure, returns a new structure of the given shape.
- `resize()`: Given a shape, if compatible with the size of the structure, changes the shape of the structure.

The key difference between `reshape` and `resize` is that `resize` mutates the structure.

You can also concatenate with `vstack`, `hstack`, `concatenate`. Or split with `vsplit`, `hsplit`.

# Vectorized Operations
Operators are vectorized. This means that given an operator and a structure. The operator acts element wise on the structure.
This includes both `arithmetic`, `boolean`, `bitwise`, etc. For example, `np.array < 10` returns a structure of booleans. By 
default operators do not mutate data.

# Mutating Data
The key distinction between `numpy` and Python, is that slicing in `numpy` returns a view not a shallow copy. This means 
that changes in the slice modify the original structure. As with other conventions, passing to a function references the 
original structure as does assignment. You can explicitly deep copy a structure by using `array.copy()`.

# Views
Views share data with a original `array`. Therefore if the view's is modified, it also modifies the original data. However,
other operations such as shape manipulation do not change the underlying data and therefore do not modify the original data.

# Aggregate and Unary operations
Some unary operations are implemented as methods of `ndarray`. Examples include `sum`, `min`, etc. Such methods act
on all items of the structure. If you want to specify a direction of action you must specify the `axis`. 

You can think of it like this, when you specify an `axis`, the operation groups all elements in the axis, to form 
a `1D` array of size of the specified axis. Then it performs the vectorized operation on those items. This might be
confusing since say `np.array.sum(axis=0)`, one might thing it sums the values per each row. Instead it sums the columns.
This is because it treats all items in `axis=0` as a unit, and then vectorized the operation on the resulting `1D` array.
This is why some say you collapse on the axis.

# Indexing
Indexing is done via tuples, where the ith element of the tuple represents the indexing for the ith axis. If the size of the 
indexing is less than `ndim`, the remaining indices are filled with `:` to the right. You can use all the slicing notation
you are familiar from Python.

Advanced indexing can be done by providing `ndarray`'s:
- If the `ndarry` is of integers, only those indices for the given axis are selected. In this case `ndarray` *does not* have to be as the same size as the axis.
- If the `ndarray` is of booleans, only the indices with `True` for the given axis are selected. In this case `ndarray` *does* have to be as the same size as the axis.

So for example you could do something like `a[a[:,:] > 5]`, which would select all items larger than 5. This is because
`a[:,:] > 5` returns a boolean array of shape equal to `a.shape`.

# Broadcasting
Broadcasting allows operations to be performed on differently shaped structures.
Broadcasting works from inner to outermost axis. The rules are simple.

- An axis of length 1 is broadcaster to match the size of the other array.
- 1s are prepended to match the shape of the other array.

If the inner axis do not match or are not 1. The operation cannot be performed. For example, `(2,)` and `(3, 2)` are 
compatible shapes, while `(3, )` and `(3, 2)` are not. This is because the inner dimensions are matched first.
