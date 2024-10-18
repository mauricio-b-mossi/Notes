### Review
The event loop in Node.js can be quite complex. Even though initially I understood
the concept behind it, there were some subtleties that I overlooked. As an overview,
the event loop is what allows us to run asynchronous code using a single threaded language.
This applies both for the web and for the server. The event loop executes tasks, and it 
executes each one of them to completion, always. Tasks can execute other tasks and so one, but 
as mentioned above the current task is always run to completion. The event loop has an 
order of types of tasks it runs. Each tasks is added to a tasks queue depending on its type. 
For example, there is the Timer queue, I/O queue, check queue, and so on. An important thing to 
not is that per each task run, there is an additional event loop within that runs after 
that task has been completed. This internal event loop has two callbacks named the Microtask 
queue and the NextTick queue. This internal loop is called the "Microtask queue" and the outer loop 
is called the "Macrotask queue". The NextTick queue runs before the Microtask queue. The microtask
queue contains all the promises created in the current task. The event loop can only move 
to the next task on the Macrotask queue when the Microtask queue is empty.

An important difference between the Microtask and the Macrotask queues is that Microtask added by current Microtasks
are executed in the same iteration of the loop, while Macrotasks added by Macrotasks are executed in the next iteration 
of the loop. Hence Macrotasks have the capacity to starve to Main thread.
