## Notifications On Android

Notifications on Android can be daunting at first. But, do not worry. There are
some concepts you need to grasp to understand notifications well.

- First, for all notifications you need PERMISSIONS. You need to both, declare the
  permission on the Android Manifest file, and get the permission from the user
  (we will see this later).

- Second, all notifications must belong to a Notification Channel. This is done
  because it allows the user to turn on and off some channels from your application.
  For example, you might have a chat channel and an articles channel, the user might decide
  which to keep on and off.

- You need to construct the notification form the `Notification` or `NotificationCompat` class
  and then send it (`notifiy`).

The importance of the _NotificationManager_:

- What handles Notifications is the `NotificationManager`, with it, you create notification channels,
  get notification channels, send notifications and more. You get the notification Manager through the
  `getSystemService()` method, which accepts either the String for the service (Notification Service) or
  the actual java class you want (Notification::class.java).

---

- [Notification Channels](https://developer.android.com/develop/ui/views/notifications/channels)
- [Create Notification](https://developer.android.com/develop/ui/views/notifications/build-notification)
- [Requesting permission](https://developer.android.com/training/permissions/requesting)
