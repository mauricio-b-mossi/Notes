### Refresher
I have used HTML for a long time, in this time it has been a lot of memorization and div spamming but nothing else.
In this series I want to ***understand*** HTML, so I can have a strong guide for when I want to come back to 
frontend development.

### Void Elements
> Not all elements follow the pattern of an opening tag, content, and a closing tag. ***Some elements consist of a single
> tag, which is typically used to insert/embed something in the document*** 
Elements used to insert or embed something tend to be void elements, meaning they do not have tag pairs. Even though 
it is not compulsory, void elements are often declared `<tag/>` even though they can also be declared `<tag>`. 

### Attributes
- Attributes are information we add to the HTML tags. Depending on the type of element it exposes certain default attributes.
- Attributes can be boolean attributes, which act just as flags. If mentioned on, else false. 
```html
<p class="attribute"></p>
<a href="https://webstie.com"></a>
<button disabled>This btn is disabled</button>
```

### Escaping
We specify the values of attributes within quotes `""`, even though it is not necessary, it is 
a good practice to avoid bugs. To escape double quotes within attributes use `&quot;` or `'"'`.
```html
<a title="Mike&quot;s website"></a>
<a title="Mike's website"></a>
<a title='Mike"s website'></a>
```
The character for escaping is the ampersand `&`. Reservded icons for HTML are `<` `>` `"` `'` `&`.
To include this characters use `&<name>`.
`>` = `&gt;`
`<` = `&lt;`
`"` = `&quot;`
`'` = `&apos;`
`&` = `&amp;`

### [Anatomy of HTML Document](https://developer.mozilla.org/en-US/docs/Learn/HTML/Introduction_to_HTML/Getting_started#anatomy_of_an_html_document)
I've added a link, it explains the structure of HTML, like `DOCTYPE`, `html`, `head`, `meta`, etc.
- `html`: Root node.
- `head`: Won't show to the viewers, specifies what you want to include.
- `title`: The title of the document.
- `meta`: Extra information not available within head, for example author, description.
use the `name` attribute to specify the type of metadata and `content` for the value. 
- `body`: Contains all the structure of what is displayed to the user.
```html
<!doctype html>
<html lang="en-US">
  <head>
    <meta charset="utf-8" />
    <title>My test page</title>
  </head>
  <body>
    <p>This is my page</p>
  </body>
</html>
```

### JavaScript and CSS
To link a CSS style sheet use the `<link>` tag, specify the type of link with the `rel` attribute, and 
link the file with the `src` attribute.
```html
<link rel="stylesheet" src="mystyles.css"/>
```
To link JavaScript use the `<script>` tag with the `defer` attribute and the `src` to link the file.
Note `<script>` is not a void tag as you can write JavaScript within the tag.
```html
<script defer src="myscript.js"></script>
```
There are several way to load JavaScript, but this is by far the recommended and most reliable way.

### Semantic Elements
Sure you can get away by working just with divs or spans and styling them around to a desired outcome.
However, you should aim for semantic HTML, where each tag gives context to the browser, about the document. This 
is useful for website indexing and for accessibility, as screen readers can pick up on the intention of the tag.

Some examples:
- `h1`: Main header
- `ul`: Unordered list
- `ol`: Ordered list
- `li`: List Item
- `em`: Emphasis, displays as italics and the screen reader picks this up. `<i>` just adds italic styling but its not semantic.
- `strong`: Displays as bold and the screen reader picks this up. `<b>` just adds styling but its not semantic.


### Presentational Elements
These elements should be avoided, they include `<b>`, `<i>`, `<u>`. They provide no semantic
meaning, rather they were used before CSS came out to style text in HTML.

### Links
Links in HTML determine what is shown. You can link local files using the `<link>` tag and 
setting the `src` attribute to the relative location of the file. Relative location follows 
conventions similar to the UNIX file system. 

- `../`: To the parent directory.
- `file.html`: Current directory.
- `/directory/file.html`: File inside directory.

### Document Fragments
Apart from different pages in your file system / website, you can also add links to parts of your document. These are 
known as Document Fragments. To do so, you need to specify an `id` attribute for the Document Fragment you 
want to visit. You can visit both Document Fragments in your current file or in other files. To navigate to the Fragement,
specify the file and then a pound `#` followed by the Document Fragment id: `href="file#fragement"`
```html
<!--index.html-->
<h1 id="here">Where to Navigate</h1>
<a title="Where to Navigate" href="#here">Go to Where to Navigate</a>

<!--info/index.html-->
<a title="Where to Navigate" href="../index.html#here">Go to Where to Navigate</a>
```

### [Advanced Text Formatting](https://developer.mozilla.org/en-US/docs/Learn/HTML/Introduction_to_HTML/Advanced_text_formatting)
- For definitions like dictionaries use: `dl`.
- For references, such as those seen in papers use: `blockquotations`
- For inline quotes use: `q`.
- For abbreviations use `abbr`.
- For address use: `address`.
- For superscript and subscripts use: `sup`, `sub`.
- For code use: `code`.
- To preserve white space use: `pre`.
- For keyboard input use: `kbd`.
- For code output use: `samp`.
- For dates use: `time`, and the `datetime` attribute in it.

### Website structure
As mentioned above, it is good to use Semantic HTML. Therefore, we should also be Semantic about the 
structure of our website. For this use the tags:
- `header`
- `main`
- `article`
- `aside`
- `footer`

### Non-Semantic Wrappers
Important, divs and spans are considered Non-Semantic Wrappers, this means their purpose is not Semantic, but 
rather to target the elements within with JavaScript or CSS. For example applying a style, toggling visibility, etc. 
The difference between divs and spans is that spans are `inline`, while divs are `blocks`.
- `divs`: Take a whole row.
- `spans`: Take only the necessary space.
- `br`: Break line. Enforces everything else to be in next line.
- `hr`: Draws a horizontal rule.

> To check if your HTML is valid use [W3C validation service](https://validator.w3.org/)

