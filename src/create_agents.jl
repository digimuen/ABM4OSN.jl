"""
    create_agents(graph, config)

Create agents from a graph with specified configuration.

# Arguments
- `graph`: A network as created by create_network
- `config`: Config object as provided by Config

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
            generate_desired_input_count(
                config.agent_props.mean_desired_input_count
            )
        )
    end

    return agent_list

end

"""
    create_agents(config)

Create agents with specified configuration.

# Arguments
- `config`: Config object as provided by Config

See also: [Agent](@ref), [create_network](@ref), [generate_opinion](@ref), [generate_inclin_interact](@ref), [generate_check_regularity](@ref)
"""
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
            generate_desired_input_count(
                config.agent_props.mean_desired_input_count
            )
        )
    end

    return agent_list

end

# suppress output of include()
;
