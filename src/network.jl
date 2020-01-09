"""
    create_network(n, m0)

Create a network with the Barabási-Albert model.

# Arguments
- `config`: Config file

# Example
```julia-repl
julia> using Random

julia> Random.seed!(0);

julia> create_network(Config())
{100, 206} directed simple Int64 graph

```

See also: [`update_network!`](@ref)
"""
function create_network(
    agent_list, config
)
    # this algorithm is modelled after the python networkx implementation:
    # https://github.com/networkx/networkx/blob/master/networkx/generators/random_graphs.py#L655

    g = SimpleDiGraph(config.network.agent_count)
    pref_attach_list = collect(1:config.network.agent_count)

    for source in 1:config.network.agent_count
        shuffle!(pref_attach_list)
        m0 = agent_list[source].desired_input_count
        if m0 >= config.network.agent_count
            m0 = config.network.agent_count - 1
        elseif m0 <= 0
            break
        end
        targets = Array{Int64}(undef, 0)

        for i in pref_attach_list
            if length(targets) >= m0
                break
            end
            if !(i in targets) && i != source
                push!(targets, i)
            end
        end

        for e in zip(targets, fill(source, m0))
            add_edge!(g, e[1], e[2])
        end
        append!(pref_attach_list, targets)
    end

    return g
end

"""
    update_network!(state, config)

Update a network in a simulation.

# Arguments
- `state`: a tuple of the current graph and agent_list
- `config`: Config object as provided by Config

See also: [`create_network`](@ref), [`Agent`](@ref), [`generate_opinion`](@ref), [`generate_inclin_interact`](@ref), , [`generate_check_regularity`](@ref)
"""
function update_network!(
    state::Tuple{AbstractGraph, AbstractArray},
    config::Config
)
    graph, agent_list = state
    pref_attach_list = [src(e) for e in edges(graph) if agent_list[src(e)].active]
    for _ in 1:config.network.growth_rate
        push!(
            agent_list,
            Agent(
                nv(graph) + 1,
                generate_opinion(),
                generate_inclin_interact(),
                generate_check_regularity(),
                generate_desired_input_count(config.agent_props.mean_desired_input_count)
            )
        )
        add_vertex!(graph)
        targets = Array{Int64}(undef, 0)

        shuffle!(pref_attach_list)
        for i in pref_attach_list
            if !(i in targets) && i != nv(graph)
                push!(targets, i)
            end
            if length(targets) == ceil(Int, last(agent_list).desired_input_count / 2)
                break
            end
        end

        for t in targets
            add_edge!(graph, t, nv(graph))
        end
    end
    return state
end

# suppress output of include()
;
