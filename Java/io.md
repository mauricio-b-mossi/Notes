# Java Io

---

## Streams

A stream is an "ordered sequence of **bytes** of indeterminate length." This
includes both input and output streams.

Input streams read data from some source while output streams write data.

```
Takeaways:
- Streams transmit bytes.
- 1 byte == 8 bits.
```

Java provides several `Stream Classes`, from which the base are `OutputStream`
`InputStream`. The aforementioned classes are abstract.

Any of the data we grab from a stream will be a signed or unsigned byte. This is
important because we can convert bytes to characters. Therefore, we can get and
send messages.

> Some important character sets and their sizes:
> |Charset|Size|
> |-------|----|
> |ASCII|7 bits (128)|
> |Extended ASCII|8 bits (256)|
> |UTF-8|16 bits (143,000)|

> Tip: To convert bits to size: 2<sup>bits</sup>.

### Readers and Writers

- Readers will convert bytes from the underlying stream into chars.
- Writers will convert chars back into bytes then put those values into the underlying
  stream.

## [OutputStream](https://docs.oracle.com/javase/8/docs/api/java/io/OutputStream.html)

`OutputStream` abstract class provides the methods:

- `write`: Adds to the stream.
- `flush`: Sends the stream.
- `close`: Closes the stream, close the stream when you are no longer going to write to it.

## [InputStream](https://docs.oracle.com/javase/8/docs/api/java/io/InputStream.html)

`InputStream` abstract class provides the several methods, much more than `OutputStream`.
The basics are:

- `read`: Reads one byte of input.

```java
// Basic Scanner implementation.
int read;
while(true){
    read = System.in.read();
    // 10 is ASCII for ENTER.
    if(read == 10) break;
    System.out.write(read);
}
System.out.flush();
```

| Important ASCII | Number |
| --------------- | ------ |
| EOF             | -1     |
| Enter           | 10     |

```kotlin
try {
    // FileInputStream is a subclassInpuInputStream.
    InputStream oFile = new FileInputStream("booty.txt");
    int read;
    while (true){
        read = oFile.read();
        // Read until EOF.
        if (read == -1) break;
        System.out.write(read);
    }
    System.out.flush();
} catch (IOException e) {
    throw new RuntimeException(e);
}
```

An alternative to looping and checking for EOF as above is to use the `FileInputStream`
`available` method which returns the number of bytes in the file.

```java
try {
    FileInputStream mFile = new FileInputStream("booty.txt");
    byte[]data = new byte[mFile.available()];
    mFile.read(data);
    for (short i = 0; i < data.length; i++){
        System.out.write(data[i]);
    }
    System.out.flush();
} catch (IOException e) {
    throw new RuntimeException(e);
}
```
