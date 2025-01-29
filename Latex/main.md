# The Latex Tutorial to write beautiful docs.

Latex is pretty easy and intuitive. Here are the important parts.

- For most thing to work, `\usepackage{amsfonts, amssymb, amsmath}`. Fonts allows you to use Z, R, etc. Math is for arrays (not those arrays).

- The preamble is everything before `\begin{document}`. Here you configure packages, dates, title, etc. There
exists like mini preambles for some sections in your document, like `\begin{table}`.

- Useful commands, `\vspace{*cm}`, `\pagebreak`.

- Unlike text-mode, in math-mode spaces are **ignored**.

- To invoke math you can either use `$..$`, `$\displaystyle{..}$`, `$$...$$`, or `\[\]`. 
    - `$...$` is for inline expressions, for example `$e^{i\theta} = \cos(\theta) + i\sin(\theta)$`.
    - `$\displaystyle{...}$` is for inline expressions where you want symbols to span the full height, for example `$displaystyle{\int \limits_{1}^{2} x^2}$`.
    - `$$...$$` is for multi line, block, expressions, for example `$$\sum_{n = 0}^{\infty}\frac{1}{n}$$`.
    - `\[\]` serves the same purpose as `$$...$$` but is considered outdated.
Some expressions like summations need to be display block `($$$$)`, reference from HTML, to be displayed properly. This
is because display inline `($$)` just uses as much space as the line it is currently on. Therefore, summation indices
are crammed upwards inline. Bottom line, for big or large expressions make the equation block level.

- The math symbols are pretty intuitive: `\sum` for Sigma, `\pi` for pi, `\beta` for beta.
- To clump expressions we use brackets `{}`, not parenthesis `()`.

- Note, just because you are in a new line does not mean the text will. Leave 1 space in between lines to make paragraphs.
Use `\\` to break to the next line. **This is important, use `\\` to break lines, you will use this in tables**

- Paragraphs are automatically indented, only for the first line.

## White Space
### Horizontal
Inside math-mode, LaTex ignores spaces. To include spaces use `\ `. This equals one space.
- `\quad`: 1em.
- `qquad`: 2em.
- `\hspace{<measurement>}`: Adds space according to measurement.
- `\hfill`: Fills the space between two segments. Think of it as `flex, space-between`.

### Vertical
- `\vspace{<measurement}`: Adds vertical space according to measurement.
- `\vfill`: Fills the space two segments of the same page. Think of `flex-col space-between`.

## New lines, Paragraphs, and indentation
LaTex considers two segments separated by one or more white lines in between as two paragraphs. For line breaks
use `\\`, for example:
```
This is the first paragraph.
This is the second.

This is the first paragraph.\\
This is the second.
```
The first segment won't work as you would expect, both segments would be joined by the compiler. 

Independent of how many white spaces in between two segments, by default LaTex will consider them as two paragraphs with 
one space in between. To add custom sizing you could use `\vspace{<measurement}`.

New paragraphs by default are indented, to remove this, use `\noindent` at the begining of the paragraph.

## Basic Mathematical Notation
### Subscripts and superscripts
- To add a *subscript* use `_` within a mathematical expression. By default LaTex only adds the character proceeding the `_`.
This means `a_12` would result in `(a_1)2`, not what you want. To fix this use `{}` to clump everything together: `a_{12}`.
You can even nest subscripts, but remember to clump accordingly `a_{1_{2_{3}}}`.

- To add a *superscript* use `^`. The same rules apply, you can nest, but you must clump since the group directly following 
the carat is used. By group, I mean character or grouping `{}`.

### Greek Letters
- Use commands, `\<cmd>`, to input Greek letters. Most of the time they are pretty intuitive: `\pi`, `\sigma`. Most have upper
and lower case variations. Just capitalize the command for uppercase version: `$$A = \pi r^{2}`.

### Trigonometry
- Same, use command to input trigonometric function, `y = \sin\theta`, `\theta = \sin^{-1}(\frac{\pi}{2})`.

### Logarithms
- Same, use command to input logarithm, `y = \log_{10} 100 = 2`, `y = ln x`.

### Roots
Roots divert a bit, the single command is `\sqrt[*]{*}`. In this case the `[]` is for the power of the root and `{}` for the item under the radical, `\sqrt{2} = \sqrt{1^2 + 1^2}`, `\sqrt[3]{2^3} = 2`

## Brackets, Tables, and Arrays
### Brackets
Brackets are everything you use to enclose expressions. The common ones are `{}`, `()`, `[]`, `<>`, `||`.
- With the exception of of `{}` and `<>`, to make you brackets the height of your expression use `\left(` and `\right)`. Obviously, with the respective bracket.
- The `{}` is a reserved bracket to represent grouping, therefore it must be escaped like so `\{`.
- The `<>` are greater and less than symbols, the symbol you want is `\langle` and `\rangle`.

