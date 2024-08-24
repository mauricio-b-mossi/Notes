### Binary Trees
Binary trees are a useful data structure that can achieve insertions and deletions in any place in `O(log(n))`.
They are made up of a collection of nodes with values and `left`, `right`, and possible a `parent` pointer. The nodes are similar
to those of linked list, but a key distinction is that nodes of a linked list will always have at most **depth linear on the number of nodes**.
While binary trees can have up to **depth logarithmic on the number of nodes**. For a binary tree to have at most
depth logarithmic in the number of nodes, it must be **balanced**. A balanced binary tree is one in which the heights of the left and right subtrees differ by at most a certain threshold, depending on the type
of tree (e.g., AVL trees allow a skew of +-1).

As a refresher, 
- `height` is the longest path from a node to a leave. Leaves always have height 0.
- `depth` is the number of ancestors of a node. 
```
            A # height 2, depth 0
           / \
          B   C
         /
        D # height 0, depth 2
```
Most operations in Binary Trees rely on comparisons to perform binary search. For example:
- **binary tree as sets** we will perform comparisons based on `keys`.
- **binary trees as sequences** will perform binary search based on `index`, more on this later.

Binary trees can perform binary search as they maintain the binary tree invariant. The invariant states
that the left subtree always yields `True/False` for a given comparison with the root, while the right subtree always 
yields `False/True` for the same given comparison with the root. Examples of comparisons could be:
- `root.value > node.value`.
- `root.key > node.value`.
It is important to note that the same type of comparison is performed between the root of the tree
and its descendants for all subtrees in the tree.

This invariant leads to the following result in any subtree of the given tree.
- **The leftmost node in a subtree will evaluate to `True/False` when compared to any node in the subtree**.
- **The rightmost node in a subtree will evaluate to `False/True` when compared to any node in the subtree**.

With this in mid, the traversal, or ordering that makes sense is an **inorder traversal**. This traversal
ensures that for any node, all nodes traversed before would of evaluated to say `True` given the comparison with that note.
and all nodes traversed after would of evaluated to say `False`. Recursively speaking the traversal would look like this:
```
traverse(node)
    if node.left/right
        traverse(node.left)
    operate(node)
    if node.right/left
        traverse(node.right)
```

> Talking about numbers will make the subsequent section easier.

A high level algorithm for `insertion(node, value)` at the end is:
- Compare `value` > `node.value`.
- If greater/smaller insert on left or right accordingly. 
- if `node.right/left` is `None`, insert there.
- If not `None` recursively call `insertion(node.right/left, value)` accordingly.
- Else call insertion with `insertion(node.left/right, value)`.

To insert at a specific location, say `insert_after` or `insert_before` we need to cover the topic of
predecessor and successor. 
- `predecessor:` Is the object that would appear before in an inorder traversal: `subtree_last(node.left)`.
- `successor`: Is the object that would appear after in an inorder traversal: `subtree_first(node.right)`.

Therefore to insert after or before you need to insert the item in the specific subtree:
- `after`: `subtree_first(node.right).left = node`.
- `before`: `subtree_last(node.left).right = node`.

Remember the (alternate order depending on case):
- **the predecessor is the rightmost node in the subtree of node.left**.
- **the successor is the leftmost node in the subtree of node.right**.


**Subtree properties** are properties such that are local to each node and can are calculated via its children in `O(1)`.
Examples of subtree properties are:
- `height`: The height of a node computed as `height = 1 + max(left.height, right.height)`.
- `size`: The size of a subtree computed as `size = 1 + right.size + left.size`.
- `sum`: The sum of a subtree computer as `sum = self.value + right.sum + left.sum`.

Most operations on binary take `O(h)` time complexity. If we can prove that the height of a binary tree is small* compared
to the number of nodes, we would have a data structure that can act both as a `set` and a `sequence` that performs
insertions, deletions, and search in sub linear time.

However, we know that a binary tree can have `height == len(nodes)`. In which case the binary tree looks more like a linked list
and performs most operations in linear time. We have to constrain the structure of the binary tree and we do so with 
**balanced binary trees**. Balanced binary trees have some constraints that keeps their height balanced. The one we will 
explore is an AVL tree but note there are several others.

While performing rotations on AVL trees, when an imbalance occurs at a node (where the balance factor becomes `-2`
or `+2`), we determine whether the rotation needed is a left rotation (to fix a -2 imbalance) or a right rotation
(to fix a `+2` imbalance). However, the type of rotation—simple or double—depends on the structure of the offending
subtree.

Single Rotation: If the subtree contributing to the imbalance (the child of the offending node) is leaning in the
same direction as the imbalance (e.g., right subtree is taller for a -2 imbalance), then a single rotation (either
left or right) is sufficient.

Double Rotation: If the subtree contributing to the imbalance has a child subtree that leans in the opposite direction
(e.g., the left child of a right subtree for a -2 imbalance), a double rotation is required. First, you perform a 
rotation on the child subtree in the opposite direction, followed by a rotation on the offending node in the direction of
the original imbalance.

The reason for the rotation direction is 
1. To fix height imbalance.
2. Preserve traversal order.

In other words, the specific rotation type (LL, LR, RL, or RR) is determined by the relative heights of the subtrees involved.
An AVL tree mantains the invariant that the difference between the heights of the right and left subtrees of any node
can be at most `-1` or `+1`. If the invariant is violated, a **rotation** is performed to address the issue.

Previously explored ADTs for `sequence` include:
- `Arrays`: `insert O(n)`, `delete O(n)`, `search(1)`
- `Dynamic Arrays`: `insert O(1) amortized`, `delete O(1)`, `search(1)`
- `Linked List`: `insert node O(1)`, `delete node O(1)`, `search(n)`, note even though insert and deletions are constant, the node to be inserted/deleted needs to be searched first.

and for `set` include:
- `Arrays`: See above.
- `Dynamic Arrays`: See above.
- `Hash Tables`: `insert O(1) expected`, `delete O(1) expected`, `search O(1) expected`. Note all operations can be `O(n)` in the worst case.


