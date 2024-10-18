### Modules
I've always been confused with modules in JavaScript. I remember that there are two 
types of modules - one for the browser, and another for the server. In the server, more 
specifically Node.js, we use the ***CommonJs or CJS***, and in the browser we use ***ESModules or MJS***.
ESModules uses the familiar `import` `export` keywords, while CommonJs uses `require` and 
`module.export`. The reason why we have both CommonJs and ESModules is due to the separate 
development and needs of the server and browser JavaScript.

> So which should I use? Broser? ESModules. Server? *CommonJs.

Recently there have been efforts to just use one, CommonJs. To use CommonJs in Node.js use the 
`--experimental-modules` flag and use the `.mjs` extension for your module files.

> If you are using modules in the browser, make sure to use the `type="modules"` attribute on the `<script>` tag.

#### Browser before modules.
Something really interesting that I did not know until recently is how `<script>` tags work.
I thought that under the hood, they were similar to `#include` in C++, as scripts declared last can 
access the variables of scripts declared above.

```html
<head>
    ...
    <script src="upper.js"></script>
    <!-- lower.js can access variables form upper.js -->
    <script src="lower.js"></script>
    ...
</head>
```
This ocurrs because the JavaScript code is actually executed. Variables declared in the global scope with `var` or without a variable declaration keyword,
are stored in the `window` object and therefore accessible, for example, from the console. On the other hand,
variables declared with `let` and `const` are available in the global scope but not stored in the `window` object. Since 
they are all stored in the global scope, they can be accessed form different script files.

[link](https://www.digitalocean.com/community/tutorials/understanding-modules-and-import-and-export-statements-in-javascript)
