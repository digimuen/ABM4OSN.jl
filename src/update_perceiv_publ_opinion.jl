function update_perceiv_publ_opinion!(
    state::Tuple{AbstractGraph, AbstractArray}, agent_idx::Integer
)
    graph, agent_list = state
    this_agent = agent_list[agent_idx]
    # get neighborhood opinion as baseline
    input = outneighbors(graph, agent_idx)
    if length(input) != 0
        input_opinion_mean = mean([agent_list[input_agent].opinion for input_agent in input])
    else
        input_opinion_mean = this_agent.opinion
    end
    # compute feed opinion
    feed_opinions = [tweet.opinion for tweet in this_agent.feed]
    feed_weights = [tweet.weight for tweet in this_agent.feed]
    if length(feed_opinions) > 0
        feed_opinion_mean = (
            sum([opinion * weight for (opinion, weight) in zip(feed_opinions, feed_weights)]) /
            sum(feed_weights)
        )
    else
        feed_opinion_mean = this_agent.opinion
    end
    # perceived public opinion is the mean between the feed and neighborhood opinion
    this_agent.perceiv_publ_opinion = mean([input_opinion_mean, feed_opinion_mean])
    return state
end