Sometimes with derivates at a point, you use the notation `\frac{dy}{dx}|_{x = 0}`. However, if you write it as it,
it seems off. This is because `|` does not span the space, use `\left .` and `\right |` to indicate intent. `\left .`
is a star or annihilator. Since by convention there must always be `\left <bracket>` and `\right <bracket>`.

Some examples, `\left \{ \frac{-y}{\sqrt{x^2+y^2}} \right)`, `\left .\frac{dy}{dx}\right|_{x = 0}`, `\left \langle x, y, z \right \rangle`

### Tabular and Table
To create a basic table, known as a tabular, you must open a tabular section with `\begin{tabular}{*}`. The second argument is flexible and 
it is used to specify the columns of the table. Here are some options:
- `c`,`r`,`l`: Place the item of the `nth` column in the center, right, or left.
- `|`, `||`: Place a pipe, or double pipe, between items in the table.
- `p{xcm, xin, ...}`: Let the `nth` item a paragraph so it wraps. Provide width.

For example the table `{|r||c|c|c|}` will have:
- Four items per row, the first is right justified, and the rest are centered. A double pipe separates the first entry from the second, all other entries are separated by a single pipe.

To fill the table just add the items, **separate items with ampersands `&` and end rows with `\\`**. If you want horizontal lines between
rows use `\hline` after `\\`.

```
\begin{tabular}{|c||c|c|c|}
\hline
$f(x)$&$1$&$2$&$3$\\ \hline
$x + 3$&$4$&$5$&$6$\\ \hline
$x^2 + 3$&$4$&$7$&$12$\\ \hline
\end{tabular}
```
The table above, represent the functions x + 3 and x^2 + 3 with inputs ranging from [1, 3].

For more complicated and customizable tables wrap the tabular in `\begin{table}`. This allows you to center the 
table with `\centering`, add captions with `\caption{*}`, etc. This is similar to the preamble. **Wrapping with, `\begin{table}`
makes the section between table and tabular, like, the preamble.**

### Arrays (require amsmath)
Arrays are used to list equations, where each line is an equation. To make a numbered array use `\begin{align}`. Anything inside the section is in math-mode by default.
For unnumbered arrays use `\begin{align*}`.
```
\begin{align}
\sqrt{x^2 + y^2} &= 1 \\
x^2 + y^2 &= 1^2 \\
x^2 &= 1 - y^2 \\
x &= \sqrt{1 - y^2}
\end{align}
```
The ampersands `(&)` are really important as they align all the `=`. If you do not want to align equal signs, skip this step.

## Lists
To create a list, you must open a list section with `\begin{enumerate}`. Separate each list item with `\item`.
If you want your list to be bulleted use `\begin{itemize}`, for example,
```
\begin{enumerate}
\item 2 eggs
\item $\frac{1}{2}$oz chopped onion.
\item $\frac{1}{4}$oz chopped green pepper.
\end{enumerate}
```
Note, `\item[?]` accepts an, optional, parameter to override the default sequence. If empty removes marker.

You can also nest lists by adding new list sections. The enumeration will be numeric, alphabetic, roman numerals. There are 
several options to configure, for example `\setcounter{*}` to start the counter from a given value. You 
can also change which type of enumeration you start with, alphabetic, roman numerals, etc.

## Text, Fonts, and Justify
### Text
- *italics*: `\textit{italics}`.
- **bold face**: `\textbf{bold face}`.
- SMALL CAPS: `\textsc{small caps}`.
- typewriter: `\texttt{similar to monospaced}`.

### Font size block
By surrounding a section in `\begin{<size>}`, you can change the size of the font for that section. In order of smallest to largest:
`tiny`, `scriptsize`, `small`, `normalsize`, `large`, `Large`, `huge`, `Huge`.

### Justify
To justify content along the main axis, wrap in `\begin{<justify>}}`, where justify can be: `flushleft`, `flushright`, `center`.

### Side Effects
Commands such as the sizing, justify, etc. are applied locally to a section by `\begin{}`. However,
you can apply them to everything that follows by applying them to the current section. Avoid these if possible.

## Document Formatting
### Title
The title includes, `\title{}`, `\author{}`, `\date{\today}`. Input the information, and inside `\begin{document}` call `\maketitle`.
Note, `\today` is a convenience to add today's date.

### Sections, subsections, subsubsections
Use `\section{}`, and the others, to create a section. This sections are nested based on name. By default
they are numbered and are used to generate the table of contents. To remove numbering, use `\section*{}`.

### Table of Contents
The table of contents is generated based on sections. Within document, `\begin{document}`, place
`\tableofcontents`. Note positioning matters, if before `\maketitle`, then the table of contents will
appear before, the converse is true.
