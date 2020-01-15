"""
    publish_post!(state, post_list, agent_idx, tick_nr)
Publish a post to the network.
# Arguments
- `state`: a tuple of the current graph and agent_list
- `post_list`: List of all published posts in network
- `agent_idx`: agent index
- `tick_nr`: Number of current simulation tick
See also: [`Config`](@ref), [`Agent`](@ref)
"""
function publish_post!(
    state::Tuple{AbstractGraph, AbstractArray},
    post_list::AbstractArray,
    agent_idx::Integer,
    tick_nr::Integer=0
)

    graph, agent_list = state
    this_agent = agent_list[agent_idx]

    post_opinion = this_agent.opinion + 0.1 * (2 * rand() - 1)

    if post_opinion > 1
        post_opinion = 1.0
    elseif post_opinion < -1
        post_opinion = -1.0
    end

    post = Post(
        post_opinion,
        length(outneighbors(graph, agent_idx)),
        agent_idx,
        tick_nr
    )

    push!(post_list, post)

    for neighbor in outneighbors(graph, agent_idx)
        push!(agent_list[neighbor].feed, post)
    end
    
    return state, post_list
end

# suppress output of include()
;
