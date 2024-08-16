## Terminology
- Modules: Files ending with `.py`. Can be executed as scripts or imported into other modules or the interpreter.
- Packages: A way to structure a collection of modules. They are directories containig a `__init__.py` file. 
    Submodules and subpackages within a package can be accessed via the `dotted module name`, for example `import package.module`.

### Modules
In python a module is just a file ending with `.py`. Each module has its own global namespace. You can:
- Run modules as scripts `python <module>.py`.
- Import modules into other modules or the interactive shell `import <module>`

All modules have the property `__name__` in their namespace. This property returns the name of the module.
**If the module is executed as a script, `__name__ == "__main__"`**. 

When you import a module you **do not** import the namespace of the module into the current namespace. Instead
it adds the module's name to the current namespace. The name can be used to access all the definition in the 
imported module.
```python
import fibo
fibo.fib1(10) # Runs fib1 form the fibo module.
```

There are different ways to import modules:
- Import a specific definition to the current namespace `from <module> import <definition>`.
- Import all definitions, exepct those starting with `_`, into the current namespace `from <module> import *`. 
    This is frowned upon as it can override definitions in the current module's namespace.
- Import module or module's definition under a different as a different identifier `import fibo as fib`.

A module can contain both definitions and executable statements. Everytime a module is imported or executed as a script,
all statements are executed. To make your module flexible as a script and an importable module, check whether your module 
if ran as a script by using `if __name__ == "main"` followed by the statements to be executed if module is ran as a script.

> `if __name__ == "main"` has several purposes, it makes your modules rehusable and executable. Sometimes, you might
> even have tests run on your module when it is executed as a script.

### All about imports.

### Compiled Modules `__pycache__`
Pycache caches compiled modules with under the name `module.version.pyc`. Compiled files are platform independent, 
and the checking whether a cached file is up to date is done automatically by checking timestamps. 

> Python does not check the cache in two circumstances. First, it always recompiles and does not store the result
> for the module that’s loaded directly from the command line. Second, it does not check the cache if there is no 
> source module. To support a non-source (compiled only) distribution, the compiled module must be in the source 
> directory, and there must not be a source module.

This means:
1. If you run `python a.py` `a.py` won't be cached in `__pycache__`. However, the modules it uses
**will** be cached.
2. If there is no source module to be imported, the cache is not checked. To work around this, move the `.pyc` file
for the module into the source directory and change its name to the source's file.
```python
# Original view.
|-a.py
|-b.py
|-__pycache__
    |-b.cpython33.pyc
# After following 2.
|-a.py
|-b.pyc
|-__pycache__
```

### Dir
The built-in function `dir([module])` returns a sorted list of strings of all the definitions in a module. If no
argument is provide, it retruns a list of the definitions in the current namespace. 
**`dir` does not list the names of built in functions and variables. They are defined in the standard module `builtins`**.

### Packages
Packages allow the grouping of multiple funcitonality while avoiding name collisions of modules and promoting mantainability.

> Python 3.3 does not require `__init__.py` to make a package, this is due to **Implicit Namespace Packages**.
In their most basic sense packages are just folders with modules in them. If used as so they just act to group related modules
and avoid name collisions since to refer to a specific module you use its `dotted module name`: `pkg.module`.

> Python 3.2 an below **must** have an `__init__.py` file to make a package.
Packages can also have `__init__.py` files which invoked when the package or module within the is imported.

As described in the Python docs.
> Packages are a way of structuring Python’s module namespace by using “dotted module names”.
> For example, the module name A.B designates a submodule named B in a package named A. 

You can have subpackages and submodules within packages. Each one can be imported via the import statements above and 
**using the dot `.` notation to refer to packages and modules.**

> Contrarily, when using syntax like import item.subitem.subsubitem, each item except for the last must be a package;
> the last item can be a module or a package but can’t be a class or function or variable defined in the previous item.

In other words, the last item of a `dotted module name` import must be a package or a module, to import a specific definition 
use `from package.module import func`.

### __all__: In packages and modules.
When `from package import *` is called, `__init__.py` is executed.
- If `__all__ = [modules, ]` if defined, then those modules will be imported.
- If not defined, only `__init__.py` is executed.

When from `module import *` is called all definitions are imported into the current namespace.
- If the module has `__all__`, it specifies which definitions to export.

### Relative and absolute imports
Remember, imports are resolved with respect to the paths in `sys.path`. `sys.path` has some default paths set. However,
there is one path that is determined by where you run your program, and how you do it. 
- If you start an interactive shell, a default path is set to `''` to represent the current directory.
- If you run a python script, a default path is set to the parent directory of the module.

- If you use an **absolute path**, the path is absolute with respect to `sys.path`.
- If you use a **relative path**, the path is relative to the module's `__name__`. Therefore, a file intended to be 
    used as a main module must always use absolute imports. 
