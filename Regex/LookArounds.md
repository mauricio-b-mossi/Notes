### Lookarounds are great
Lookarounds make regex even more powerfull than what it should be. It tells to match only if a contion around the 
initial match is made, hence the name look around. But what do we mean by around? By around we mean what is ahead or 
behind of our initial match, hence the names ***Lookahead*** and ***Lookbehind***. 

##### LookBehind `(/<match>(?<= | !>condition)/)`
Lookbehind follows the format `(/<match>(?=condition)/)` where match is the item searched, and the condition is what is
searched for ahead of the current match. If the match and the condition succedes a match will be made. For example in the 
quantity `30$`. If we want to match only the digits we could use:
```javascript
"There are a total of 10 30$ items in these 2 farms".match(/\d+(?=\$)/) // -> 30.
"There are a total of 10 30$ items in these 2 farms".match(/\b\d+\b(?!\$)/) // -> 10, 30, 2
```
Lets disect the regex:
```javascript
.match(/\d+(?=\$)/)
(//)    // Initialize regex.
\d+     // Digits
(?=\$)  // Followed by a dollar sign.

.match(/\b\d+\b(?!\$)/)
(//)        // Initialize regex.
\b\d+       // Space Digits.
(?!\$)      // NOT Followed by a dollar sign.
```
> `\s` and `\b` are different. One means `white space` and the other means `word boundary`.

##### LookAhead `(/(?<<= | !>condition)<match>/)`
LookAheads as the name implies matches if a condition ahead of the matched item is satisfied. For example if I have a CSV 
and for some reason the last element ends with a comma. I could use the regex:
```javascript
"1,2,3,4,5,6,7,".split(/(?<=,),(?=\d)/) 
```
Lets dissect it the regex:
```javascript
.match(/(?<=,),(?=\d)/)
(//)          // Initialize regex.
(?<=\d)       // LookBehind contains digit
,             // match ,
(?=\d)        // LookAhead contains digit
```
