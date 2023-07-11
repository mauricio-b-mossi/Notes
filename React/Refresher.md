**Sun 07/09/2023** 
## React Refresher 
It kind of sucks, in 2021 I used to be a React god, but after going through a Data 
Analysis with Python, Android Development with Kotlin, and some sysadmin with 
PowerShell, I'm back to React would you guess. The aim of this is to get everyone, 
who left React in early 2022, to be proficient once again. I will summarize the main 
points, for me, in the docs, and add links to each section. 

Something to remember: In JSX we use `{}` to write JavaScript within the UI Markup. 
This might lead to move confusion for Kotlin, Jetpack Compose devs.
```javascript
// Way to do it.
<div onClick={() => console.log("Did something")}>...</div>
// NOT wat to do it.
<div onClick={console.log("Did something")}>...</div>
```
```kotlin
Button(onClick={println("Did Something")}){
    ...
}
```

This is because is Kotlin `{}` is used for lambdas with one or no params, if the lambda 
had a more than one params you could destructure the params `(arg, arg2) -> ...`. However,
in React, `{}` opens the door to JavaScript so doing this
```javascript
<div onClick={console.log("Did something")}>...</div>
```
Is the equivalent of doing this.
```kotlin
Button(onClick=println("Did Something")){
    ...
}
```

Which is not the intended behavior. Because for callbacks you pass function instances.
You do not pass the result of the function, that would be dumb.

### Basics
#### Keypoints:
- Props object is the only parameter of a Component.
- Nested Components are passed to parent as `props.children`.
- Pass function instances to callbacks not function results.
- JSX opens a portal for JavaScript in Markup, all JS in HTML must be an expression. 
- Hooks are declared at top level.
___
- In modern React almost no one is using class components, everything is functional. 
Components are made up of functions that return JSX. 
- Class attributes for HTML are "replaced" by `className`, the reason? In JavaScript
class is a keyword.
- Props, you pass arguments to components as props. You can even 
pass funcitons / components to other components. You can nest, Components within 
another component's tag (`<tag>`) and access it in the wrapper component as child.
However, remember props are passed down as an object, destructure it in the receiver.
To be more specific, the only paramter a Component has is a prop object. The prop 
object always contais a special property called children, this represents Component, 
within the tags of the parent.
```javascript
function Parent(){
    return(
        <Component prop1={"prop1"} prop2={"prop2"}>
            // The div is sent to the component as `props.children`
            <div>I'm a children</div>
        </Component>
    )
}
function Component({prop1, prop2, children}){...}
```
- To write "JavaScript" inside HTML, wrap your code in curly brackets 
`{}`. However, this is not exactly JavaScript, it is JSX. Therefore, it has 
some limitations, for example you can not use if and else, inside the HTML, 
prefer ternary operator `?:` and logical and expression `&&`. In the same page, 
you cannot write a "regular" for loop within JSX. Prefer map, and remember to use keys.
This is because, everything within JSX needs to be an expression: if else is
a statement, it does not return anything, everything that returns a value is an 
expression. The keys in maps help JSX identity components that have changed 
and need to be re-rendered.
```javascript
// Valid JavaScript
export default function Component(name: string, friends: string[]) {
    return (
        // Required JSX
        <>
            <h1>{name != "" ? name : "no name provided"}</hi>
            {friends.map(name =>
                <h1>{name}</h1>
            )}
        </>
    )
}
```
- Responding to events is crucial, this is done in the form of callbacks. Pass a function
instance to the callback, not the function call, this is because the callback, calls the function.
```html
// Do this.
<button onClick={func}>
    Click me
</button>
// Do not do this.
<button onClick={func()}>
    Click me
</button>
```
- Reactivity is achieved through observing state. `useState` is a React hook that
returns an observable and the setter function, usually named `[state, setState]`, 
where state represents which state it represents, this is a convention, not a rule.
Every time the state is updated via `setState(<new-state>)`, all uses `state` ***react***,
to the change and display the new data. This reactivity comes in handy as reacting to 
state is crucial.
- **Hooks**  are functions stating with the prefix `use`. They are more restrictive than 
other functions: can only be called from the top of your component or other hooks.
- State hoisting is the practice of putting shared state at the minimum level to which all 
consumers of the state con use it. In React we pass the state to props, and alter the state 
through callbacks. It is considered a bad practice to change state from a child component, 
prefer to pass a callback to the parent state holder so it can perform the change.
```javascript
import {useState} from 'react';

function Calculator(){
    const [value, setValue] = useState(0)
    return(
        <Button(value)/>
    )
}
function Button(state : number, onValueChange : ((value : number) => void)){
    return(
    <button onClick={onValueChange(value + 1)}>
        {value}
    </button>
    ) 
}
```

