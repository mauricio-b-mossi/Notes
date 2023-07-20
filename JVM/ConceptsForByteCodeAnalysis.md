### Viewing JVM bytecode
With the `javap` command you can view the JVM bytecode produced by `.class` files. Use the `-v` and `-p` to view 
the complete source: `-v` (verbose), `-p` (include private methods).

### How does the JVM work?
In a nutshell, there is a ***stack***  and a ***locals***. 
- Stack: Holds the stack, the stack has a specified size.
- Locals: Holds the local variables.
Both, the current stack and locals are allocated, their size can be viewed decompiling the `.class` file.

The basic functioning is as so. You have operands and operators, the operands are pushed into the stack, and the 
operators acts on values on the stack. Each operator (this can be from simple arithmetic to function invocations) 
grabs its required arguments from the stack: as the Stack is LIFO, the arguments grabbed by the operator are the `n`
last ones.

### Basic Commands.
Bytecode instructions relating to primitives are often pre-fixed with the initial of their type: `i` for integer, `d` 
for double, `f` for float. Types are referred to via pointers pre-fixed with `a` for address. To illustrate:
- `iconst_2`: Add an integer constant of 2 to the stack.
- `areturn`: Return the last item in the stack as an address.
- `istore_1`: Store the last item in the stack as an integer in position 1.

*Both stack and locals start empty (when the method is virtual it holds a reference to `this` in locals). Think of them as lists,
which are 0 indexed. Therefore, you must add to the ***stack*** , store to ***locals***, and invoke functions. You can add to the stack 
in several ways, that is the thing about bytecode, it is really expressive. The general pattern you will see is adding to the stack, storing, 
loading, and invoking operands or functions.
```java
// Java
public static void main(String[] args){
    int i;
    i = 0;
    i += 3;
}
// Bytecode
stack=1, locals=2, args_size=1
         0: iconst_0
         1: istore_1
         2: iinc          1, 3
         5: return
```
In the example above, our stack is of size 1, locals of size 2, and args (arguments of main) of size 1.
1. We add an integer of 0 to the stack.
2. We store the integer to locals[1] (the second slot of locals).
3. We increment index 1 of locals by 3.
4. We return.

An interesting case are functions, when we call functions we grab n arguments from the stack. Calling a function, adds to the stack the function.
From the function we load parameters and use them, we do not have to declare them or store them as they are already stored when passed into a function.
```java
// Java
public static void main(String[] args){
    add(1, 3);
}

static int add(int a, int b){
    return a + b;
}
// Bytecode
public static void main(java.lang.String[]);
    descriptor: ([Ljava/lang/String;)V
    flags: (0x0009) ACC_PUBLIC, ACC_STATIC
    Code:
      stack=2, locals=1, args_size=1
         0: iconst_1
         1: iconst_3
         2: invokestatic  #7                  // Method add:(II)I
         5: pop
         6: return
      LineNumberTable:
        line 3: 0
        line 4: 6

  static int add(int, int);
    descriptor: (II)I
    flags: (0x0008) ACC_STATIC
    Code:
      stack=2, locals=2, args_size=2
         0: iload_0
         1: iload_1
         2: iadd
         3: ireturn
      LineNumberTable:
        line 7: 0
```
1. We add an integer of 1 to the stack.
2. We add an integer of 3 to the stack.
3. We invoke a static function #7: #7 is the index of `add()` in the `Constant Pool`, and enter the function.
4. (Inside add): We load position 0 of locals.
5. (Inside add): We load position 1 of locals.
6. (Inside add): We call operand `iadd`: integer add.
7. (Inside add): We return an integer with `ireturn`.
8. We pop the integer returned from the stack.
9. We return. 




