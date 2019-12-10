function retweet!(
    state::Tuple{AbstractGraph, AbstractArray}, agent_idx::Integer,
    config::Config
)
    graph, agent_list = state
    this_agent = agent_list[agent_idx]
    for tweet in this_agent.feed
        if ((abs(this_agent.opinion - tweet.opinion) < config.opinion_treshs.retweet)
            && !(tweet in this_agent.retweeted_Tweets))
            tweet.weight *= 1.01
            tweet.retweet_count += 1
            push!(this_agent.retweeted_Tweets, tweet)
            for neighbor in outneighbors(graph, agent_idx)
                push!(agent_list[neighbor].feed, tweet)
            end
            break
        end
    end
    return state
end
