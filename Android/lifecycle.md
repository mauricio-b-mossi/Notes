[Source](https://developer.android.com/codelabs/basic-android-kotlin-compose-activity-lifecycle?continue=https%3A%2F%2Fdeveloper.android.com%2Fcourses%2Fpathways%2Fandroid-basics-compose-unit-4-pathway-1%23codelab-https%3A%2F%2Fdeveloper.android.com%2Fcodelabs%2Fbasic-android-kotlin-compose-activity-lifecycle#6)

## Activity lifecycle

- The activity lifecycle is a set of states through which an activity transitions. The activity lifecycle begins when the Android OS first creates the activity and ends when the OS destroys the activity.
- As the user navigates between activities, and inside and outside of your app, each activity moves between states in the activity lifecycle.
- Each state in the activity lifecycle has a corresponding callback method you can override in your Activity class. The core set of lifecycle methods are: onCreate(), onRestart(), onStart(), onResume(), onPause(), onStop(), onDestroy().
- To add behavior that occurs when your activity transitions into a lifecycle state, override the state's callback method.
- To add skeleton override methods to your classes in Android Studio, select Code > Override Methods... or press Control+O.

## Logging with Log

- The Android logging API, and specifically the Log class, enables you to write short messages that are displayed in the Logcat within Android Studio.
- Use Log.d() to write a debug message. This method takes two arguments: the log tag, typically the name of the class, and the log message, a short string.
- Use the Logcat window in Android Studio to view the system logs, including the messages you write.

## Configuration changes

- A configuration change occurs when the state of the device changes so radically that the easiest way for the system to resolve the change is to destroy and rebuild the activity.
- The most common example of a configuration change is when the user rotates the device from portrait to landscape mode, or from landscape to portrait mode. A configuration change can also occur when the device language changes or a user plugs in a hardware keyboard.
- When a configuration change occurs, Android invokes all the activity lifecycle's shutdown callbacks. Android then restarts the activity from scratch, running all the lifecycle startup callbacks.
- When Android shuts down an app because of a configuration change, it restarts the activity with onCreate().
- To save a value that needs to survive a configuration change, declare its variables with rememberSaveable.tps://developer.android.com/static/codelabs/basic-android-kotlin-training-activity-lifecycle/img/f6b25a71cec4e401.png" alt="lifecycle" style="width:200px;"</img>
