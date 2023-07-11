## Overview of Kotlin Flows

###### [Primer: Lists and Sequences to arrive at Flows.](https://kotlinlang.org/docs/flow.html)

> Unlike collections, sequences do not contain elements, they produce them while iterating.

- `Lists` are executed **horizontally**, meaning all the elements need to go through, say, a
  function to be passed or returned to the next function.
- `Sequences` are executed **vertically**, meaning all the elements do not need to go
  though to be passed to the next function. When the first item is calculated, it is funneled
  to the next function and so on.

> When the processing of an Iterable includes multiple steps, they are executed eagerly: each processing step completes and returns its result – an intermediate collection. The following step executes on this collection. In turn, multi-step processing of sequences is executed lazily when possible: actual computing happens only when the result of the whole processing chain is requested.

```
sequence {
        for (i in 5 downTo 0) {
            Thread.sleep(1000) // To simulate expensive calculation.
            yield(i)
        }
    }.forEach { println("$it : ${System.currentTimeMillis()}") } // Going to print lazily.

buildList {
        for (i in 5 downTo 0) {
            Thread.sleep(1000)
            add(i)
        }
    }.forEach { println("$it : ${System.currentTimeMillis()}") } // Going to print eagerly.
```

### Flows

###### Overview

Even though sequences might appear flow-ish, they block the main thread of execution. Therefore,
we have `Flow`.

```
 GlobalScope.launch {
        flow {
            for (i in 5 downTo 0) {
                delay(1000)
                emit(i)
            }
        }.collect { println("$it : ${System.currentTimeMillis()}") }
    } // Starts printing after 1 sec.

    println("Running") // Prints first.

    List(5) {
        Thread.sleep(1000)
        5 - it
    }.forEach { println("$it : ${System.currentTimeMillis()}") } // Prints after 5 secs.
```

`flow` is a function that returns a `Flow`. The builder block is a `FlowCollector` and contains `suspend` modifier.

> _Flows are cold_. The code inside a flow builder does not run until the flow is _collected_.

This means that for a builder block to run, the flow has to be collected inside a coroutine with the `collect`
method on the `Flow` object.

> The key reason `flow` is not marked with the `suspend` modifier is because it returns quickly.

###### Flow Cancellation

`Flow` cancellation adheres to `coroutine` cancellation. Meaning, the function has to suspend, to be cooperative and cancel.

###### Intermediate Flow Operators

Like `Collection` and `Sequence`, collected Flows can be funneled into intermediate operators like `map`, `filter`. The
only difference between the intermediate operators of `Flow` and `Collection` and `Sequence`
is that `Flow` operators can accept `suspend` functions.

```
suspend fun performRequest(request: Int): String {
    delay(1000) // imitate long-running asynchronous work
    return "response $request"
}

fun main() = runBlocking<Unit> {
    (1..3).asFlow() // a flow of requests
        .map { request -> performRequest(request) }
        .collect { response -> println(response) }
}
```
