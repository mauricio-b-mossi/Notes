### Makefiles
Makefiles are build tools, similar to the go programming language build tool. The 
essence of Makefiles are ***rules***, ***dependencies***, ***commands***:
```makefile
**rule**: **dependencies**
    **commands**
```
As a note, the rule often is the name of the file produced by the commands. A rule
can have multiple dependencies and multiple commands. For multiple dependencies, 
separate them with a space in the same line. For commands separate commands by line.
Importantly, remember that commands are indented by one tab, spaces will not work.

The first rule is the default rule, it is called if the `make` command is invoked with 
no arguments. To call other rules, specify the rule name, such as `make other.o`. The order
of evaluation of the make file is linear, like a stack. If a rule has dependencies, it 
searches linearly for the dependency, if the dependency has other dependencies the process is 
repeated, the element in the stack is popped and so on, until all dependencies have been resolved.

Additionally, Makefiles can contain variables. Declare variables at the top of the file and use 
them within commands with `${var}`:
```makefile
compiler=g++

main.out: main.cpp thing.cpp
    ${compiler} -o main.out main.cpp thing.cpp
    main.out

// Equivalent to:
main.out: main.cpp thing.cpp
    ${compiler} -o $@ main.cpp thing.cpp
    main.out
```

In the example above, both `main.out` rules are correct. In the second derision I've omitted
the name `main.out` in the command and substituted it for `$@`. You might infer its meaning from 
the leading `$`. Similarly, instead of typing out the dependencies we have the variable `$^`
This is also a variable and it represents the same of the rule.

Makefiles are super useful if you know how to properly compile. By this I mean producing intermediate
object files per each file so only the necessary files are recompiled when they change. Furthermore, 
Makefiles track if files are up to date, this allows `make` to not recompile when everything is 
up to date, it does so by the time last modifier of files.
