"""
    retweet(state, agent_idx, config)

Creates a retweet of a tweet

# Arguments
- `state`: a tuple of the current graph and agent_list
- `agent_idx`: agent index
- `config`: Config object as provided by Config
See also: [`Config`](@ref), [`Agent`](@ref), [`like!`](@ref)
"""
function retweet!(
    state::Tuple{AbstractGraph, AbstractArray}, agent_idx::Integer,
    config::Config
)
    graph, agent_list = state
    this_agent = agent_list[agent_idx]
    for tweet in this_agent.feed
        if ((abs(this_agent.opinion - tweet.opinion) < config.opinion_treshs.retweet)
            && !(tweet in this_agent.retweeted_tweets))
            tweet.weight *= 1.01
            tweet.retweet_count += 1
            push!(this_agent.retweeted_tweets, tweet)
            for neighbor in outneighbors(graph, agent_idx)
                push!(agent_list[neighbor].feed, tweet)
            end
            break
        end
    end
    return state
end

# suppress output of include()
;
