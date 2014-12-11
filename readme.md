http://www.reddit.com/r/dailyprogrammer/comments/2o5tb7/2014123_challenge_191_intermediate_space_probe/


---


### some notes
    - on breaking loops
        - www.haskellforall.com/2012/07/breaking-from-loop.html
    - on data structures:
        - http://stackoverflow.com/questions/6976559/comparison-of-priority-queue-implementations-in-haskell
        - http://dev.stephendiehl.com/hask/#data-structures
    - Think I'll just a list and sort it every once in a while...
        - not interested in priority queue right now. 

ghci -i Main.hs Util.hs

### A* algorithm
function A*(start,goal)
    closedset := the empty set    // The set of nodes already evaluated.
    openset := {start}    // The set of tentative nodes to be evaluated, initially containing the start node
    came_from := the empty map    // The map of navigated nodes.
 
    g_score[start] := 0    // Cost from start along best known path.
    // Estimated total cost from start to goal through y.
    f_score[start] := g_score[start] + heuristic_cost_estimate(start, goal)
 
    while openset is not empty
        current := the node in openset having the lowest f_score[] value
        if current = goal
            return reconstruct_path(came_from, goal)
 
        remove current from openset
        add current to closedset
        for each neighbor in neighbor_nodes(current)
            if neighbor in closedset
                continue
            tentative_g_score := g_score[current] + dist_between(current,neighbor)
 
            if neighbor not in openset or tentative_g_score < g_score[neighbor] 
                came_from[neighbor] := current
                g_score[neighbor] := tentative_g_score
                f_score[neighbor] := g_score[neighbor] + heuristic_cost_estimate(neighbor, goal)
                if neighbor not in openset
                    add neighbor to openset
 
    return failure
 
function reconstruct_path(came_from,current)
    total_path := [current]
    while current in came_from:
        current := came_from[current]
        total_path.append(current)
    return total_path



#### In haskell

A* = 
    -- closet set is set of nodes already evaluated
    -- open set is set of nodes to be evaluated
    let closedset = []
    let openset   = []
    cameFrom = emptyMap
    gScore[start] = 0
    fScore[start] = g_score[start] + heuristicCostEstimate(start,goal)
    
    while openset is not empty:
        let current = head openset
        -- pop it
        let openset = tail openset
        if current == goal:
            return reconstruct_path(came_from, goal)
        push current onto closed set
        for each neighbor in neighborNodes(current):
            if neighbor in closedset:
                continue
            tentative_g_score = g_score[current] + dist_between(current,neighbor)
            if neighbor not in openset, or tentative_g_score < g_score[neighbor]
                ... do things














