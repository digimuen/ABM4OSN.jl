function cfg_net(
    ;
    agent_count::Int64=100,
    m0::Int64=10,
    growth_rate::Int64=4,
    new_follows::Int64=4,
    initial_follows::Int64=4
    )
    return (agent_count=agent_count,m0=m0,growth_rate=growth_rate,new_follows=new_follows, initial_follows=initial_follows)
end

function cfg_sim(
    ;
    n_iter::Int64=100,
    max_inactive_ticks::Int64=2
    )
    return (n_iter=n_iter,max_inactive_ticks=max_inactive_ticks)
end

function cfg_ot(
    ;
    like::Float64 = 0.2,
    retweet::Float64 = 0.3,
    backfire::Float64 = 0.4,
    check_unease::Float64 = 0.3,
    follow::Float64 = 0.2,
    unfollow::Float64 = 0.4
    )
    return (like=like,retweet=retweet,backfire=backfire,check_unease=check_unease,follow=follow,unfollow=unfollow)
end

function cfg_ag(
    ;
    own_opinion_weight::Float64 = 0.99,
    check_decrease::Float64 = 0.9,
    inclin_interact_lambda::Float64 = log(25),
    unfollow_rate::Float64 = 0.2,
    )
    return (own_opinion_weight=own_opinion_weight,check_decrease=check_decrease,inclin_interact_lambda=inclin_interact_lambda,unfollow_rate=unfollow_rate)
end

function cfg_feed(
    ;
    feed_size::Int64 = 10,
    tweet_decay::Float64 = 0.5
    )
    return (feed_size = feed_size, tweet_decay = tweet_decay)
end

struct Config
    network::NamedTuple{(:agent_count, :m0, :growth_rate, :new_follows, :initial_follows),NTuple{5,Int64}}
    simulation::NamedTuple{(:n_iter, :max_inactive_ticks),NTuple{2,Int64}}
    opinion_treshs::NamedTuple{(:like, :retweet, :backfire, :check_unease, :follow, :unfollow),NTuple{6,Float64}}
    agent_props::NamedTuple{(:own_opinion_weight, :check_decrease, :inclin_interact_lambda, :unfollow_rate),NTuple{4,Float64}}
    feed_props::NamedTuple{(:feed_size, :tweet_decay), <:Tuple{Int64, Float64}}

    function Config(;network = cfg_net(), simulation = cfg_sim(), opinion_treshs = cfg_ot(), agent_props = cfg_ag(), feed_props = cfg_feed())

        new(network, simulation, opinion_treshs, agent_props, feed_props)
    end
end
