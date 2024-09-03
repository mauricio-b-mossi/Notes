> Disclaimer, all said will apply for simple graphs. Terminology for graphs varies.

### Introduction to graphs
A graph is a collection of vertices and edges `G = <V, E>`.
- A vertex can be thought as a node.
- An edge is the connection that exists between two nodes. Often represented as a
tuple (if directed) or a set (if undirected) of two vertices.

The edges of a graph can be either directed or undirected:
- **Directed** means the edges have a direction, meaning `(A, B)` is different form `(B,A)`. Where
edges are read as `(start vertex, end vertex)`.
- **Undirected** means the edges are bidirectional, meaning the edge `{A,B}` is equal to `(A, B)` and `(B, A)`.

**Adjacency** is a vertex property. Two vertices `A and B` are adjacent if there exits an edge that connects `{A, B}`. Again, for 
an undirected graph `is_adj(A, B) == is_adj(B, A)`.

**Degree** is a vertex property. The in or out degree of a vertex is the number of incoming, or out going edges from a node. Again, for 
an undirected graph `out_deg(A) == in_deg(A)`.

##### More terminology:
- A **walk** is a sequence of nodes connected by edges. For example if `vi` represents a generic vertex, then `v1v2v3`
represents a walk containing 3 vertex as 2 edges: the edges are `(v1, v2)` and `(v2, v3)`. A common mistake is over counting
the length of the walk by 1.
- For edges:
    - A **trail** is a **walk** with no repeated edges. 
    - A **circuit** is a **trail** starting and ending at the same vertex. 
- For vertices:
    - A **path** is a **walk** with no repeated vertices.
    - A **cycle** is a **path** starting and ending at the same vertex.

##### Extras:
- Euler's Path is a path that visits all vertices exactly once. 
- Euler's Circuit is a circuit that visits all edges exactly once. Look up "The Seven Bridges of Königsberg".

##### Important types of graphs:
- A graph is **connected** if there exists a walk from `A to B` for all `A` and for all `B`.
- A graph is **complete** if it contains all possible edges excluding loops. `E = {Vi x Vj}, if i != j`.
- A graph is **simple** if it contains no self loops and repeated edges.

Now given our graph is simple one might as what is the relation between the edges `E` and vertices `V`?

If our simple undirected graph is the densest it could be it would be a complete graph. All nodes in a complete graph
have `(v - 1)` edges. Therefore the total number of edges would be:
- `|E| = v(v - 1)/2`, if undirected.
- `|E| = v(v - 1)`, if directed.

Another way to arrive at the same result is:
1. If our graph is complete, it contains all possible edges.
2. An edge is a set, if undirected, of two vertices.
3. `(|v| choose 2)` produces all ways to choose two vertices, and therefore all edges. Again, if directed multiply by 2.

Therefore we can conclude that any simple undirected graph is upper bounded by `2|E| <= v^2-v`.

### Representations of graphs
- **Edge List**: A list of all the edges in a graph. 
    - Space `O(e)`: Stores all edges in a list.
    - `get_adj(v)` `O(e)`: Scans list and returns all edges containing v.
    - `is_edge(x, y)` `O(e)`: Scans list and checks whether `{x, y}` exists.
- **Adjacency List**: A hash table of vertices to lists of their adjacent vertices. Or each vertex could store its adjacent vertices: `v.adj`.
    - Space `O(v*max(deg(v)))`: Allocates a hash table of size `v` pointing to lists of size `deg(v)`.
    - `get_adj(v)` `O(1)`: Returns list at slot `v`.
    - `is_edge(x, y)` `O(deg(x))`: Scans list of slot `v` and checks whether `y` is in the list.
- **Adjacency Matrix** A `v*v` boolean matrix containing a `1` if edge `AdjMat[x][y]` exists.
    - Space `O(v^2)`: Allocates a `v*v` array.
    - `get_adj(v)` `O(v)`: Scans row `AdjMax[v][:]` and returns all `y` if `AdjMax[v][y] == 1`.
    - `is_edge(x, y)` `O(1)`: returns `AdjMax[x][y]`.

