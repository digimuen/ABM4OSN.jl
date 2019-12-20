"""
    like(state, agent_idx, config)

Generate a like for an agent.

# Arguments
- `state`: a tuple of the current graph and agent_list
- `agent_idx`: agent index
- `config`: Config object as provided by Config

See also: [`Config`](@ref), [`Agent`](@ref)
"""
function like(
    state::Tuple{AbstractGraph, AbstractArray}, agent_idx::Integer,
    config::Config
)
    agent_list = state[2]
    this_agent = agent_list[agent_idx]

    for post in this_agent.feed
        if ((abs(post.opinion - this_agent.opinion) < config.opinion_threshs.like)
            && !(post in this_agent.liked_posts))
            post.like_count += 1
            post.weight *= 1.01
            push!(this_agent.liked_posts, post)
        end
    end
    return state
end

# suppress output of include()
;
