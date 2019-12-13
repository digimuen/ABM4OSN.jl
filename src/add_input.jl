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
    state::Tuple{AbstractGraph, AbstractArray}, agent_idx::Integer, tweet_list::AbstractArray,
    config::Config
)
    graph, agent_list = state
    this_agent = agent_list[agent_idx]
    # neighbors of neighbors
    input_candidates = Int64[]

    for neighbor in inneighbors(graph, agent_idx)
        append!(input_candidates, setdiff(inneighbors(graph, neighbor), inneighbors(graph, agent_idx)))
    end

    if length(input_candidates) == 0
        input_queue = Array{Tuple{Int64,Int64}, 1}()
        not_neighbors = setdiff([1:(agent_idx - 1); (agent_idx + 1):nv(graph)], inneighbors(graph, agent_idx))
        for candidate in not_neighbors
            if abs(this_agent.opinion - agent_list[candidate].opinion) < config.opinion_treshs.follow
                push!(input_queue, (candidate, outdegree(graph, candidate)))
            end
        end

        if length(input_candidates) == 0 && indegree(graph, agent_idx) <= config.agent_props.min_input_count
            set_inactive!(state, agent_idx, tweet_list)
            return state
        end

        input_queue = first.(sort(input_queue, by=last, rev=true))

    else
        shuffle!(input_candidates)
        # order neighbors by frequency of occurence in input_candidates descending
        input_queue = first.(sort(collect(countmap(input_candidates)), by=last, rev=true))
        # add edges
    end

    if (length(input_queue) - config.network.new_follows) < 0
        new_input_count = length(input_queue)
    else
        new_input_count = config.network.new_follows
    end
    for _ in 1:new_input_count
        new_neighbor = popfirst!(input_queue)
        add_edge!(graph, new_neighbor, agent_idx)
        if (abs(this_agent.opinion - agent_list[new_neighbor].opinion) < config.opinion_treshs.follow
            && indegree(graph, agent_idx) > indegree(graph, new_neighbor))
            add_edge!(graph, agent_idx, new_neighbor)
        end
    end
    return state
end

# suppress output of include()
;
