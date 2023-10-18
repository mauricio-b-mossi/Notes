### Here is my Canvas Refresher
This is my n<sup>th</sup> time learning HTML canvas. I learned first at the beginning 
of the summer of my freshman year in college, did some cool mathematical animations like 
vector fields and planetary motion but forgot it all. What follows is a concise explanation
about the essentials of canvas drawings and animations. I also go into some conventions and 
ways to organize your code.

For starters here is a brief summary of things you should know:
- Event listeners: Remember the event loop, it will be handy. When you animate or place event listeners
you need to be aware of ***event loop***, ***batching***, `requestAnimationFrame`, etc.
You should know that the browser has a certain interval on which it refreshes, say 60 times per second, or 
60 hertz in for all those physic savvy. By using `requestAnimationFrame` you ensure that the animation
callback is called when the physical monitor can update, because what is the point of calling an animation
function when the main limitation is your screen. In terms of the event loop, think of callbacks such as `addEventListener`,
and `requestAnimationFrame` in opposite sides of the loop. `requestAnimationFrame` lies next to the rendering steps which are
styling, measurement, layout and draw (note for future me, this reminds me of Jetpack Compose). In regards to callbacks and function
that need to be executed in the event loop, they are batched. This means that if I have code, for example, like this:
```javascript
document.addEventListener("click"){
    red_box.style.color = "red"
    red_box.style.display = "none"
}
```
It is not going to flash. Why you might ask? The answer is ***batching***, the script is run and after it is completely run it 
goes, if determined by the browser, to the refresh step if something needs to be refreshed.

> Things to remember, callbacks, better called tasks such as `addEventListener` and events, are
> can be processed more often than `requestAnimationFrame`; `requestAnimationFrame` is called when the 
> screen can refresh; `requestAnimationFrame` runs before the drawing, styling, measuring, and drawing are performed.

As a summary you can watch this great [talk](https://youtu.be/cCOL7MC4Pl0).

- Object Oriented JavaScript: This is not necessary but it is pretty useful. Classes are just syntactic sugar
added to JavaScript to make it easier to work with, or abstract away, prototypal inheritance. Some distinct features
about classes in JavaScript are:
1) Use of `constructor` function to construct object, `this.property` initializes the property. The property can be 
defined above, however in since in JavaScript, like Python you can add properties dynamically so doing `let age` and then 
initializing it is the same as just doing `this.age`.
2) Use `this` to access properties within to object.

- The DOM: You will use the `window` object and `EventListener`s the most. So know them well. The `window` is an API
to the current browser window, where everything is draw. There are several ways to use event listeners, they are attached
to objects on the DOM such as the `window.onload` or `canvas.addEventListener`.

### Into Canvas
First and foremost you need a `canvas` element. The `canvas` is just the drawing board, what 
draws on the canvas is the canvas context, you can access the context through the `getContext` method
available on the `canvas` object. This method returns a `CanvasRenderingContext2D` object if you pass to 
it the parameter `"2d"`, or a 'WebGLRenderingContext' if you pass to it the parameter `"webgl"`. We will mostly
use ***2d*** context, as the name implies, this context draws in 2d - if you are clever enough you can 
draw in 3d using 2d context, hint linear algebra.

For some resets, on the `canvas` you can set its size equal to the maximum window size and remove the default padding and margin:
```html
<style>
    *{
        margin:0;
        padding: 0;
    }
</style>
<script>
const canvas = querySelector("canvas");
canvas.height = window.innerHeight;
canvas.width = window.innerWidth;
</script>
```

> The coordinate system of the canvas, starts from the top-left corner. Counter to what you might 
> be used to `y+` is down. Basically `x+` is to the right and `y+` is down.

Since you draw using the `CanvasRenderingContext2D`, you can view its drawing methods, but what follows is a quick summary of some methods 
and properties. The default context has a `fillStyle()` of black, this property determines the color when you call the 
`fill` method. Some methods such as `fillRect()` allow you to both declare the shape and where to draw it at the same time,
hint in the name prefix `fill`. Other shapes such as lines and circles first need to be declared and then you decide what to do with them.
These shapes are called paths. The overview is that you declare a path and then you either draw its outline with `stroke` or
fill it with `fill()`. An important thing is that you need to both, preferably, begin the path with the `beginPath()` method and close the path
with the `closePath()`. You move to a point using the `moveTo()` method, think of this as lifting your drawing pen to a point. Then from that point
you determine where to draw, for example a path, with `lineTo()`. To draw a circle use the `arc()` method. 
You can set the stroke color, in the same matter you do with the fill color, just change 
the value of the `stroke` property.

Both methods that directly draw shapes, usually, come bundle with a pair of first parameters that represent
the coordinates of the shape. For example the first parameters of `fillRect(x, y, w, h)` and `arc(x, y, rad, angle`<sub>o</sub>`, angle`<sub>f</sub>`)`

### Animations
Animations can be done several ways. At its core you rely on callbacks. `requestAnimationFrame` is used to determine what will be drawn on the frame.
As mentioned above, it is called depending on the screen of the user. `requestAnimationFrame` is a callback that calls a function that animates. Usually 
this will look something like this:
```javascript
function animate(){
    ctx.clearRect(0, 0, window.innerWidth, window.innerHeight);
    obj.animate();
    requestAnimationFrame(animate);
}
```
