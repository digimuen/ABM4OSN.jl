function set_inactive!(
    state::Tuple{AbstractGraph, AbstractArray}, agent_idx::Integer, tweet_list::AbstractArray
)
    graph, agent_list = state
    this_agent = agent_list[agent_idx]
    this_agent.active = false
    agent_edges = [e for e in edges(graph) if (src(e) == agent_idx || dst(e) == agent_idx)]
    for e in agent_edges
        rem_edge!(graph, e)
    end
    empty!(this_agent.feed)
    for t in tweet_list
        if t.source_agent == agent_idx
            t.weight = -1
        end
    end
    return state
end
