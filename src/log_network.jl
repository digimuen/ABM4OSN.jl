"""
    log_network(state, tick_nr)

Log the current state of a simulation.

# Arguments
- `state`: A tuple of the current graph and agent_list
- `tick_nr`: Current tick in the simulation

See also: [`tick!`](@ref), [`simulate`](@ref)
"""
function log_network(
    state::Tuple{AbstractGraph, AbstractArray},
    tick_nr::Int64
)

    graph, agent_list = state
    agent_opinion = [a.opinion for a in agent_list]
    agent_perceiv_publ_opinion = [a.perceiv_publ_opinion for a in agent_list]
    agent_check_regularity = [a.check_regularity for a in agent_list]
    agent_inclin_interact = [a.inclin_interact for a in agent_list]
    agent_desired_input_count = [a.desired_input_count for a in agent_list]
    agent_inactive_ticks = [a.inactive_ticks for a in agent_list]
    agent_active_state = [a.active for a in agent_list]
    agent_indegree = indegree(graph)
    agent_outdegree = outdegree(graph)

    return DataFrame(
        TickNr=tick_nr,
        AgentID=1:length(agent_list),
        Opinion=agent_opinion,
        PerceivPublOpinion=agent_perceiv_publ_opinion,
        CheckRegularity=agent_check_regularity,
        InclinInteract=agent_inclin_interact,
        DesiredInputCount=agent_desired_input_count,
        InactiveTicks=agent_inactive_ticks,
        Indegree=agent_indegree,
        Outdegree=agent_outdegree,
        ActiveState=agent_active_state
    )

end

# suppress output of include()
;
