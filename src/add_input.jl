function add_input!(
    state::Tuple{AbstractGraph, AbstractArray}, agent_idx::Integer,
    config::Config
)
    graph, agent_list = state
    # neighbors of neighbors
    input_candidates = Integer[]
    for neighbor in inneighbors(graph, agent_idx)
        append!(input_candidates, setdiff(inneighbors(graph, neighbor), inneighbors(graph, agent_idx)))
    end
    shuffle!(input_candidates)
    # Order neighbors by frequency of occurence in input_candidates descending
    input_queue = first.(sort(collect(countmap(input_candidates)), by=last, rev=true))
    # add edges
    if (length(input_queue) - config.network.new_follows) < 0
        new_input_count = length(input_queue)
    else
        new_input_count = config.network.new_follows
    end
    for _ in 1:new_input_count
        new_Neighbor = popfirst!(input_queue)
        add_edge!(graph, new_Neighbor, agent_idx)
        if (abs(agent_list[agent_idx].opinion - agent_list[new_Neighbor].opinion) < config.opinion_treshs.follow
            && indegree(graph, agent_idx) > indegree(graph, new_Neighbor))
            add_edge!(graph, agent_idx, new_Neighbor)
        end
    end
    return state
end
