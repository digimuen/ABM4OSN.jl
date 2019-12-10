function update_feed!(
    state::Tuple{AbstractGraph, AbstractArray}, agent_idx::Integer,
    config::Config
)
    graph, agent_list = state
    this_agent = agent_list[agent_idx]
    unique!(this_agent.feed)
    deleted_tweets = Integer[]
    for (index, tweet) in enumerate(this_agent.feed)
        if tweet.weight == -1 || !(tweet.source_agent in inneighbors(graph, agent_idx))
            push!(deleted_tweets, index)
        else
            tweet.weight = config.feed_props.tweet_decay * tweet.weight
        end
    end
    deleteat!(this_agent.feed, deleted_tweets)
    sort!(this_agent.feed, lt=<, rev=true)
    if length(this_agent.feed) > config.feed_props.feed_size
        this_agent.feed = this_agent.feed[1:config.feed_props.feed_size]
    end
    return state
end
