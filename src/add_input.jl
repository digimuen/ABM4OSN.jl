"""
   add_input(state, agent_idx, post_list, config)

Create new directed edges from other agents.

# Arguments
- `state`: A tuple of the current graph and agent_list
- `agent_idx`: Agent index
- `post_list`: List of all published posts in network
- `config`: `Config` object as provided by `Config`

See also: [`Config`](@ref), [`drop_input!`](@ref)
"""
function add_input!(
    state::Tuple{AbstractGraph, AbstractArray},
    agent_idx::Integer,
    post_list::AbstractArray,
    config::Config
)

    graph, agent_list = state
    this_agent = agent_list[agent_idx]
    input_candidates = Int64[]  # neighbors of neighbors

    for neighbor in inneighbors(graph, agent_idx)
        append!(
            input_candidates,
            setdiff(
                inneighbors(graph, neighbor),
                inneighbors(graph, agent_idx),
                agent_idx
            )
        )
    end

    if length(input_candidates) == 0

        input_queue = Array{Tuple{Int64,Int64}, 1}()
        not_neighbors = setdiff(
            [1:(agent_idx - 1); (agent_idx + 1):nv(graph)], 
            inneighbors(graph, agent_idx)
        )  # all non-adjacent agents, self excluded

        for candidate in not_neighbors
            if (
                abs(this_agent.opinion - agent_list[candidate].opinion) 
                < config.opinion_threshs.follow
            )
                push!(input_queue, (candidate, outdegree(graph, candidate)))
            end
        end

        if (
            length(input_queue) == 0
            && indegree(graph, agent_idx) <= config.agent_props.min_input_count
            && config.mechanics.dynamic_net
        )
                set_inactive!(state, agent_idx, post_list)
                this_agent.inactive_ticks = -1
                return state
        end

        input_queue = first.(sort(input_queue, by=last, rev=true))

    else
        shuffle!(input_candidates)
        input_queue = first.(
            sort(
                collect(countmap(input_candidates)),
                by=last,
                rev=true
            )
        )  #= order neighbors by frequency of occurence
              in input_candidates descending =#

    end

    if (length(input_queue) - config.network.new_follows) < 0
        new_input_count = length(input_queue)
    else
        new_input_count = config.network.new_follows
    end

    for _ in 1:new_input_count
        new_neighbor = popfirst!(input_queue)
        add_edge!(graph, new_neighbor, agent_idx)
        if (
            (
                abs(this_agent.opinion - agent_list[new_neighbor].opinion)
                < config.opinion_threshs.follow
            )
            && outdegree(graph, agent_idx) > outdegree(graph, new_neighbor)
            && rand() < 0.5
        )
            add_edge!(graph, agent_idx, new_neighbor)
        end
    end

    return state
end

# suppress output of include()
;
