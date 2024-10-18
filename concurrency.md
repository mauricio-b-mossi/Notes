Concurrency refers to tasks running in an overlapping manner, which doesn't necessarily mean at the same time—it could involve tasks taking turns. Parallelism means tasks are running simultaneously, which requires multiple cores. Pseudoparallelism is the appearance of parallelism, achieved by the operating system's scheduler rapidly switching between processes on a single processor, creating the illusion that they're running at the same time.

Both parallelism (true simultaneous execution via multiprocessing) and pseudoparallelism (multitasking via time-slicing) are subsets of concurrency because, in both cases, tasks overlap in execution.

Asynchronous programming, often loosely defined, typically means handling blocking operations in a non-blocking way. In Node.js, for example, synchronous code waits for a task like disk reading to finish before continuing, blocking the main thread. Asynchronous methods, however, set a callback to continue execution after the disk read completes, allowing other code to run in the meantime. If code depends on the result of an asynchronous operation, await can be used to wait for the result.

In Node.js, we can also schedule expensive tasks to run when the main program stack is empty, avoiding blocking essential code. For example, a long-running task can be broken into chunks using setTimeout, ensuring the main thread remains free for other tasks while the computation progresses, like traffic control on a busy two-way road where one lane is periodically stopped to allow the other to move."

This revised version tightens up the technical explanations and improves readability while keeping the essential concepts intact.

This example by Miguel Grinberg is perfect at describing the concept of asynchronous execution.
```
Chess master Judit Polgár hosts a chess exhibition in which she plays multiple amateur players. She has two ways of conducting the exhibition: synchronously and asynchronously.

Assumptions:

24 opponents
Judit makes each chess move in 5 seconds
Opponents each take 55 seconds to make a move
Games average 30 pair-moves (60 moves total)
Synchronous version: Judit plays one game at a time, never two at the same time, until the game is complete. Each game takes (55 + 5) * 30 == 1800 seconds, or 30 minutes. The entire exhibition takes 24 * 30 == 720 minutes, or 12 hours.

Asynchronous version: Judit moves from table to table, making one move at each table. She leaves the table and lets the opponent make their next move during the wait time. One move on all 24 games takes Judit 24 * 5 == 120 seconds, or 2 minutes. The entire exhibition is now cut down to 120 * 30 == 3600 seconds, or just 1 hour.```