### Adding interactivity
#### Keypoints:
- Trigger, re-render, commit. That is the component lifecycle in react.
- `setState` triggers a re-render and remembers the new set state.
- The UI is a snapshot in time, state variables within a snapshot are constant.
- React waits until all code in the event handlers has run before processing state updates.
- No identifier is passed to `useState` as React tracks call site of `useState`.
- When state is changed multiple times within a block. React adds the state changes to a queue,
which evaluates after the block finishes execution.
___
- `useState` is used to remember state in you application. Why not just use a `let` 
to hold state? For this you need to understand how rendering in React works, you'll
find surprising how similar to Jetpack Compose this is.
> Intersetingly, state in React, to simplify, are just arrays. Ask your self, how
> does React know which state we refer to with `useState` is we do not use an id?
> The answer is the call site, this is because, when React renders it fills up a 
> tree, consequently, as it fills the tree it fills an array with the state.
> This also explains why hooks can only be declared at the top level. Because JSX, 
> or code within the composition, will not follow the same call site order.
> [Read more.](https://react.dev/learn/state-a-components-memory#how-does-react-know-which-state-to-return)
> [And more.](https://medium.com/@ryardley/react-hooks-not-magic-just-arrays-cd4f1857236e)

- Render and Commit: Rendering, similar to recomposition for Compose folks, is crucial 
to understand React behavior. Rendering has three faces, trigger, render, commit. There 
are two scenarios where a component needs to render: initial render, and re-render
(respond to state change).
> The initial render is triggered via calling the render method on an instance 
> of `createRoot`.

Remember from `useState` that the setter function `set<...>` triggers a re-render, while
first remembering the state. When react performs the initial render it renders the root Component, and its 
children recursively. Since state is known from its call site, when a re-render is triggered
the Components that own the call site and its children who consume the state are re-rendered, ***if the 
state changes.*** This is a hint to the virtual DOM. React compares the virtual DOM, 
with the current DOM and only commits (publishes) the things that have changed. 
After the commit has been made, the browser will repaint the screen, and that is how 
you, the client, view changes to the screen.
> Note the similarities between React and Compose's Composition, Layout, Draw.

- Rendering, a Snapshot in time: What we see in our UI in React is not truly reactive 
per se, rather it is a Snapshot in time. To better understand, when we set a state, this 
queues a new render, and accordingly, React re-renders the component according to the 
new remembered state.
> Rendering means that React is calling you component, which is a function. The JSX 
you return from that function is like a snapshot of the UI in time. Its props, event 
handlers, and local variables were all calculating using its state at the time of render.

State in react is not scoped to the function, rather state is part of React, it is held 
at the top level. As mentioned previously, and to keep it simple, in an array at the top 
level.

The idea of rendering as a Snapshot in state is crucial for cases as follows:
```javascript
import {useState, useEffect} from 'react' 

function App(){

    const [counter, setCounter] = useState(0);

    useEffect(() => console.log("Rendering"), [counter])

    function handleClick(){
        setCounter(counter + 1)
        console.log(`setCounter(${counter})`)
    }
    <div onClick={()=>{
        handleClick() 
        handleClick()
        handleClick()
        }}>...</div>

/*
When onClick is called it runs the callback. Each callback DOES NOT queue a re-render.
This is because React waits until all code in the event handlers has run before processing
your state updates.Even though three renders have been queued, only one render executes because 
the values used for the three renders are the same since during the current snapshot
counter remains with the value of 0.
*/

/* OUTPUT:
Rendering
setCounter(0)
setCounter(0)
setCounter(0)
Rendering
*/

```

> ***React waits until all code in the event handlers has run before processing your state updates*** .

As a tip, to better think of state as a snapshot in time. Mentally, substitute calls 
to state with the value of the current state. Remember a state variable's value never 
changes within a render, and that React keeps state values "fixed" within one render's 
event handlers. This means that when an event handler gets called it has the values, 
of the snapshot it was called in.

- [Updater function](https://react.dev/learn/queueing-a-series-of-state-updates): Sometimes, albeit rarely, if you want to update a state variable 
multiple times before the next render, you can access the current state with the lambda
`setState(n => n + 1)`, where, in this case, n represents the current state. Under the hood,
what this lambda syntax does is queue the lambda.

|queued update|n|returns|
|---|---|---|
|n => n + 1	|0|	0 + 1 = 1|
|n => n + 1	|1|	1 + 1 = 2|
|n => n + 1	|2|	2 + 1 = 3|

> This `setState` queue causes some interesting behavior to be aware of. As a rule of thumb,
> when within a block, the state is changed multiple times, all the state changes are added to a
> queue, which executes / is evaluated after the block finishes execution.
