### Promises and Asynchronous JavaScript
JavaScript is a single threaded programming language. This means it executes one line at a time.
However, a lot of the code that we run nowadays is asynchronous, meaning it has to wait. Think of 
network requests, event listeners etc. So how does Javascript deal with this even though it is 
single threaded? The key is the environment, be it Node.Js or the browser. The environment provides 
API's form which JavaScript can offload code, to be executed in the background by the environment or to 
be called back. The whole process depends on the event loop, where JavaScript runs a single thread 
that loops when all the JavaScript has been processed to the Queue, where it retrieves operations 
finished by the environment. Most of the time these operations are returned in the form of callbacks, 
which you execute in JavaScript.

> A Promise is a proxy for a value not necessarily known when the promise is created. It allows 
> you to associate handlers with an asynchronous action's eventual success value or failure reason. 
> This lets asynchronous methods return values like synchronous methods: instead of immediately returning 
> the final value, the asynchronous method returns a promise to supply the value at some point in the future.

A promise is just an object returned by an asynchronous function. As mentioned above the object is a proxy for a value
not necessarily known when the promise is created. The promise object can be in three states:
`pending`, `resolved`, `rejected`. Every time an asynchronous function is executed, it immediately
returns a promise in the `pending` state. Once the promise is completed, the promise object calls the `resolve` or
`reject` methods, which update the state of the promise and call the callbacks you provide via the 
`.then()` and `.catch()` methods, which as well return promises and therefore they allow for chaining.

As mentioned above, promises are objects of type `Promise`. The `Promise` object provides static methods, to 
aid with promise execution. 
- `Promise.all([])`: Executes all the asynchronous functions provided and returns an array with the values.
If one function rejects, the whole `Promise.all` rejects. You can access the values of `Promise.all` with the usuals
`.then`, `.catch`.
- `Promise.allSettled`: Executes all the asynchronous functions. Unlike `Promise.all` does not reject, just returns all settled
promises in an array of objects `{status: "...", value; value}`.
- `Promise.race`: Executes all the asynchronous functions. Returns the first promise to settle.

[Promise API](https://javascript.info/promise-api)

### Async Await
Before `then` and `catch` we had callbacks, `async` and `await` are just another layer above this abstraction. Think of 
them as constructions over `then` and `catch` that allow you asynchronous code to look synchronous. The `async` keyword
is used to indicate a function that is asynchronous or contains asynchronous code. Within, and only within `async` functions
can you use the `await` keyword. The `await` keyword waits for the promise to settle and return a value. Hence, the `await` 
keyword blocks. 

> Asynchronous functions ALWAYS return a Promise.

The benefit of `async` and `await` is that it makes code more readable.
```javascript
// With async await.
async function name(){
    try{
        const user = await fetch("www.somesocialmedia/profiles/user");
        console.log(user.name)
    } catch(e){
        console.log(e)
    }
}
// With then and catch
fetch("www.somesocialmedia/profiles/user").then((user) => console.log(user.name)).catch((e) => console.log(e))
```
Another benefit is that you can use plain old `try-catch` with `async-await`.

### Parallel, Sequential, and Concurrent.
Sometimes you might be shooting yourself in the foot with how you write asynchronous code. For example
there is a huge difference between:
```javascript
function resolveHello() {
    return new Promise((res, rej) => {
        setTimeout(() => {
            res("Hello")
        }, 2000)
    })
}

function resolveWorld() {
    return new Promise((res, rej) => {
        setTimeout(() => {
            res("World")
        }, 1000)
    })
}

async sequential(){
    const hello = await resolveHello() // Takes 2s
    const world = await resolveWorld() // THEN Takes 1s
    console.log(hello)
    console.log(world)                 // Total 3s
}

async concurrent(){
    const hello = resolveHello() // Immediately
    const world = resolveWorld() // Immediately
    console.log(await hello)     // Waits for < 2s 
    console.log(await world)     // Already finished executing since takes < 1s
}

function parallel(){
    Promise.all([
    async () => console.log(await resolveHello()),// Logs second.
    async () => console.log(await resolveWorld()) // Logs first.
    ]) 
    // Both are fired "at the same time".
}
```

