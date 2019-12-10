"""
   add_input(state, agent_idx, config)

Create new directed edges from other agents.

# Arguments
- `state`: a tuple of the current graph and agent_list
- `agent_idx`: agent index
- `config`: Config object as provided by Config

See also: [`Config`](@ref), [`drop_input!`](@ref)
"""
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
    # order neighbors by frequency of occurence in input_candidates descending
    input_queue = first.(sort(collect(countmap(input_candidates)), by=last, rev=true))
    # add edges
    if (length(input_queue) - config.network.new_follows) < 0
        new_input_count = length(input_queue)
    else
        new_input_count = config.network.new_follows
    end
    for _ in 1:new_input_count
        new_neighbor = popfirst!(input_queue)
        add_edge!(graph, new_neighbor, agent_idx)
        if (abs(agent_list[agent_idx].opinion - agent_list[new_neighbor].opinion) < config.opinion_treshs.follow
            && indegree(graph, agent_idx) > indegree(graph, new_neighbor))
            add_edge!(graph, agent_idx, new_neighbor)
        end
    end
    return state
end

# suppress output of include()
;