Each of the representations has its drawbacks and advantages. Selection depends on several factors:
- Is the graph sparse or dense?
- What operation will we perform more frequently? Checking for edges or requesting adjacent vertices? 

### Computations on Graphs
Some of the common computations performed in graphs are:
- **Connectivity**: Is there a walk from vertex `A` to `B`?
- **Shortest Path**: What is the shortest path from `A` to `B`?
- **Single Source Shortest Path**: What is the shortest path from vertex `A` to all vertices?
- **Cycle Detection**: Is there a cycle in the Graph?

##### Single Source Shortest Path and Connectivity: Assuming positive edge weights.
The single source shortest (sssp) path problem is one that contains, the fabulous, optimal substructure. A problem has an **Optimal substructure**
if solution of `f(1, n)` relies on the correctness of `f(1, n - 1)`. For example, in the shortest path problem, if we
want to find the shortest path from `(s, n + 1)`, if we know that the only vertex pointing to `n + 1` is `n`, then it 
must follow that the shortest path for `d(s, n + 1)` is the shortest path `d(s, n) + w(n, n + 1)`. Now to extend the idea,
say `n + 1` has `x` vertices pointing to it, then the shortest path is `min{for all n in(n + 1), d(s, n) + w(n, n + 1)}`, which means
the shortest path to `n + 1` is the shortest distance to one of its ancestors plus the weight of edge. This is a clear,
and can be easily proven by induction, in which our base case is the source node `s`. 

Proof:
- Base case: Distance to source node `s` is 0: `d(s,s) == 0`.
- Compute Shortest distance `(s, n + 1)`, which is the shortest distance `min{for s in in(n + 1), d(s, n) + w(n, n + 1)}`
- By induction, since we know `d(s, s)` we can find `d(s, s + 1)`. Consequently we also know `d(s, n)`, from which 
we can find `d(s, n + 1)`.

> Level sets are important while exploring sssp. Since most proofs rely on an invariant of the level set, sometimes called the frontier.

Using the proof above, we can find the shortest path for all level sets recursively. 
- In our base case, we know, by definition, the shortest path of the source to any vertex in level set 0: 0.
- Then for level set n, we explore all vertices in level set n - 1, and perform a relaxation on all out going edges.
- By performing a relaxation of all out going edges in the n - 1 level set we have found the shortest path for all vertices
in level set n.

A relaxation relies on the triangle inequality, remember the triangle inequality? Well here is a refresher.

- In a triangle we have three sides. Say we only have two connected sides, how would we form a triangle?
The triangle would be formed by forming a side that corresponds to the shortest path connecting the two other sides.
In more formal terms, for any two vectors `v1` and `v2` starting at the origin, for simplicity, the third side of the triangle 
corresponds to the vector `v2 - v1` starting at the tip of `v1`. This is the shortest distance.

The relaxation checks for the triangle inequality which states that `d[u] + d(u, v) >= d[v]` if `v` is the vertex
for which we want to verify the shortest path `d[v]` is true. The inequality states that if there exists any 
vertex that can reach `v`, then the shortest path to `d[u]` plus the weight of its edge `d(u, v)` must be greater then 
the shortest path to `d[v]`, if it is not greater, then this is a violation of the triangle inequality `d[v]` since
`d[u] + d(u, v)` is a shorter path to `v` than `d[v]` the so-called shorter path.


Here is an example of *sssp* using BSF.
*sssp* will perform a level order traversal of the graph and return a `dict<key = vertex, value = tuple<dist, prev>>`.
```
q = [x0]
dict[x0] = (0, None)

while q is not empty:
    v = q.deque()
    for u in adj(v):
        if u not in dict:
            dict[u] = (dict[v].dist + 1, v)
            q.enqueue(u)

return dict
```

