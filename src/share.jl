"""
    share(state, agent_idx, config)

Creates a share of a post

# Arguments
- `state`: a tuple of the current graph and agent_list
- `agent_idx`: agent index
- `config`: Config object as provided by Config
See also: [`Config`](@ref), [`Agent`](@ref), [`like!`](@ref)
"""
function share!(
    state::Tuple{AbstractGraph, AbstractArray},
    agent_idx::Integer,
    config::Config
)

    graph, agent_list = state
    this_agent = agent_list[agent_idx]

    for post in this_agent.feed
        if (
            (
                abs(this_agent.opinion - post.opinion)
                < config.opinion_threshs.share
            )
            && !(post in this_agent.shared_posts)
            && !(post in this_agent.disliked_posts)
        )
            post.share_count += 1
            post.weight *= 1.01

            push!(this_agent.shared_posts, post)

            for neighbor in outneighbors(graph, agent_idx)
                push!(agent_list[neighbor].feed, post)
            end
            break
        end
    end

    return state
end

# suppress output of include()
;
