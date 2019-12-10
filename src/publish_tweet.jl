function publish_tweet!(
    state::Tuple{AbstractGraph, AbstractArray}, tweet_list::AbstractArray, agent_idx::Integer,
    tick_nr::Integer=0
)
    graph, agent_list = state
    this_agent = agent_list[agent_idx]
    tweet_opinion = this_agent.opinion + 0.1 * (2 * rand() - 1)
    # upper opinion limit is 1
    if tweet_opinion > 1
        tweet_opinion = 1.0
    # lower opinion limit is -1
    elseif tweet_opinion < -1
        tweet_opinion = -1.0
    end
    tweet = Tweet(tweet_opinion, length(outneighbors(graph, agent_idx)), agent_idx, tick_nr)
    push!(tweet_list, tweet)
    # send tweet to each outneighbor
    for neighbor in outneighbors(graph, agent_idx)
        push!(agent_list[neighbor].feed, tweet)
    end
    return state, tweet_list
end
