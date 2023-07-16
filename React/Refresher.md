## React Refresher 
It kind of sucks, in 2021 I used to be a React god, but after going through a Data 
Analysis with Python, Android Development with Kotlin, and some sysadmin with 
PowerShell, I'm back to React would you guess. The aim of this is to get everyone, 
who left React in early 2022, to be proficient once again. I will summarize the main 
points, for me, in the docs, and add links to each section. 

### React and Compose
This section touches on some unexpected behavior you might encounter as a Compose or React dev,
programming for React or Compose respectively. Both platforms are pretty similar. But they have 
some things that might throw you off at first. 

#### Similarities between React and Compose from a high-level.
- React was first, Compose was second. Both are UI libraries for building applications. They are reactive, in 
the sense that both track state, and respond to changes in state. When state changes, those Composables in the 
case of Jetpack Compose, and those Components in the case of React, recompose / re render.

- For React, event though you use JSX you are basically using three: JavaScript, HTML, CSS. However, CSS is optional as you can use 
CSS in JavaScript, but at the end they are just strings, same with libraries like TailwindCSS. What I find incredible
about Jetpack Compose is that everything is in one language: Kotlin. The styling, markup and logic all are done in Kotlin.

- What is interesting about styling in Jetpack Compose, for those familiar with React, is Tailwind-like like: the styles
are defined in-line with the use of `Modifiers`.

Due to the similarities between UI libraries, both share similar concepts in terms of state management:
`useState` and `rememeber{mutableStateOf()}`, `useEffect` and `LaunchEffect`, `useMemo` and `derivedStateOf`.

#### Preserving State, Rendering, and Recomposition.
React and Compose both have behaviors for persisting state. However, they WIDELY differ.
- ***In React, state is held by the postion on the UI tree.*** 
- ***In Compose, state is held by the call site: the position in source*** 

##### React: Persists State by position in UI tree.
To illustrate, in this case:
```javascript
function App() {
  const [toggle, setToggle] = useState(false)
  return (
    <div className="flex flex-col justify-center items-center h-screen bg-red-200">
      <div className="flex justify-between w-96">
        {toggle ? <div><Counter/></div> : <div><Counter/></div>}
        <Counter/>
      </div>
      <button className="bg-green-500 py-2 px-4 rounded-xl text-white" onClick={() => setToggle(e => !e)}>Toggle</button>
      {toggle && <div>Toggled</div>}
    </div>
  );
}

export default App

function Counter(){
  const [counter, setCounter] = useState(0)

  return(
    <div>
      <p>The count is {counter}</p>
      <button className="bg-blue-500 py-1 px-2 rounded-xl text-white text-xs" onClick={() => setCounter(e => e + 1)}>Up the count</button>
    </div>
  )
}
```
In React, the Counter within the conditional `{condition ? <Comp/> : <Comp/>}` will persist even though it is toggled. This is because, the position 
of the `<Counter/>` in the UI tree remains the same.

##### Compose: Persists State by call-site : position in source code.
To illustrate, in this case:
```kotlin
@Composable
fun TestingCompose() {
    Column(
        Modifier.fillMaxSize(),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        var toggle by remember { mutableStateOf(false) }
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            if (toggle) {
                Counter()
            } else {
                Counter()
            }
            Counter()
        }
        Button(onClick = { toggle = !toggle }) {
            Text(text = "Toggle")
        }
    }
}

@Composable
fun Counter() {
    var count by remember {
        mutableStateOf(0)
    }
    Column {
        Text(text = "The count is $count")
        Button(onClick = { count += 1 }) {
            Text(text = "Up the count.")
        }
    }
}
```
In Compose, the Counter within the conditional `if else` will **NOT**  persist
as the call site changes.

###### TLDR in React position within the UI tree is what persists state.
###### TLDR in Compose position in source code is what persists state.

> In my opinion preserving state in Compose is simpler, just by call-site. In React you need to make sure the position in the UI
> remains exacly the same, and Nodes are both Components `<../>` or JSX expressions `{}`.

#### Lambdas and Callbacks in React and Compose
In JSX we use `{}` to write JavaScript within the UI Markup. 
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

