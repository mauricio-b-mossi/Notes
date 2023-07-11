# Layouts and Modifiers in Compose Key Points

### Basic Layouts

`Box`, `Row`, `Column`, are all layouts in Compose. Layouts are `inline` functions.
By default, they take up the size of their children. Sometimes you might want to
position a child element different from the constraints specified by `Layout`. To
do this, every child in `Layout` has access to the `Modifier.align()` method, which
aligns the child absolutely within the layout parent.

`Box` provides the `Modifier.matchParentSize()` method, which in contrast to the
`Modifier.fillMaxSize()` does NOT, take part in defining the size of the `Layout`,
it just matches the current size of the `Box`.

> `BoxScope` is due to _Modifier Scope Safety_. The Modifier Scope Safety ensures
> that the child `@Composables` only have access to Modifiers that work within their
> parents context. For example, `Box` does not have weight and `Row` does not have matchParentSize.

### Lazy Layouts

Lazy Layouts allow composables to be generated lazily when they are approaching the user's view.
For these Compose provides `LazyColumn`, `LazyHorizontalGrid`, `LazyRow`, and staggered grids.

### [Compose Phases](https://www.youtube.com/watch?v=0yK7KoruhSM&list=PLWz5rJ2EKKc94tpHND8pW8Qt8ZfT1a4cq&index=3j)

When data is given to a composable, the composable goes through three phase:
|Phase|Action|
|---|---|
|Composition|Composables are tranformed to a tree of nodes.|
|Layout|Each element in the tree measures its children and places them in the available space.|
|Drawing|The items are drawn to the screen.|

The Layout is made up of three parts:

- Measure children.
- Decide own size.
- Place children, is any.

Think of the layout phase as recursive calls when only return when an item is returned.

In both the drawing and layout phase, the tree is traversed from top to bottom. Meaning the
parent composable are always drawn first.

> Importantly, `Modifiers` are wrappers for layout nodes, meaning a layout node, can have multiple
> Modifier wrappers on top.

### [Constraints and Modifier order](https://www.youtube.com/watch?v=OeC5jMV342A&list=PLWz5rJ2EKKc94tpHND8pW8Qt8ZfT1a4cq&index=4)

From the section above we learned about the three phases of compose. We can relate
this to Modifiers and Modifier order.

During the layout phase, the UI Tree is traversed from top to bottom, the top element has
constraints relating to its size which it passes down to its children. The constraints are
presented as _min_ and _max_ sizes, where size accounts for width and height. The children need
to abide by these constraints. Trick cases involve the following:

- _The child demands a larger size than the parent constraint_: The child will be sized up to
  the largest size available of the parent.
- _The child demands a smaller size than the parent constraint_: The child will be sized down to
  the smallest size available of the parent.

For example:

```kotlin
Box(Modifier.maxSize(200)){
    Text(Modifier.size(300)) // The text will be of size 200
}

Box(Modifier.minSize(50)){
    Text(Modifier.size(20)) // The text will be of size 20
}
```

Going into what might appear to be a more difficult case but it ends up being practically the same:

```kotlin
Box(Modifier.fillMaxSize()
    .size(50)){ // The Box will be of size fillMaxSize
    //... code
    }
```

This is because Modifiers are wrappers for layout nodes. Meaning that they get evaluated
during the layout phase. Since `fillMaxSize` is before `size`, it sets the constraints
which are passed down to size. Since size is smaller than the constraints, it has to match
the minimum constraint, in this case fillMaxSize as it sets the min and max size to match
parent size.

Additionally, it is important to repeat, both the layout phase and drawing phase are performed
from top to bottom. The layout phase just measures the space occupied by the nodes. The drawing phase
performs the drawing. The drawing is done sequentially.

```kotlin
// Layout Phase
Box( //Therefore Box is of size 70.
    Modifier.clip(CircleShape)
    .padding(10) //Adds 20 to the width and 20 to the hight of the constraint
    .size(50)) // Adds 50 to size
    {
    //... code
    }

// Drawing Phase
Box( Modifier.clip(CircleShape) // The 70 area is clipped.
    .padding(10) // Padding is added to the 70 area, on top of the clip.
    .size(50)) // size is defined and code is drawn.
    {
    //... code
    }
```
