function create_agents(graph::AbstractGraph)
    agent_list = Array{Agent, 1}(undef, length(vertices(graph)))
    for agent_idx in 1:length(agent_list)
        agent_list[agent_idx] = Agent(generate_opinion(), generate_inclin_interact(), generate_check_regularity())
    end
    return agent_list
end

function create_agents(agent_count::Integer)
    agent_list = Array{Agent, 1}(undef, agent_count)
    for agent in 1:length(agent_list)
        agent_list[agent] = Agent(generate_opinion(), generate_inclin_interact(), generate_check_regularity())
    end
    return agent_list
end
