### Interfaces

Interfaces describe the concept of a type. It is a prototype fro all classes that implement the interface.
It describes what a class should do, by not hwo it should do it.

- All classes can implement interfaces, including enums.

- Interfaces cannot have initialized properties, but can contained implemented functions.
- Functional Interfaces are SAM (Single abstract method) interfaces. Think Comparable and Runnable in Java.

```kotlin
interface Swimmer{
    val speed : Int
    //val speeedError : Int = 0 - Does not compile: Property initializers are not allowed in interfaces.
}

fun interface Swimmer{
    fun swim
}

val fish = Swimmer{
    println("swimming") // Since Swimmer only has one method, it knows I'm implementing it within the curlys.
}

// Or the verbose way

class FishSwimmer : Swimmer{
    override fun swim(){
        println("fishSwimmer")
    }
}

val fishSwimmer = FishSwimmer()

fish.swim()
fishSwimmer.swim()

```

### Abstract Classes

An abstract class is like an ordinary class except one or moere functions or properties is
incomplete: a function lacks a definition or a property is declared without initialization.
<mark>An interface is like an abstract class but without state.</mark>

### Comparison between Interfaces and Abstract Classes

- Interfaces cannot contain any state: State is data stored inside properties (`var val`).
- Cannot create a class form an Interface or a Abstract Class.
- Everything in an Interface is abstract by default (Abstract = without implementation).
- If a property or function is not initialized in an Abstract Class add the `abstract` modifier.
- Both Interfaces and Abstract Classes can contain functions with implementations.
- Since an Abstract Class is a Class you can only extend one.
- You can implement multiple Interfaces.

### Upcasting

Upcasting refers to inheritance hierarchies, where the upper part is the base / super class,
while the lower parts are the derived / sub classes. Therefore, upcasting refers to treatment
of subclasses as base classes. At the end a subclass is a base class.

- Upcasting allows polymorphism. A function that accepts Animals also accepts Dogs, Cats, etc.

```kotlin
abstract class Animal{
    abstract fun makeNoise()
}
class Dog : Animal(){
    override fun makeNoise() = println("Bark")
}
class Cat : Animal(){
    override fun makeNoise() = println("Meow")
}

fun makeNoise(animal: Animal){
    animal.makeNoise()
}
```

> Where there is inheritance without upcasting, inheritance is being misused.

One thing that arises as result of Substitutability, also called Liskov Substitution Principle,
is that once a class is upcasted, the derived type can be treated exactly as the base type - no
more no less. This means that any functions added to the derived class are in effect "trimmed off".
To recoup, the behaviour of the derived class once upcasted, a downcast is necessary.

### Downcating

Downcasting discovers the specific type of a previous-upcast object. Kotlin makes this easy with
Smart casts. Smart casts are automatic downcasts. The keyword `is` checks whether an object
is a particular type. Any code within the scope of that check assumes that it is that type:

```kotlin
fun main() {
    val dogs = listOf<Animal>(Dog("Tocino"), Dog("Hutch"), Dog("Rocket"))
    dogs.forEach { if (it is Dog) it.name }
    dogs.forEach { it.name } // Error: Unresolved reference name.
}
abstract class Animal{
    abstract fun makeNoise()
}
class Dog(val name : String) : Animal(){
    override fun makeNoise() = println("Bark")
}
```

> Smart casts are especially useful inside when expressions that use is to search for the type
> of the when argument.

After a smart cast you can forcefully cast with `as`.

### Composition and Class Delegation

Inheritance describes an is-a relationship while composition represents a has-a relationship.
A Car is not a door or a wheel but it has doors and wheels.

```kotlin
class Car{
    var door = Door()
    var wheels = List(4){Wheel()}
}
class Wheel
class Door
```

The thing with composition is that it uses the functionality of an embedded object
but does not expose its interface. For a class to reuse an existing implementation and
implement its interface you have two options: inheritance and class composition.

```kotlin

abstract class Animal

fun interface Eat {
    fun eating()
}

fun interface Move {
    fun moving()
}

class Dog(eater: Eat, mover: Move) : Eat by eater, Move by mover, Animal()

class Dog(carnivore, fourLegged) : Eat by carnivore, Move by fourLegged.
```
