function update_opinion!(
    state::Tuple{AbstractGraph, AbstractArray}, agent_idx::Integer,
    config::Config
)
    agent_list = state[2]
    this_agent = agent_list[agent_idx]
    # weighted mean of own opinion and perceived public opinion
    if (abs(this_agent.opinion - this_agent.perceiv_publ_opinion) < config.opinion_treshs.backfire)
        this_agent.opinion = (
            config.agent_props.own_opinion_weight * this_agent.opinion
            + (1 - config.agent_props.own_opinion_weight) * this_agent.perceiv_publ_opinion
        )
    else
        if ((this_agent.opinion * this_agent.perceiv_publ_opinion > 0)
            && (abs(this_agent.opinion) - abs(this_agent.perceiv_publ_opinion) < 0))
            this_agent.opinion = config.agent_props.own_opinion_weight * this_agent.opinion
        else
            this_agent.opinion = (2 - config.agent_props.own_opinion_weight) * this_agent.opinion
        end
        if this_agent.opinion > 1
            this_agent.opinion = 1
        elseif this_agent.opinion < -1
            this_agent.opinion = -1
        end
    end
    return state
end
