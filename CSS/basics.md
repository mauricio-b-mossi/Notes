### The box model
All elements are represented as boxes. Each box is made up of 4 components. The content,
padding, border, and margin. When you set the `width` of an element, you are setting the 
`width` of the content box. Sometimes this is undesirable since the actual size of the box
is not the `width` but rather the `width + padding + boder`. To change this set `box-sizing: border-box`.
The name is key, here the size of the box is bounded by the `border`, hence `border-box`. The
default, or more properly `initial`, value of any box is `content-box`, where the size of the
box is bounded by the content, anything else is additional. No approach is better or worse, it 
is a matter of preference.

> `content-box` is the original box model, where sizing refers to the content box.
> `border-box` is the alternative box model, where sizing refers to the visible box (content, padding, border).

More on the box model, the box "physically" is everything *but* the margin. The margin
is just the spacing with respect to its neighbors, in theory. Sometimes collapsing margins
might result in strange results. Strange only if you don't understand margins properly.

### Collapsing margins
Collapsing margins are unique to `block` elements, we will be more specific about this latter. In short,
*only vertical margins collapse*. The rules are quite simple, but have dire consequences:
- if the parent box's margin-top or margin-bottom is aligned with the respective margin of the child, the margins will collapse.
- if two sibling vertical boxes have adjacent margins, they will collapse.
- if an element has no content, its margins will collapse.

But how do the margins collapse?
- if both margins are positive, margins collapse to the largest margin. So a two `<p>` tags vertically
adjacent, with `margin: 50px` will collapse to a single margin of `50px` between them.
- if one if negative, margins collapse to the largest, minus the negative margin. So a `<p>` with `margin: 50px`
and a `<p>` with `margin: -10px` will collapse to a single margin of `40px` between them.
- if both margins are negative, margins will collapse to the smallest margin. So a `<p>` with
`margin: -40px` and a `<p>` with `margin: -10px` will collapse to a single margin of `-40px` between them.


> `inline` and `block` are sometimes used in the docs to denote direction. Such that the `inline` direction
> it the content's writing mode while `block` perpendicular to the content's writing mode. In English writing,
> the `inline` direction is left-right and the `block` direction is top-down.

### Display
Items have `inner` and `outer` display types. The root element by default is laid out in `normal-flow`.

This means `block` elements are places vertically, one per row, from left to right. Each element `block`
element is spaced by `margins` such that vertical margins will collapse. This also means, `inline` elements
are placed horizontally, such that horizontal margins, paddings, and borders are respected.
The line containing `inline` elements is called a line box.

One of the main differences between `block` and `inline`, besides how they are laid out in the document, is that
`block` can have `width` and `height`, while the these are ignored for `inline`. Furthermore, even though paddings,
margins and borders can be added to `inline` elements, these only displace in the horizontal direction.

`block` and `inline` elements can have `inner` display types other than the default `normal-flow` described above.
Examples of such are `display: flex` and `display: grid`.

### Flex
Display flex, as the name implies is flexible. We set an element to have `inner` display `flex` with the
`display: flex` property. This element is the *flex container*, by default it has `outer` display
of block. You can change this by declaring `display: inline flex`. A flex container lays its inner
elements according to the `flex model`, in contrast to `normal-flow`. 

The `flex model` lays *flex items* on the `main-axis` and on the `cross-axis`. The `main-axis` is in the direction
specified by `flex-direction: row|column`. The `justify-content` property controls how items are laid on the `main-axis`,
while the `align-items` property controls how items are laid on the `cross-axis`.

By default a *flex container* places all *flex items* in a row with `justify-content: normal` and `align-items: normal`. Where 
`normal` behaves like `start` for `justify-content`, and `normal` behaves like `stretch` for `align-items`. 

- `start` causes the *flex items* to be laid at the start of the `main-axis`.
- `stretch` causes the *flex items* to stretch in the `cross-axis` to match the size of the *flex container*. This means that if 
the parent has no specified size, all items grow to the size of the biggest *flex item*.

By default *flex items* **do not wrap**. This means they will all bunch to fit on the `main-axis`. To address this use `flex-wrap: wrap;`, now 
items that do not fit will wrap on the `main-axis`. Wrapping and the *flex item* properties `flex-grow`, `flex-basis` and `flex-shrink` go hand in hand. 

- `flex-grow`: Is a unit less proportion that describes how the *flex item* grows in relation to others.
- `flex-shrink`: Is a unit less proportion that describes how the *flex item* shrinks in relation to others.
- `flex-basis`: Specifies the minimum size of the *flex item*.

There is a shorthand for all the properties above: `flex`. 
- When used with a unit less proportion it defaults to `flex-grow`.
- When used with two unit less proportions it defaults to `flex-grow` and `flex-shrink`.
- When used with a unit it defaults to `flex-basis`.
- When used with one unit less and one unit it defaults to `flex-grow` and `flex-basis`.
- You can probably guess this one.

You can override the *flex container's* `align-items` within individual *flex items* by using the `align-self` property.
You can also override the order of the items by using the `order` property. Where `order` is a unit less weight which describes
items with smallest weight will be placed first. The default weight of all items is `0`.
