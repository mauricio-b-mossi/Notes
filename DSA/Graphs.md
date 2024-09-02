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

The beauty is that by computing the **single source shortest path**, *sssp from now on*, of `A` we have the answer of connectivity, and shortest
path for all nodes with respect to `A`. Here is how:
- *sssp* will perform a level order traversal of the graph and return a `dict<key = vertex, value = tuple<dist, prev>>`.
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

From the return type of *sssp* to check for connectedness we check whether the vertex `v` is in the `dict`.
To reconstruct the shortest path form `v` to `source`, we query `dict[v.prev]` recursively until we arrive at `source`.

The algorithm above performs a Breadth First Search (BFS), in which all the vertices at distance `n` are visited
before all vertices at distance `n + 1` from the root. *BSF* is particularly useful at finding the shortest path due to the invariant stated above.

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

### DAGS, Finishing Order, Topological Sort, and Cycles
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
