"""
    like(state, agent_idx, config)

Generate a dislike for a post.

# Arguments
- `state`: a tuple of the current graph and agent_list
- `agent_idx`: agent index
- `config`: Config object as provided by Config

See also: [`Config`](@ref), [`Agent`](@ref)
"""
function dislike!(
    state::Tuple{AbstractGraph, AbstractArray}, agent_idx::Integer,
    config::Config
)
    agent_list = state[2]
    this_agent = agent_list[agent_idx]

    for post in this_agent.feed
        if ((abs(post.opinion - this_agent.opinion) > (2 * (config.opinion_threshs.like)))
            && !(post in this_agent.liked_posts)
            && !(post in this_agent.disliked_posts)
            && !(post in this_agent.shared_posts))
            post.dislike_count += 1
            post.weight *= 0.99
            push!(this_agent.disliked_posts, post)
        end
    end
    return state
end

# suppress output of include()
;
