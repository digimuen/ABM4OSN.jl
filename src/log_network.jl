function log_network(state::Tuple{AbstractGraph, AbstractArray}, tick_nr::Int64)
    graph, agent_list = state
    agent_opinion = [a.opinion for a in agent_list]
    agent_perceiv_publ_opinion = [a.perceiv_publ_opinion for a in agent_list]
    agent_inclin_interact = [a.inclin_interact for a in agent_list]
    agent_inactive_ticks = [a.inactive_ticks for a in agent_list]
    agent_active_state = [a.active for a in agent_list]
    agent_indegree = indegree(graph)
    return DataFrame(
        TickNr = tick_nr,
        AgentID = 1:length(agent_list),
        Opinion = agent_opinion,
        PerceivPublOpinion = agent_perceiv_publ_opinion,
        InclinInteract = agent_inclin_interact,
        InactiveTicks = agent_inactive_ticks,
        Indegree = agent_indegree,
        ActiveState = agent_active_state
    )
end
