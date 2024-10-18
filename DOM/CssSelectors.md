### Overview
Even though there are several ways to get elements from the DOM, usually it is best 
to stick with `querySelector` and `querySelectorAll` as they are what you would 
most commonly use in other things, for example web scraping. The string query you
pass to the `querySelector` and `querySelectorAll` matches how you would select elements 
in your CSS.

### Basics
To select an id use `#<id>`, for classes use `.<class>`, for elements just use `<element>`.
If you want to select an item with a combination of the above, just add its selectors without 
spaces. For example a `<div/>` with `class="box"` and `id="red"` you would use `div.box#red`.

### Child selectors
Other types of selectors regard the relative position of an item. To select ***all elements within another 
element***  use a space and the selector of the children. For example a `<span/>` that has several `<li/>` 
children you would use `span li`. The children need not be the direct children, it suffices to just be within
the parent element. On the other hand, if you want to select only the direct child (meaning the element following
directly after the parent), instead of space, use the greater than symbol `>`.
For example to select the first li above you would use `span > li`.

### Sibling selectors
Siblings refer to items at the same level of the other, unlike children which refers to anything within.
To select the siblings after an element use the tilde `~` followed by the selector of the siblings. For example
to select all siblings of a `<div/>` with the `class="item"` you would use `div ~ .item`. To only
select the direct sibling use the plus `+` followed by the selector of the sibling.

### Attribute selectos
For data attributes, just but the attribute in brackets `[data-attr]`. If you want to target attributes
with specific values just use the equal sign `[data-attr="<value>"]`. You can also check for starts with 
with `^=`, for ends with `$=` for contains with `*=`.
