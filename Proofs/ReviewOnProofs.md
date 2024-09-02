### Propositional Logic Refresher
- `p -> q`: If p then q.
- `~(p -> q) == p and ~q`.
- `p -> q == ~q -> ~p`.

| p | q | p -> q | ~q -> ~p | ~(p -> q) | p and ~q |
|:---:|:---:|:---:|:---:|:---:|:---:|
| T | T | T | T | F | F |
| T | F | F | F | T | T |
| F | T | T | T | F | F |
| F | F | T | T | F | F |

- A tautology is a proposition that is always true, for example `p or ~p`.
- A contradiction is a proposition that is always false, for example `p and ~p`.
- A compound proposition is a proposition formed by propositional variables and operators, for example `if p then q`.

The equivalence of two compound propositions is shown via the tautology `p <-> q`. Where both `p` and `q` are compound propositions.
For example: `(p <-> q) <-> ((p -> q) and (q -> p))`, where once can be thought as the definition of the other.

### General Form
A lot of proofs are in the form `for all x, if P(x) then Q(x)`. To prove the theorem we have to show that for
an **arbitrary** `c in x`, the universe, the statement holds: `P(c) -> Q(c)`. In notation, this is often omitted,
where `P(c) -> Q(c) is shortened for p -> c`. For example:
- A direct proof relies on showing that `p -> q`.
- A proof by contrapositive relies on showing that `~q -> ~p`, since `p -> q <-> ~q -> ~p`.
- A proof by contradiction relies on showing that, where `p` is a compound proposition, if `p == T`, then `~p == F`.
- A proof by cases relies on showing that if `p` can be broken into cases `p1, p2, p3` such that `p <-> (p1 or p2 ... pn)`, then
`(p -> q) <-> ((p1 or p2 ... pn) -> q) <-> (p1 -> q or p2 -> q or p3 -> q ...)`.

> Remember, even though we write if `p -> q`, what is meant is `for all x P(x) -> Q(x)`. For example, by `p <-> (p1 or p2 or pn)`
> it is meant to represent `P(c) <-> (P1(c) or P2(c) or P3(c))`.

### Proofs
In proofs we try to prove a statement is true given some initial conditions. We prove a statement by showing
that given the initial conditions the statement is true. There are several proof techniques we shall explore, 
but it is always good to remember that we are seeking to prove, or disprove a statement.
- For implication our given is p, we assume it is `T`, and our implication is q, if we prove that `p=T -> q=T`, the statement is true. 
This is because that would mean the statement `p -> q` could never yield `F` given that `p -> q`.

### Direct Proof
In a direct proof, like the name implies you directly prove the statement based on definitions, assumptions,
and other background knowledge. For example, lets prove the following: `if a is an odd integer then a^2 is odd.`
1. Using definitions: An odd number can be written as `2n + 1`, where `n` is an integer.
2. Arithmetic: We are trying to prove that `a^2 = 2k + 1`, if `a = 2n + 1`, we can square verify the claim.
- if `a = 2n + 1` then `a^2 = (2n + 1)^2`.
- then `a^2 = 4n^2 + 4n + 1`.
- by manipulation `a^2 = 2(2n^2 + 2n) + 1`
- define `k = (2n^2 + 2n)`, therefore `a^2 = 2k + 1`.
- since `a^2 = 2k + 1` and all odd integers can be written as `2n + 1`, we have proven `a^2` is odd.

### Contrapositive
For a conditional / implication, the contrapositive is logically equivalent to the conditional. For some proofs it is 
way easier to prove the contrapositive than to proof the implication. For example, consider the following: `if a^2 is odd then a is odd`.
1. Understanding the proof: Starting from knowing that `a^2 == 2n + 1` how could we get to `a == 2k + 1`? It appears
we would need to take the square root of `a^2`. However we know that the statement `p -> q` is equivalent to `~q -> ~p`.
Therefore, if `p == a^2 is odd` and `q == a is odd`, we are going to prove that if `~q == a is even` then `~p == a^2 is even`.
2. Arithmetic: We are trying to prove that if `a = 2n`, then `a^2 = (2n)^2`.
- if `a = 2n`, then `a^2 = 4n^2`.
- if we factor out a 2, `a^2 = 2(2n^2)`
- define `k = 2n^2`, then `a^2 = 2k`.
- therefore if `a^2 = 2k`, `a^2` is even.
- proving that `~q -> ~p`, which is equivalent to `p -> q`.

### Contradiction
To prove a statement `s` correct we prove that `s == T`. However, if it is the case that `s == T`, then it follows
that `~s == ~T`. Therefore, we can prove directly, `s == n`, or indirectly by contradiction, `~s == ~T`. For example:
```
Say a and b == T.               
Then ~(a and b) == ~T
Then ~a or ~ b == F

Say p -> q == T.
Then ~(p -> q) == ~T
Then p and ~q == F
```
Lets prove that there does not exist a smallest positive integer in the real numbers.
- Understanding: `There does not exists a number x such that 0 < x < y for all positive real numbers y.`
This would be hard to prove directly, but we can prove by contradiction.
- Proof: We are trying to prove that `There exists a number x such that 0 < x < y for all positive real numbers y.` is `F`.
- say there is a positive smallest number x.
- if we divide `x/2`, `0 < x/2 < x`.
- therefore it is false that there exists a smallest positive integer in the real numbers.
- proving the statement.

### Induction
Proofs by induction require proving the base case and then the general case. For example,
`prove that the sum of all the natural numbers up to n is equal to n(n + 1)/2`.
- Prove the base case: P(1) = 1(1 + 1)/2 = 1.
- Prove the kth case: P(k) + k + 1 = P(k).
