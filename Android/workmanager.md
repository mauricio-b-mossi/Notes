### WorkManager

In `WorkManager` there are two main classses the `Worker` class,
where we define the work we want to perform in the background.

We have to extend the Worker class and override the `doWork()` method, which
returns a Result. The Result, depending on its state, returns some Data, which
can be constructed using workDataOf
