# [Coroutines Overview](https://kotlinlang.org/docs/coroutines-basics.html)

Coroutines lightweight threads that run within threads. A coroutine is not fired (ran) in a
specific Thread, rather it runs on available Threads.

> To view the thread use `Thread.currentThread().name` method.
> When a coroutine suspends, other coroutines
> can use the available resources in the thread.
> Instead of blocking, the coroutine is suspended, allowing other coroutines or tasks to run concurrently.

---

### Coroutine builders

Coroutine builders provide a scope where suspending functions can run. The Coroutine framework provides three
methods to build coroutines:

- `launch`: Launches a coroutine in the _current coroutine scope / parent scope_, fire and forget, suspending function.
- `async`: Launches a coroutine in the _current coroutine scope / parent scope_, returns value, suspending function.
- `runBlocking`: Launches a coroutine and blocks the **Current Thread**, blocking therefore not suspending.

###### launch

Launch is what is known as a fire and forget coroutine, it does not return anything from the scope. However,
it returns a `Job` (this will be handy later).

###### async

Async is used to return a value from the scope of the coroutine in a `Deferred`. A `Deferred` is _subclass_ of `Job`.
To access the value returned from the async coroutine use the `await()` method in the `Deferred` instance.

###### runBlocking

Runs and blocks the current thread, should be avoided in production because it is blocking, goes against the usefulness
of coroutines.

---

### [Jobs](https://kotlinlang.org/api/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines/-job/)

A job is an instance of the `Job` interface, which is part of the Kotlin standard library.
It represents the lifecycle of a coroutine and provides methods and properties to interact
with and control the coroutine's execution.

With the 'Job' instance you will mainly:

- `cancel()` Cancel the coroutine.
- `join()` Wait for the coroutine to finish.
- `isActive` Check if coroutine is active.

_In between other things, for others view [docs](https://kotlinlang.org/api/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines/-job/)_

As mentioned above, `Deferred` is a subclass of `Job` and is returned by the `async` coroutine builder. Additionally,
it contains the `await()` method which gets the return type from the `async` coroutine builder.

---

### Coroutine Cancellation

When a coroutine is running it is **not** listening for cancellations, it is maximizing performance. Therefore, even
though a coroutine is running and from its job you call `cancel()`. The coroutine might not stop.

> In Kotlin coroutines, cancellation is a cooperative mechanism where coroutines are responsible for checking for cancellation and gracefully terminating their execution. Cancellation can be initiated by calling the cancel() function on a coroutine's job or by propagating a cancellation signal through the coroutine hierarchy.

```
fun main () = runBlocking {
    println("Started")
    val job = launch {
        for(i in 0..1_000_000){
            println("$i.")
        }
    }
    delay(50)
    job.cancel()
    println("Ended")
}
```

_In the example above, even though `job.cancel()` is called, the coroutine is still running and prints all the numbers
from 0 to 1,000,000_

> The delay(50) was added because the coroutine takes some time to launch, when it has not launched yet it can be cancelled without major problem.

For the coroutine to listen for cancellations, we need to add a suspending function or something from the coroutine library.
All the following check for cancellations when called:

- `delay()` Checks for cancellation with delay.
- `yield()` Checks for cancellation without delays.
- `isActive` Flag can be accessed from running coroutine.

Other interesting methods of cancellation are timeout coroutine builders:

- `withTimeout()` Cancels after timeout, throws.
- `withTimeoutOrNull()` Cancels after timeout, returns null.

---

### Coroutine Evaluation

By default coroutines are evaluated **sequentially**: this means from top to bottom. Sometimes, this might not be the desired behavior.

```
fun main() = runBlocking{
    measureTimeMillis{
        val returnOne = returnSomething() // This is executed first, continues until value is set.
        val returnTwo = alsoReturnSomething() // This is executed second, continues until value is set.
        println("$returnOne, $returnTwo")
    }.also(::println) // Time is more than 2000ms (2 secs).
}

suspend fun returnSomething(){
    delay(1000)
    ...
}
suspended fun alsoReturnSomething(){
    delay(1000)
    ...
}
```

This should come to no surprise, since the values need to be set, therefore they wait for the return of the suspend function.
There are alternative ways to do the same using the power of coroutines for example:

```
fun main() = runBlocking{

    var returnOne : String? = null;
    var returnTwo : String? = null;

    measureTimeMillis{
        val jobOne = launch{
            delay(1000)
            returnOne = "..."
        }
        val jobTwo = launch{
            delay(1000)
            returnTwo = "..."
        }
        jobOne.join()
        jobTwo.join()
        println("$returnOne, $returnTwo")
    }.also(::prinln) // Time is more than 1000ms (2 secs)
}
```

This works because `launch()` is fire and forget, it does not wait for completion once fired,
unless the `join()` method is called. So both coroutines are launched, and then they are joined.
This is different than in the first example, where first `returnSomething` is called and after it
resolves, `alseReturnSomething` is called and resolved: this is sequential. An even better way of
waiting for values is using `async()` coroutine builder.

> Remember, `launch` is fire and forget, 'async' returns a value from the scope.

```
fun main() = runBlocking{
    measureTimeMillis{
        val defJobOne = async{
            delay(1000)
            "..." // ^ async
        }
        val defJobTwo = async{
            delay(1000)
            "..." // ^ async
        }
        println("$defJobOne.await(), $defJobTwo.await()")
    }.also(::println)
}
```

Here a similar concept to launch applies, `async` launches a coroutine but does not suspend (wait for their completion when called).
The values are only retrieved (which is a blocking operation), in the `println`, when both coroutines have already been launched.

### Coroutine Scope, Context, and Dispatchers.

###### Coroutine Scope

The coroutine scope keeps track of any coroutine you create using `launch()` and `async()`

Each coroutine has its own scope.

```
fun main() = runBlocking{ //this: CoroutineScope
    println("runBlocking: $this") // runBlocking: BlockingCoroutine{Active}@2077d4de

    launch{ //this: CoroutineScope
        println("launch: $this") // launch: StandaloneCoroutine{Active}@51521cc1

        launch{ //this: CoroutineScope
            println("child launch: $this") // child launch: StandaloneCoroutine{Active}@deb6432
        }
    }

    async{
        println("async: $this") // async: DeferredCoroutine{Active}@1b4b977
    }
}
```

> The `CoroutineScope` is represented as the type is represented by its type, isActive, and instance hash.

From the example above we can see that the `CoroutineScope` is unique: Every Coroutine has its own scope.

###### Coroutine Context

Similarly to `CoroutineScope`, each coroutine has a `CoroutineContext`, the difference is that the
`CoroutineContext` can be inherited from the parent scope. The `CoroutineContext` has two main parts:

- `Dispatcher`: Decides in which `Thread` the coroutine is executed.
- `Job`: Enables Control of the Coroutine.
- `CoroutineName`: Not as important, just the name assigned to the coroutine.

To access the `CoroutineContext`, each `CoroutineScope` has an instance variable called `coroutineContext`.

To the `launch()` coroutine builder accepts a `Dispatcher`, it defaults to a `Confined` `Dispatcher`. The following are the available `Dispatchers`:

- `Confined`: Inherits the `Dispatcher` of the parent. Does not change thread once suspended.
- `Default`: Launches a coroutine at the Global level, similar to `GlobalScope`. Can change thread once suspended.
- `Unconfined`: Initially, inherits the `Dispatcher` of the parent. Can change thread once suspended.
