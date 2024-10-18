### Basics
Here is just an overview to get you started with SFML. SFML is really what it's names stands for, "Simple Fast 
Multimedia Library." If you are familiar with `pygame` you might find several similarities with SFML. One benefit
of SFML is that it is modularized. You have several modules that represent different requirements. You have the 
`System`, `Window`, `Graphics`, `Audio`, and `Network` modules. For most of your projects, more than likely, you 
will be using the first three. The cool thing about modules is that you just pay for what you use. However, some modules
construct upon others. For example, `Window` builds on top of `System`, and `Graphics` builds on top of `Window`, which
in turn builds on top of `System`. This means that if you want to draw something, you need to use the first three modules.

As the library is modularized, each module has specific responsibilities. 
- `Window` is where things are drawn and actions captured. ***Events occur on the window and things are drawn on the window.***
Think of a window as an `<canvas>` in HTMl.
- `Graphics` is an API to draw things on the `Window`'s OpenGL surface.

> All SFML is stored under the `sf` namespace. To access things use `sf::RenderWindow`, for example.

The essence of SFML is a window and a game loop. In the game loop you listen to events, update objects, and display.
Similar to canvas and `requestAnimationFrame` you clear the window with `window.clear()` then you draw on the surface with
`window.draw(sf::Shape)`, and then you render with `window.display()`.
