"""
    create_agents(graph)

Create agents from a graph.

# Example
```julia-repl
julia>using Random

julia>Random.seed!(0);

julia>g = create_network(100, 3)
{100, 206} directed simple Int64 graph

julia>create_agents(g)
100-element Array{Agent,1}:
 ABM4OSN.Agent(-0.21358598875747914, 0.24040808640140598, -0.21358598875747914, 0.946685901388097, true, 0, ABM4OSN.Post[], ABM4OSN.Post[], ABM4OSN.Post[])
 ABM4OSN.Agent(-0.4168976786164982, 0.19897621172267413, -0.4168976786164982, 0.9528034729915846, true, 0, ABM4OSN.Post[], ABM4OSN.Post[], ABM4OSN.Post[])
 ⋮
```

# Arguments
- `graph`: a network as created by create_network

See also: [Agent](@ref), [create_network](@ref), [generate_opinion](@ref), [generate_inclin_interact](@ref), [generate_check_regularity](@ref)
"""
function create_agents(
    graph::AbstractGraph,
    config::Config
)
    agent_list = Array{Agent, 1}(undef, length(vertices(graph)))
    for agent_idx in 1:length(agent_list)
        agent_list[agent_idx] = Agent(
            agent_idx,
            generate_opinion(),
            generate_inclin_interact(),
            generate_check_regularity(),
            generate_desired_input_count(config.agent_props.mean_desired_input_count)
        )
    end
    return agent_list
end

function create_agents(
    config::Config
)
    agent_list = Array{Agent, 1}(undef, config.network.agent_count)
    for agent_idx in 1:length(agent_list)
        agent_list[agent_idx] = Agent(
            agent_idx,
            generate_opinion(),
            generate_inclin_interact(),
            generate_check_regularity(),
            generate_desired_input_count(config.agent_props.mean_desired_input_count)
        )
    end
    return agent_list
end

# suppress output of include()
;
