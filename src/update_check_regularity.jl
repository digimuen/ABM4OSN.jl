function update_check_regularity!(
    state::Tuple{AbstractGraph, AbstractArray}, agent_idx::Integer,
    config::Config
)
    agent_list = state[2]
    this_agent = agent_list[agent_idx]
    if (abs(this_agent.opinion - this_agent.perceiv_publ_opinion) > config.opinion_treshs.check_unease)
        this_agent.check_regularity = config.agent_props.check_decrease * this_agent.check_regularity
    else
        this_agent.check_regularity = 1.0
    end
    return state
end
