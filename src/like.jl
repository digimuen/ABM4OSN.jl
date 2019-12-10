function like(
    state::Tuple{AbstractGraph, AbstractArray}, agent_idx::Integer,
    config::Config
)
    agent_list = state[2]
    this_agent = agent_list[agent_idx]
    inclin_interact = deepcopy(this_agent.inclin_interact)
    i = 1
    while inclin_interact > rand()
        if i < length(this_agent.feed)
            if ((abs(this_agent.feed[i].opinion - this_agent.opinion) < config.opinion_treshs.like)
                && !(this_agent.feed[i] in this_agent.liked_Tweets))
                this_agent.feed[i].like_count += 1
                this_agent.feed[i].weight *= 1.01
                push!(this_agent.liked_Tweets, this_agent.feed[i])
            end
        else
            break
        end
        i += 1
        inclin_interact -= 1
    end
    return state
end
