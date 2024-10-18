### Getting up to speed with regex
This is all about getting up to speed with regex. Most searching engines allow for regex if you specify them
within forward slashes `/<regex>/`. The implementation or regex differs depending on the engine but here 
is an overview. In regex we have literals (literal text), character classes, groups, symbols, quantifiers, logic, 
positional and more. 

Literals are literal text to match. You can enhance literals with symbols such as `.*+` and more. These symbols 
are closely related to quantifiers. The `.` is a wildcard for any non-white space character, the others `+` and `*`
relate to the quantity of the previous character, therefore they are quantifiers (specify the quantity of the 
character before). 

Character classes refer to a bunch of possible characters that represent a single match. In other words, a match with
a character class means that the item catched with one character specified in the character class. You specify character 
classes using braces `[...]`. Within the braces you add the characters that belong to the class. You can use symbols such
as `.-+` within the character class as literals, but be aware of the `-`. With the `-` you can specify ranges. For example,
`[a-zA-Z]` matches any English letters character, either capital or lower case. Read other way the character class `[a-zA-Z]`
means all characters from lowercase `a` to `z` and `A` to `Z`. Some character classes come built in. For example `\w` represents
all word characters, it is just an abbreviation for `[a-zA-Z0-9]`. Others include `\s` (white space) `\d` (digit). The capitalized
version of the built in classes represent the `NOT` or opposite.

Positional refer to the position of the match. `^` represents the beginning of the line, `$` represents the end of the line,
`\b` represents a word boundary. The `^` can also be used as a `NOT` within character classes. For example, `^dog` matches all 
lines that start with `dog`.

Groups refer to bunches of regular expressions within parenthesis `()`. Basically within groups you can use character classes,
symbols, literals, ***logic***, and more. The magic of group is that you can later refer to those groups in regex using `$<group-number>`
or `\<group-number>`. For example, `(cat|dog){1,2}` matches with `cat` `catcat` `catdog` `dog` `dogcat` `dogdog`. Or to check for 
duplicates you could also do `(cat|dog)\1` which matches `catcat` `dogdog`.

> Groups are really useful for search and replace operations.

Quantifiers represent the quantity. Some symbols we have used above are shortcuts for quantifiers. For example `*` represents
`{0,}` and `+` represents `{1,}` where the overall syntax of the quantifier is `{N,M}` where `N` is the minimum occurrences
and `M` is the maximum. Only one argument is required, if only one argument is specified, then the literal number of times is 
used. You can specify from the start or to the end by omitting the initial or final number. For example, `{4}` matches 4 occurrences,
`{,4}` matches from `0` to `4`, which is the same as `{0,4}`, `{4,}` matches from `4` to `Infinity`.
