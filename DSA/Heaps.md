### Priority Queue
The heap invariant should be maintained by all heaps. It requires that the root of a subtree
compares to true/false with its children and so on recursively. This means that any node will 
always be compare to false/true with any of its ancestors. 

Heaps are an implementation for the **priority queue** ADT. They implement:
- `insert`: Insert node.
- `pop`: Deletes node with the highest priority.
- `find_highest`: Finds the node with the highest priority.

You can sort using the **priority queue** ADT:
1. `insert` all items into priority queue.
2. `pop` items from priority queue and `append` to your sorted container.

You can use other data structures to implement **priority queue** ADT, for example:
- `Dynamic Arrays`: Insertion is easy and can be done in `O(1)`. Finding the highest can be done in `O(n)`.
Deletions can be done in `O(n)`.
- `Dynamic Sorted Arrays`: Insertions need to re-sort the array, find the position of item in sorted array, then shift the other elements, which takes `O(nlogn)`.
A better alternative for insertion is just start at the end and shift node with previous until it is inplace (similar to insertion sort), which takes `O(n)`.
Finding the highest can be done in `O(1)`, just return the last item. Deletions can be done in `O(1)`.

If you think hard enough you will realize that priority queue sort in some data structures are well known sorting algorithms:
- `Dynamic Arrays = Selection Sort`: Insert all items into array, then search highest and put it at the end*, do so recursively in the sublist `a[:len(a) - i]`.
- `Dynamic Sorted Arrays = Insertion Sort`: Insert item, sort it into position, repeat for all elements.

### Heaps
Now what are heaps? Heaps are an array representation of a **complete tree**, *for simplicity we will treat
heaps as array representations of complete binary trees*. From our exploration of binary trees we know that
inorder traversal of a binary tree is not unique to that specific binary tree. However, the level order traversal
of any complete binary tree is unique. In other words, there is a bijection between any complete binary tree and its array
representation.

Note it is important compulsory for the tree to be complete to have a bijection with its array representation.
```
        A            A  
       / \          / 
      B   C        B   
                  /
                 C
```
Both trees above have the same level order traversal. However, one is complete and the other is not.

By storing our complete binary tree in an array, we can use random access and basic arithmetic, instead
of storing pointers, to access the relatives of any node. Given any node here is how to access its relatives:
- `left(i)`: `2*i + 1`.
- `right(i)`: `2*2 + 2`.
- `parent(i)`: `floor((i - 1) / 2)` equivalent to `ceil((i - 2) / 2)`.

Now if our complete binary tree satisfies the heap invariant `find_highest` becomes trivial: just return the 
first element.

When we `insert` and `pop` we need to restore the heap invariant. Insertions on an dynamic array can be done in `O(1)` if 
inserting at the end. Deletions on a dynamic array can also be done in `O(1)` if performed at the end. Anywhere else, both 
operations take `O(n)`. Therefore, for:
- `insert`: Insert item at the end `O(1)`, and restore the heap invariant `O(logn)
- `pop`: Swap highest priority with last item in the dynamic array `O(1)`, delete highest priority `O(1)`, and restore the heap invariant `O(logn)`.

##### Heapifying up
Heapifying up grabs the last element and moves it upward inplace to preserve the heap invariant. A node violates the 
heap invariant when it has a higher priority than its parent, since the parent has higher priority than its other child
it is safe to swap parent and node to restore the heap invariant for that three. Here is an illustration:
```
      < B <        < A >
       / \    ->    / \  
      C   A        C   B
```
We do so recursively and we have restored the heap invariant. This take order `O(height)` which for a complete binary tree
is always `O(logn)`.

##### Heapifying down
Heapifying down grabs the first element and moves it downward inplace to preserve the heap invariant. This is more tricky
since the node could be potentially be violating the invariant with both of its children. The question is how should we swap?
If in violation the should swap with the children with the highest priority. Here is an illustration.
```
      > C <                      < A >
       / \    ->  if A > B  ->    / \  
      B   A                      B   C
```

### Comparison with Comparison Binary Trees 
Comparison binary trees rely on the property that the root of the subtree compares to a 
different value when compared to any node in the left and any node in the right subtree.
Comparison has a branching factor of 2, the comparison is either `True` or `False`. Therefore,
to have a tree that allows for the invariant of a Comparison Binary Tree it is compulsory that 
you need a binary tree.
> Comparison binary trees have a left right invariant. Binary trees make sense for comparison trees
> since a comparison has a branching factor of 2.

Heaps are a bit different. The heap invariant states that all ancestors and descendants of a node 
evaluate to a different value when compared to the node.
> Heaps have a up down invariant. You could use any `n-ry` tree to represent a heap. However,
> when heapifying down, you will need to do 1 more `max` or `min` comparison compared to a
> `n-ary - 1` tree.
