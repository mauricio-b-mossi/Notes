### [Services](https://www.vogella.com/tutorials/AndroidServices/article.html)

> context exposes the getSystemService() method.

The Android platform provides and runs predifined system services and every
Android application can use them, given the right permissions. These system
services are usually exposed via a specific `Manager` class. Access to them
can be gained via the `getSystemService()` which accepts as a parameter, either
the name of the service, or the Manager class.

An Android application in addition to consuming the existing Android platform services,
can define and use new services. Defining a custom service allows you to design
responsive applications.
