"""
   set_inactive!(state, agent_idx, post_list)

Sets an agent's state to inactive and deletes all his connections to others and posts

# Arguments
- `state`: a tuple of the current graph and agent_list
- `agent_idx`: agent index
- `post_list`: List of all published posts in network

See also: [`Agent`](@ref), [`tick!`](@ref)
"""
function set_inactive!(
    state::Tuple{AbstractGraph, AbstractArray}, agent_idx::Integer, post_list::AbstractArray
)
    graph, agent_list = state
    this_agent = agent_list[agent_idx]
    this_agent.active = false
    agent_edges = [e for e in edges(graph) if (src(e) == agent_idx || dst(e) == agent_idx)]
    for e in agent_edges
        rem_edge!(graph, e)
    end
    empty!(this_agent.feed)
    for p in post_list
        if p.source_agent == agent_idx
            p.weight = -1
        end
    end
    return state
end

# suppress output of include()
;
