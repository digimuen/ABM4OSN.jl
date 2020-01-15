"""
   update_input(state, agent_idx, config)

Update the incoming directed edges from other agents.

# Arguments
- `state`: a tuple of the current graph and agent_list
- `agent_idx`: agent index
- `config`: Config object as provided by Config

See also: [`Config`](@ref)
"""
function update_input!(
    state::Tuple{AbstractGraph, AbstractArray},
    agent_idx::Integer,
    config::Config
)

    graph, agent_list = state
    this_agent = agent_list[agent_idx]

    input_candidates = append!(
        [dst(e) for e in edges(graph) if !(
            e in union(inneighbors(graph, agent_idx), agent_idx)
            )
        ],
        [1:(agent_idx - 1); (agent_idx + 1):nv(graph)]
    )

    input_queue = shuffle(input_candidates)

    if (length(input_queue) - config.network.new_follows) < 0
        new_input_count = length(input_queue)
    else
        new_input_count = config.network.new_follows
    end

    for _ in 1:new_input_count
        new_neighbor = popfirst!(input_queue)
        add_edge!(graph, new_neighbor, agent_idx)
        deleteat!(input_queue, findall(x -> x == new_neighbor, input_queue))
    end

    unfollow_candidates = Array{Tuple{Int64, Float64}, 1}()

    for neighbor in inneighbors(graph, agent_idx)
        push!(
            unfollow_candidates,
            (neighbor, abs(this_agent.opinion - agent_list[neighbor].opinion))
        )
    end

    sort!(unfollow_candidates, by = last)

    for i in 1:config.network.new_follows
    rem_edge!(graph, popfirst!(unfollow_candidates)[1], agent_idx)
    end

    return state
end
