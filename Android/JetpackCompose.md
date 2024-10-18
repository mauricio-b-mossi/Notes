### Basics
Here I will cover Jetpack Compose basics, as I intend to be flipping back and fourth between Compose and React.

Compose has three phases:
1. Composition
2. Layout
3. Draw

#### Recomposition

Composition can occur several times throughout your application's lifetime, this is due to the initial composition, 
configuration changes, and the activity lifecycle which trigger the activity to be recreated.

Within the composition, recompositions occur when `State<T>` changes. Recomposition tends to be expensive, so it must 
be kept at a minimum. Compose uses intelligent recomposition, meaning it only recomposes Composables that have changed.
Since Composables are intended to be ***Pure Functions***, the only was for them to change is if `State<T>` within changes
or if the arguments to the Composable change. To check for changes compose uses the `equals()` method. However, this only 
applies for immutable types (primitives, functions, lambdas), this is because Objects and Lists might change and the `equals()`
method does not detect change, since the reference is the same. Therefore, to tell Compose that you will ensure that 
you will inform it of any changes, annotate mutable types with the `@Stable` annotation. Else if the type is not Stable
Compose will always recompose the Composable.

> Note there is a distinction between immutable, constant and Stable.

To illustrate:
```kotlin
val mList = mutableListOf(1,2,3)
// The type of iList is "immutable". However, it can still be changed as it refers to mList which is mutable.
val iList : List = mList

// Oops, iList changed
mList.add(3)

data class Person(val name : String, var age : Int)

// Defined with a val, Immutable?
val person = Person(name = "Mauricio", age = 20)

// Oops, person changed
person.age(21)
```



#### Preserving State.

Compose tracks Composables and their state by the call-site of the Composable, in contrast to React which tracks state 
by its position in the UI tree.

To illustrate:
```kotlin
if(bool){
    Counter()
} else {
    Counter()
}
```
```javascript
{bool ? <Counter/> : <Counter/>}
```

In React even though we toggle between `<Counter/>`, React tracks the state of a Counter Component at position X in the tree.
If you look closely independent of which Counter is toggled it still is a Counter Component at position X.

In contrast Compose, tracks by call-site (position in the source code). Therefore one Counter is never the other Counter.

Usually you would, in React terms, aim for Controlled Components, meaning Components that do not hold their own state. Counter
above is an uncontrolled Component as it owns its own state.
