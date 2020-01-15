"""
   update_opinion!(state, agent_idx, config)

Update an agent's opinion depending on its perceived public opinion

# Arguments
- `state`: a tuple of the current graph and agent_list
- `agent_idx`: agent index
- `config`: Config object as provided by Config()

See also: [`Config`](@ref), [`update__perceiv_publ_opinion!`](@ref)
"""
function update_opinion!(
    state::Tuple{AbstractGraph, AbstractArray},
    agent_idx::Integer,
    config::Config
)

    agent_list = state[2]
    this_agent = agent_list[agent_idx]

    if (
        abs(this_agent.opinion - this_agent.perceiv_publ_opinion)
        < config.opinion_threshs.backfire
    )
        this_agent.opinion = (
            config.agent_props.own_opinion_weight * this_agent.opinion
            + (
                (1 - config.agent_props.own_opinion_weight)
                * this_agent.perceiv_publ_opinion
            )
        )
    else
        if (
            this_agent.opinion * this_agent.perceiv_publ_opinion > 0
            && (
                abs(this_agent.opinion) - abs(this_agent.perceiv_publ_opinion)
                < 0
            )
        )
            this_agent.opinion = (
                config.agent_props.own_opinion_weight * this_agent.opinion
            )
        else
            this_agent.opinion = (
                (2 - config.agent_props.own_opinion_weight)
                * this_agent.opinion
            )
        end

        if this_agent.opinion > 1
            this_agent.opinion = 1
        elseif this_agent.opinion < -1
            this_agent.opinion = -1
        end
    end

    return state
end

# suppress output of include()
;