Now what is the time complexity of this? Well we do iterate over all edges, and we allocate space in the order of the number of vertices.
Therefore the time complexity for the algorithm above is `O(|v| + |e|)`.
> Note |e| could be of order `O(n^2)` since |e| <= |v|^2 - |v|.

To check for connectedness in the algorithm above we check whether the vertex `v` is in the `dict`.
To reconstruct the shortest path form `v` to `source`, we query `dict[v.prev]` recursively until we 
arrive at `source`.

The algorithm above performs a Breadth First Search (BFS), in which all the vertices at distance `n` are visited
before all vertices at distance `n + 1` from the root.

Here is the algorithm for BFS:
- Initialization: Initialize a queue with an arbitrary vertex `x` and a `dict[vertex] = 0`. The dict tracks distances, while the queue tracks which items are next in the traversal.
- Modify: While the queue is not empty, dequeue item `x` from the queue and iterate over neighbors.
    - If neighbor `n` not in dict, insert `dict[n] = dict[`x`] + 1`, setting its distance to the `parent + 1`, and enqueue vertex as it has not been visited.
    - If neighbor `n` in dict continue.
- Terminate: When queue is empty meaning no unvisited items where present in this level set.

Now, if we want to find **cycles** we use full DFS. DFS visits all reachable nodes from the starting vertex.
Here is the algorithm for DFS:
- Initialize: Loop over all vertices.
    - If vertex has not been marked, mark `in progress` and visit its children.
    - If vertex is marked `in progress` it means recursion has not unravelled, since when we unravelled we mark vertex as `finished`, and therefore there exists a cycle, return cycle.
    - If vertex is marked `finished` we return since it means a DFS form that vertex has already been performed.
- Modify:
    - If children have been visited, mark `finished` and return.
- Termination:
    - When all vertices have been visited.
    - When cycle is found.

An analogy of how DFS works to detect cycles is like walking through a maze. If you walk a maze without breadcrumbs and you got a bad memory you will get lost easily. On 
the other hand if you leave breadcrumbs, and find your breadcrumbs again, my friend you have just found a cycle.

##### DAGS, Finishing Order, Topological Sort, and Cycles
Direct acyclic graphs, or DAGS for short, are directed graphs with no cycles. For example if a tree has directed edges, well it is a DAG. DAGs
are used to represent dependency trees, note the word tree, courses and prerequisites, etc. *If and only if we have a DAG we can perform topological sort.*
Topological sort is an ordering that requires that if there exists a path from `(u, v)` then `u` must appear before `v` in the sort.
It is useful to think about dependencies. In a topological sort all dependencies of a vertex are before the vertex itself. A common 
example of a topological sort problem are courses and their prerequirements. To take a course you first need to take 
its prerequirement, therefore, the prerequirement is a dependency for the course. A proper ordering of courses would be 
one that allows to take all courses, by first taking all the prerequirements. It is really easy to understand this procedure
and problem with `Kahn's algorithm`.

Khan algorithms states that we should iterate over all vertices and check if their `in_deg(v) == 0`.
- If the `in_deg(v) == 0` it means course `v` does not depend on others, therefore you can take course `v`.
    - Since we can take course `v` it means we can take all the courses that require `v`. Therefore remove, the 
    edges pointing from `v` to `x` therefore decreasing `in_deg(x)` by 1. Then we remove `v` from iterable
    since its requirement was already satisfied.
- We stop when there are no more vertices with `in_deg(v) == 0` in iterable. If there remain vertices in the iterable, then a cycle exists in the graph.

> Note even though we perform full DFS to check for cycles, we just need to prove it for one weakly connected component.  

