### Vim regex
This is a quick document about regex in VIM. Things to know:

- Range of Operation: In command mode, specifies to which lines the following
command will apply. `%s/<something>/<something>`.

- Escaped characters or metacharacters: Most all metacharacters `\w`, `\s`, are prefixed
by the `\` in your VIM :`substitute` or `:s` for short command. They represent character 
groups.

- Quantifiers: Specify how many times a cartain part of your patters should be repeated.
These include `\+`, `*`.

> The only metacharacters and quantifiers that do not use the ***magic*** backslash `\`
are the `.`, which matches any character, and the `*` which matches 0 or more of the preceding 
characters, ranges, or metacharacters. 

- Character Ranges: You can specify character ranges with brackets `[]`. `[65]` matches or 
the `6` or `5` character.

You can use regex with both `s:`, substitute, and `/`, search. VIM has a special syntax, for the 
replacement part of the `:s`, this is also a pattern like replacement.
