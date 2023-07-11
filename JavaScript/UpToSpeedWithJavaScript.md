### Up to Speed with JavaScript
Here is mostly everything you need to know before hopping back into the weird 
world of JavaScript. Some of the common issues encountered by developers while 
using JavaScript is related to its internals. The language is quite simple, with its 
fair share of oddities. But to understand JavaScript well you need to be aware of 
the event loop. JavaScript is a single threaded, asynchronous programming language.
This at first might appear strange,  how can a language be both asynchronous and 
single threaded? This was my main confusion coming from languages like Java and Kotlin
where the one could handle asynchronous code with threads and coroutines respectively.
Here is where the importance of the event loop comes in.

> Note, the event loop is not JavaScript per se, rather it is a feature of the JavaScript's runtime.

### Important Things to know
- Just like Java and Kotlin, JavaScript is always pass by value. It is important to 
remember that variables holding instances of objects hold the reference to the object. 
Therefore, when the instance is passed as an argument, the value of the reference of the 
instance is passed. This allows to modify the instance form the function.
- Not everything is an object, contains primitives: `string` , `number` , `bigint` , `boolean` , `symbol` , `null` and `undefined`

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
Do not things that the button would flicker from red to white and from white to blue. 
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