#### Default Event Propagation Behavior

Another important fact is that unlike Compose, in React, default event handlers are propagated. To further illustrate,
if I have a button on top of another button in Compose, and Tap the one above, only the `onClick()` callback of the top button 
would be called.
```kotlin
// Compose
Box{
    Button(onClick={Log.d("Event", "Bottom Clicked")}){...}
    Button(onClick={Log.d("Event", "Top Clicked")}){...} // Only Top Clicked would be Logged.
}
```
```html
// React
<span>
    <div onClick={() => console.log("Bottom Clicked")}></div> // Logged
    <div onClick={() => console.log("Top Clicked")}></div> // Logged
</span>
```
To avoid this behavior you need to access the event parameter in JavaScript and call the `stopPropagation()` to as the name 
implies, stop the propagation of the event.

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

- Do not mutate state, this in between several reasons, seen [here](https://react.dev/learn/updating-objects-in-state#why-is-mutating-state-not-recommended-in-react),
is mainly for speed, since react checks whether state is change by comparing objects : `prevObj === currOb`; and if you 
mutate state the reference to the instance remains the same. This also applies for arrays as both are references to objects. 
You can use spread operator to perform a shallow copy of the current state and only change the properties you wish.
```javascript
const [person, setPerson] = useState({
        name : "Mauricio",
        age : 20
    })

function clickHandler(){
        setPerson({
            ...person, // Shallow copies person
            age : 21 // override age, by delaring it after.
            })
    }
```

> One thing to remember, unlike Kotlin, when inside a lambda the return value is not inferred. Therefore, 
when using a block within a lambda you must explicitly return, else the return can be infrared.
```javascript
const list = [1,2,3,4,5]
const listInline = list.map((el) => el * 3) // 3, 6, 9, 12, 15
const listBlock = list.map((el) => {el * 3}) // undefined, undefined, undefined, undefined, undefined
```
Another thing to remember, when using `map()` with indexed, the index is the second parameter, not the first one.
```javascript
const list = [1,2,3,4,5] 
const iList = list.map((e, i) => e * i)
```
```kotlin
  val list = List(5){it * 2}
    val iList = list.mapIndexed{ index, el ->
        index * el
    }
```
And finally, map in JavaScript passes an object, while map in Kotlin passes a pair of parameter for 
mapped index, one for the index and another for the element.

### Managing State
- Try to state hoist, React is similar to Compose, or more correctly, Compose is similar to React, if the 
`setState` function is called with the same value as `state`, the state does not change and no re-render occurs.
- Your UI should react to state. You can test the multiple states of your Component using
“living styleguides” or “storybooks”. These are pages where you display your component with all possible 
states.

#### Preserving and resetting state
This is a super important section. In React, state is persisted by the position of a component in the UI Tree, this is 
in contrast to compose where state is persisted based on the call-site of a Composable. What does this entail for react?
That you can do things like this:
```
{isToggled ? <Counter color={"red"}/> : <Counter color={"blue"}/>}
```
and even though the color changes, the local counter state, assuming there is one, will be preserved.
As the state is set on a `<Counter/>` at postion X in the UI Tree and even though the color changes,
it is still a `<Counter/>` at position X.

Note that a UI Node is represented either by an expression `{}` or a Component. Also not that
the position must be explicitly the same: `div > Counter` != `Fragment > Counter`.
However, a `<Counter/>`  is the same if `div > Counter` == `div > Counter + p`. The UI Node is not 
the same, yet, the position of the `<Counter/>` in the UI Tree is the same.

#### useReducer
useReducer is not fundamental to compose, however it is a nice addition that might help de clutter you 
Component. Use reducer acts like some-what similarly to the `reduce()`, it transforms input into one 
output. The use case of the `useReducer` hook is to be handle state and its handling separate from the Component.
You do so by exposing dispatches. Dispatchers represent an action like send, load, error, and according to those actions 
the reducer returns state.
```
const [state, dispatch] = useReducer(reducer, initialState)

// The state represents the current state, while the action represents the action object coming in via the dispatcher function called form the UI.
function reducer(state, action){
    // type is a convention used, most often it is a string representing the action.
    switch(action.type)
        case "send": {... return newState}
        case "error": {... return newState}
        case "loading": {... return newState}
        default: {throw Error}
}
```
It very closely resembles the ViewModel in terms of Jetpack Compose. You cannot change state directly, rather you call a dispatcher with an event type,
similar to the `onEvent` function used on Android ViewModels. Then the action is handled based on the type. The difference is that Kotlin provides type
safety as you can represent actions as an typed object and check the type of action by the objects type. Usually sealed classed are used for this 
in Kotlin.
```javascript
import { useReducer } from "react";

function App() {
  const [counter, dispatch] = useReducer(counterReducer, 0)
  return (
    <div className="flex flex-col justify-center items-center h-screen bg-red-200">
      <div>The count is {counter}</div>
      <div className="flex">
        <button onClick={() => dispatch({type : "+"})}>+</button>
        <button onClick={() => dispatch({type : "-"})}>-</button>
      </div>
    </div>
  );
}

export default App


function counterReducer(counter, action){
    switch(action.type){
        case "+":{
            console.log(`Counter increased to ${counter + 1}`)
            return counter + 1
        }
        case "-" : {
            console.log(`Counter decrased to ${counter - 1}`)
            return counter - 1
        }
    }
}
```

#### Context, Context.Provider, createContext, and useContext.
Context is useful when you want to hold global information. Instead of prop drilling, you can provide a Context which  
is available to all child Components. Context is inherited, kind of like CSS, where the nearest context represents the 
current context. Even though it might appear tempting to use Context, think on whether you really need it. 
> As a rule of thumb, always pass JSX as children.
To use context you need to:
1. Create the Context.
2. Provide the Context.
3. Retrieve the Context.
To create the context use the `createContext` function from react. Here you declare the reference to the Context and its
initial value.
```javascript
import {createContext} from 'react'
const initialValue = 0
const MyContext = useContext(0)
```
The you provide the Context. The current context is provided to all its children, if its not overridden.
```javascript
import MyContext from './MyContext.js'

export default App(){
    const [state, setState] = useState(0)
    // If value is not overridden, the default value will be used.
    <MyContext.Provider value={state}>
        <Child/>
    </MyContext.Provider>
}
```
To retrieve the Context in a child Component, import the `useContext` hook, and specify which context you want. 
```javascript
import {useContext} from 'react'
import MyContext from './MyContext.js'
export default Child(){
    // Using MyContext.  
    const context = useContext(MyContext)
    return(
        ...
    )
}
```

#### Combining Context and Reducer
Combining Context and Reducer can yield wonderful results. Most of the times this is used if you have some state hoisted
at the top sections of the UI tree, which is accessed by lower UI nodes. The most common solution to the issue above is prop drilling, 
where you pass the state and the callback to access state and modify state. But depending on the problem, Context and 
Reducer might simplify your problem. 

Things to remember:
- Hooks can only be called form the top level of Components.
- If you store objects or arrays in state, they must act as if immutable.
- Custom hooks are functions that start with `use` and allow us to access hooks "outside" a component.

There are several ways we could combine `useReducer` and `useContext`, which depend on your case. However, this implementation, 
is pretty clean, which reminds me to a ViewModel:
```javascript
// TasksProvider.js
import {useReducer, createContext} from 'react'

export default TasksContext = createContext(null)
export default TasksDispatcherContext = createContext(null)

// A Component as only in the top level of Components and Custom Hooks you can access Hooks.
export default TaskProvider({children}){
    const [tasks, dispatcher] = useReducer(taskReducer, initialTasks) 

    return(
       <TasksContext.Provider value={tasks}> 
        <TasksDispatcherContext.Provider value={dispatcher}>
            {children}
        </TasksDispatcherContext.Provider>
       </TasksContext.Provider> 
    )
}

function taskReducer(tasks, action){
    switch(action.type){
        case <expression>:
            return {...}
    }
}

// App.js
import TaskProvider from './TasksProvider.js'

export default function App(){
    return(
        <TasksProvider>
            <...>
        </TasksProvider>
    )
}
```

