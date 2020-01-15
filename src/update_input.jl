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

    pref_attach_list = append!(
        [dst(e) for e in edges(graph)],
        1:nv(graph)
    )

    exclude = union(inneighbors(graph, agent_idx), agent_idx)

    function draw_new_input(pref_attach_list, exclude)
        draw = rand(pref_attach_list)
        if draw in exclude
            draw = draw_new_input(pref_attach_list, exclude)
        end
        return draw
    end

    if (length(exclude) >= (nv(graph) - config.network.new_follows))
        new_input_count = nv(graph) - length(exclude) - 1
    else
        new_input_count = config.network.new_follows
    end

    for _ in 1:new_input_count
        new_neighbor = draw_new_input(pref_attach_list, exclude)
        add_edge!(graph, new_neighbor, agent_idx)
        push!(exclude, new_neighbor)
    end

    unfollow_candidates = Array{Tuple{Int64, Float64}, 1}()

    for neighbor in inneighbors(graph, agent_idx)
        push!(
            unfollow_candidates,
            (neighbor, abs(this_agent.opinion - agent_list[neighbor].opinion))
        )
    end

    sort!(unfollow_candidates, by=last)

    for i in 1:config.network.new_follows
        rem_edge!(graph, popfirst!(unfollow_candidates)[1], agent_idx)
    end

    return state

end