Reverse finishing order sort produces a valid topological sort. Finishing order sort appends a vertex to a list as it backtracks in its DFS.
Proof:
- Case 1: `there exists (u, v)`. If there exists `(u, v)` and I start at `u`, then `v` will finish and therefore backtrack before `u`.
- Case 2: `there does not exist (u, v)`. If there does not exist `(u, v)` then `u` will finish before `v`. Since `v` is not in the path
    of `u`. It is either in a different connected component, or an ancestor of `u`.

##### Dijkstra and Bellman-Ford
Dijkstra's algorithm computes the single source shortest path in a graph with **non-negative edges**.
It makes the greedy choice at every step, in this case the greedy choice is the correct one, due 
to the optimal substructure of the problem. Here is how the algorithm works.
- Invariant: The loop will run until the priority queue is empty.
- Initialization: Initialize the invariants:
    - Initialize the priority queue with all nodes at distance `inf` and the initial vertex `v0` at distance `0`.
    - Set the parent for the first vertex equal to `None`, `p[v0] = None`.
    - Intantiate an empty set `s` containing the finalized objects.
- Modification: 
    - Pop the item `v` with the smallest distance off the priority queue.
    - For all out going edges of `v`:
        - if they are not in finalized set `s`, perform relaxation, if necessary update parent and value.
    - After looping thourgh edges, insert `v` into finalized set.

Why does this work? Well recursion can prove it. Here is a facts we need to know.

- Givens: All vertices are initialized an `inf` distance from the source. The source contains outgoing edges.

- Basis: We know the shortest distance from the source to the source, it is zero. 

- Forward Iteration: We perform relaxations on all the out going edges from the source.
After the initial relaxation, the smallest weighted path to one of the adjacent vertices is
a shortest path from the source. The justification is that since our graph only contains 
positive weights, for simplicity instead of non-negative, the weight of a path can only increase.

In terms of the first iteration say source `s` has three adjacent vertices `x`, `y`, and `z`. Say `x` has 
a smaller weighted path than the others. Since the weight of a path can only increase as it moves forward. 
There is no way to minimize the value of `x`. But why aren't' `y` and `z` also smallest paths? The reason
is that, say, `x` could have an edge to, say, `y` such that `d[y] > d[x] + w(x, y)`. Therefore, by the triangle
inequality `d[x] + w(x, y)` is the new shortest path.

If we continously iterate forward, picking the vertex with the smallest weighted path, performing relaxations
on its adjacent vertices, and removing the smallest vertex from the priority queue. We will indeed end with a 
shortest path. The key idea on why this works is due to positive edge weights.

Bellman-Ford does what Dijkstra cannot. It finds the shortest path for Graphs that might contain negative edge weights.
Its implementation is pretty simple, it also relies on optimal substructure.
```
for v in vertices:
    v.weighted_path = float('inf')

source.weighted_path = 0

for _ in range(|v|- 1): # Part 1: After loop, if no negative cycles, this produces a valid shortest path tree. 
    for e in Edges:
        relaxation(e)

for e in Edges:          # Part 2: If we can prove Part 1, then Part 2 means there exist negative weight cycles.
    if relaxation(e):
        # There exists a negative weight cycle.

# There does not exists a negative weight cycle.
```
If there exists a negative weight cycle, everything accessible through the weight cycle becomes undefined, since its 
path weight becomes `-inf`.

The question is why does `Part 1` above produce a valid single source shortest path? If you think about level sets
and frontiers everything becomes more intuitive. 
- Basis, the 0th level set is correct: `L0 = {source}`.
- In the first iteration, the only relaxation performed is between the source and its adjacent vertices. This is because
the relaxation for all other vertices is false since for a generic `x` and `y` excluding the source `d[x] == inf and d[y] == inf`
this means that the relaxation `d[x] >= d[y] + (x, y)` will always be false. Therefore, after the first iteration
all the single source shortests paths for the first level set are true.
- In subsequent level sets we perform all possible relaxation for that level set, therefore arriving at the correct 
shortest path for that level set.
- Performing `v` iterations we cover the worst case level set `LN`, where the graph would look like a linked list.
