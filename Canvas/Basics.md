### Drawing
First, remember that the `CanvasRenderingContext2D` is an object, meaning it has data and behaviour.
As its behaviour it has all the drawing functions, as data it holds information such as the `fillStyle`
and `strokeStyle`. Meaning once the data is changed, it is remember throughout the lifetime of the application.

Canvas drawing context only knows 2 shapes by default. `Paths` and `Rectangles`.

#### Rectangles
Rectangles are quite simple. You have three functions `storkeRect`, `fillRect`, `clearRect`, each one accepting
the parameters `(x, y, width, height)`.

#### Paths
Paths are more complex. At its most basic a path is just a list of points. To create paths there are three steps:
1. First you crate the path with `beginPath`. 
2. Then you use drawing commands to draw into the path.
3. Lastly, you stoke or fill the path to render it.

> Do not confuse `closePath` as destructor to clean up resources. `closePath` closes the path, it joins the last 
> point of the path to the initial point in the path. It actually closes the path.

The [path API](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D#paths) is extensive, it basically 
consists of drawing functions and rendering functions. Common methods include, `lineTo`, `moveTo`, `fill`, `stoke`. Methods
are also provided to draw bezier curves.

> Drawing methods are applied to the path Buffer of the `CanvasRenderingContext2D`. The buffer is only cleared
> when `beginPath` is called.

Note that methods such as `arc`, add an arc to the current path. It is not the case that `arc` creates, and therefore resets,
the current path. The bottom line is that ***any drawing function other that Rectangles is added to the current path***.
