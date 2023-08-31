***Tue 07/11/2023*** 

Use [mdn web docs](https://developer.mozilla.org/en-US/docs/Web/JavaScript) as your
guide for everything JavaScript.
___
### Up to Speed with JavaScript
Here is mostly everything you need to know before hopping back into the weird 
world of JavaScript. Some of the common issues encountered by developers while 
using JavaScript its not JavaScript itself, but its runtime. The language is quite simple, with its 
fair share of oddities. But the runtime is more complex, it allows JavaScript perform 
asynchronous operation with the help of Web APIs or the system kernel. 
JavaScript the language cannot do this as it is a single threaded, synchronous programming language.

So the question is how can JavaScript run asynchronous code if it is single threaded? The 
answer is that it can't. It needs to rely on the runtime for concurrency, more specifically the event loop.

This was my main confusion coming from languages like Java and Kotlin
where the one could handle asynchronous code with threads and coroutines respectively.

> Note, the event loop is not JavaScript per se, rather it is a feature of the JavaScript's runtime.

### Important Things to know
- Just like Java and Kotlin, JavaScript is always pass by value. It is important to 
remember that variables holding instances of objects hold the reference to the object. 
Therefore, when the instance is passed as an argument, the value of the reference of the 
instance is passed. This allows to modify the instance form the function.
- Not everything is an object, contains primitives: `string` , `number` , `bigint` , `boolean` , `symbol` , `null` and `undefined`
- Just like Kotlin, functions are first class citizens: can be passed around.

### Event Loop
As mentioned above, JavaScript is single threaded and asynchronous, and it achieves this 
because of the event loop. To understand the event loop you need first understand stacks 
and queues, which is quite simple.
<p align="center">
<img src="https://developer.mozilla.org/en-US/docs/Web/JavaScript/Event_loop/the_javascript_runtime_environment_example.svg" alt="Event Loop">
</p>

JavaScript runs a loop, on which it performs everything on the call stack, once the call stack
is empty it checks the queue, and performs the operation in the queue. If no operation is in the 
call stack due to the queue, it performs the next item in the queue. If this adds to the call stack
it performs everything in the call stack and once empty it checks again the queue.

Basically, the queue is run only when the stack is empty. The main mechanism by which things
are added to the queue are callbacks and Promises called by native code or in the case of the browser web 
APIs. For example, when we call `fetch` we are using a web API, which returns a `Promise`. When the fetch 
is completed by the Web API, the callbacks are added to the queue, and run when the stack is empty.  Another 
common function of the Web API is `setTimeout` which after `x` amount of time queues the callback function. As 
mentioned previously, the queue only runs when the call stack is empty, therefore ***`setTimeout` does not 
represent the time to execution rather it represents the minimum time to execution.*** 

```javascript
// From the mdn web docs.
(() => {
  console.log("this is the start");

  setTimeout(() => {
    console.log("Callback 1: this is a msg from call back");
  }); // has a default time value of 0

  console.log("this is just a message");

  setTimeout(() => {
    console.log("Callback 2: this is a msg from call back");
  }, 0);

  console.log("this is the end");
})();

// "this is the start"
// "this is just a message"
// "this is the end"
// "Callback 1: this is a msg from call back"
// "Callback 2: this is a msg from call back"
```

> Can I run a for loop asynchronously? No, because JavaScript is single threaded. Remember, asynchronous code is
> run by either native code or Web APIs, which later push the code to the queue for further operation. You could
> in turn use Web APIs to push code to the queue and run the loop that way. 

### Runtime
JavaScript usually was run in the browser, but with Node it can also be run in the servers. 
Browsers and Servers have different behaviors and priorities therefore the way the event loop 
is implemented differs based on the runtime. However, the concepts are fairly similar.

#### In the browser
In the browser the loop has to give an "extra turn", instead of extra turn, think of an extra task added
to the queue by the browser, this is the rendering.
Rendering is composed of four steps that are run in order:
1. `requestAnimationFrame`: Callback.
2. Styles: Adding styles.
3. Layout: Laying out nodes in DOM.
4. Paint: Everything is drawn in the screen.
The browser, depending on the screen's refresh rate and state changes, adds the render 
task to the queue. Remember that the queue is only ran when the call stack is empty. Therefore, 
if the call stack is full the screen will not re render.
 
> TLDR: The browser adds an extra task to the queue, which is rendering. Importantly,
> rendering is composed of 4 sequential operations: `requestAnimationFrame`, styles, 
> `layout`, and `paint`.

It is important to recognize batching and how it works relating to rendering. Remember, 
rendering is a task, and that call stack runs before rendering. So if I use the following 
code:
```javascript
const button = document.querySelector("#mySuperButton")
button.style.backgroundColor = "red"
button.style.backgroundColor = "white"
button.style.backgroundColor = "blue"
```
Do not think that the button would flicker from red to white and from white to blue. 
This does not happen because all the JavaScript is run, after which the call stack is cleared
and then the render step can be performed. The render step in this case gets that the button is 
blue so it paints it accordingly.

If for whatever reason you wanted things to flash and flicker, you could add them to the 
queue, with Web APIs such as `setTimeout`:

```javascript
const button = document.querySelector("#mySuperButton")
setTimeout(() => button.style.backgroundColor = "red", 0) // Adding to queue
setTimeout(() => button.style.backgroundColor = "white", 0) // Adding to queue
setTimeout(() => button.style.backgroundColor = "blue", 0) // Adding to queue
```

#### Server
No need to summarize, [Node.js](https://nodejs.org/en/docs/guides/event-loop-timers-and-nexttick#what-is-the-event-loop)
states it perfectly. 
> The event loop is what allows Node.js to perform non-blocking I/O operations - despite 
> the fact that JavaScript is single-threaded - by offloading operations to the ***system kernel***  
> whenever possible.
>
> Since most modern kernels are multi-threaded, they can handle multiple operations
> executing in the background. When one of these operations completes, the kernel
> tells Node.js so that the appropriate callback may be added to the [poll] queue to 
> eventually be executed.

> TLDR Node.js since it does not have access to Web APIs to perform asynchronous code
> delegates asynchronous code to the system kernel which once finished adds the callback
> to the queue.

#### Ending Example
This example is the reason it all started. I though I new JavaScript decently well after using it to build
scripts, frontends, backends, mobile apps, but I was wrong. I never truly understood it, therefore this code 
snippet tripped me up.

```javascript
async function handleClick() {
    setPending(pending + 1);
    await delay(3000);
    setPending(pending => pending - 1);
    setCompleted(completed => completed + 1);
}

function delay(ms) {
  return new Promise(resolve => {
    setTimeout(resolve, ms);
  });
}
```

The reason it tripped me up is that I did not understand how this caused the state
in React to update, and then after the `setTimeout` to re-update. I though React
batched code blocks (which it does). I did not know what to expect, but I defenelty did not expect
the code to update pending and after x amount of time decrease pending and increase 
completed.  

So the question... how does this code works, first we have to remember the Event Loop.
In this case, when the button is clicked, the browser pushed the `onClick` callback to the queue.
The event loop, when the call stack is empty goes to the queue, and pushes the `onClick` callback to the call stack
to execute. It executes the code sequentially, it even enters the Promise, as the promise 
is run synchronously, but once it reaches the `setTimeout` is delegates the timeout to the Web APIs. The code 
beneath the `await delay(3000)` is not called because the `await` waits for the execution to finish, or put 
simply queues a callback, to call the rest of the funciton when delay is fulfilled. Basically this:
```javascript
async function handleClick() {
    setPending(pending + 1);
    await delay(3000);
    setPending(pending => pending - 1);
    setCompleted(completed => completed + 1);
}
```
Can be seen as this:
```javascript
async function handleClick() {
    setPending(pending + 1);
    delay(3000).then(() => {
        setPending(pending => pending - 1);
        setCompleted(completed => completed + 1);
    })
}
```
The handleClick block finishes, a callback is set for the completion of delay, the render loop is called, the `setTimeout` is fulfilled,
it sets the `then()` callback in the queue, when the call stack is empty, it runs the queue entry and updates state.

> One important thing to remember is that the Promise is ran ***synchronously***,  
> but the callback (then, code after await) is called when the promise is settled and the callstack is empty.
> This callback is always done asynchronously.
