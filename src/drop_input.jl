function drop_input!(
    state::Tuple{AbstractGraph, AbstractArray}, agent_idx::Integer,
    config::Config
)
    graph, agent_list = state
    this_agent = agent_list[agent_idx]
    # look for current input tweets that have too different opinion compared to own
    # and remove them if source agent opinion is also too different
    unfollow_Candidates = Array{Tuple{Int64, Int64}, 1}()

    for tweet in this_agent.feed
        if abs(tweet.opinion - this_agent.opinion) > config.opinion_treshs.unfollow
            if abs(agent_list[tweet.source_agent].opinion - this_agent.opinion) > config.opinion_treshs.unfollow
                # Add agents with higher follower count than own only with certain probability?
                if (indegree(graph, tweet.source_agent) / indegree(graph, agent_idx) > 1 && rand() > 0.5)
                    push!(unfollow_Candidates, (tweet.source_agent,indegree(graph,tweet.source_agent)))
                elseif (indegree(graph, tweet.source_agent) / indegree(graph, agent_idx) <= 1)
                    push!(unfollow_Candidates, (tweet.source_agent,indegree(graph,tweet.source_agent)))
                end
            end
        end
    end
    sort!(unfollow_Candidates, by=last)
    for i in 1:min(length(unfollow_Candidates),ceil(Int64, indegree(graph,agent_idx)*config.agent_props.unfollow_rate))
        rem_edge!(graph,unfollow_Candidates[i][1],agent_idx)
    end

    return state
end
