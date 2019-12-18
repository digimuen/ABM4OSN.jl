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
    graph::AbstractGraph
)
    agent_list = Array{Agent, 1}(undef, length(vertices(graph)))
    for agent_idx in 1:length(agent_list)
        agent_list[agent_idx] = Agent(
            agent_idx, generate_opinion(), generate_inclin_interact(), generate_check_regularity()
        )
    end
    return agent_list
end

"""
    create_agents(agent_count)

Create agents from a given agent count.

# Example
```julia-repl
julia>using Random

julia>Random.seed!(0);

julia>create_agents(3)
3-element Array{ABM4OSN.Agent,1}:
 ABM4OSN.Agent(0.6472950159548247, 0.02917756427881842, 0.6472950159548247, 0.9983073811302889, true, 0, ABM4OSN.Post[], ABM4OSN.Post[], ABM4OSN.Post[]) 
 ABM4OSN.Agent(-0.6453423070674709, 0.3967140625022613, -0.6453423070674709, 0.9974123306454633, true, 0, ABM4OSN.Post[], ABM4OSN.Post[], ABM4OSN.Post[])      
 ABM4OSN.Agent(-0.9153966681359407, 0.8339233629392565, -0.9153966681359407, 0.9918175134767683, true, 0, ABM4OSN.Post[], ABM4OSN.Post[], ABM4OSN.Post[])  
```

# Arguments
- `agent_count`: number of agents in the simulation 

See also: [Agent](@ref), [create_network](@ref), [generate_opinion](@ref), [generate_inclin_interact](@ref), [generate_check_regularity](@ref)
"""
function create_agents(
    agent_count::Integer
)
    agent_list = Array{Agent, 1}(undef, agent_count)
    for agent in 1:length(agent_list)
        agent_list[agent] = Agent(
            generate_opinion(), generate_inclin_interact(), generate_check_regularity()
        )
    end
    return agent_list
end

# suppress output of include()
;