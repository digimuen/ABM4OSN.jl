"""
    cfg_net(;[agent_count=100, m0=10, growth_rate=4, new_follows=4])

Define configuration parameters for the network in an agent-based simulation.

# Example
```julia-repl
julia>cfg_net()
(agent_count = 100, m0 = 10, growth_rate = 4, new_follows = 4)
```

# Arguments
- `agent_count`: how many agents the simulation
- `m0`: m0 parameter for Barabási-Albert model
- `growth_rate`: how many agents to add each tick
- `new_follows`: how many new agent an agent follows each tick

See also: [Config](@ref), [cfg_sim](@ref), [cfg_ot](@ref), [cfg_ag](@ref), [cfg_feed](@ref)
"""
function cfg_net(
    ;
    agent_count::Int64=100,
    m0::Int64=10,
    growth_rate::Int64=4,
    new_follows::Int64=4
)
    return (
        agent_count=agent_count,
        m0=m0,growth_rate=growth_rate,
        new_follows=new_follows
    )
end

"""
    cfg_sim(;[n_iter=100, max_inactive_ticks=2])

Define configuration parameters for the simulation run in an agent-based simulation.

# Example
```julia-repl
julia>cfg_sim()
(n_iter = 100, max_inactive_ticks = 2)
```

# Arguments
- `n_iter`: number of iterations
- `max_inactive_ticks`: after how many ticks an agent's status is set to inactive 

See also: [Config](@ref), [cfg_net](@ref), [cfg_ot](@ref), [cfg_ag](@ref), [cfg_feed](@ref)
"""
function cfg_sim(
    ;
    n_iter::Int64=100,
    max_inactive_ticks::Int64=2
)
    return (
        n_iter=n_iter,
        max_inactive_ticks=max_inactive_ticks
    )
end

"""
    cfg_ot(;[like=0.2, retweet=0.3, backfire=0.4, check_unease=0.3, follow=0.2, unfollow=0.4])

Define thresholds for opinion differences in an agent-based simulation.

# Example
```julia-repl
julia>cfg_ot()
(like = 0.2, retweet = 0.3, backfire = 0.4, check_unease = 0.3, follow = 0.2, unfollow = 0.4)
```

# Arguments
- `like`: opinion difference threshold for likes
- `retweet`:  opinion difference threshold for retweets
- `backfire`: opinion difference for the backfire effect
- `check_unease`: opinion difference threshold for lowering check regularity
- `follow`: opinion difference threshold for follows
- `unfollow`: opinion difference threshold for unfollows

See also: [Config](@ref), [cfg_net](@ref), [cfg_sim](@ref), [cfg_ag](@ref), [cfg_feed](@ref)
"""
function cfg_ot(
    ;
    like::Float64=0.2,
    retweet::Float64=0.3,
    backfire::Float64=0.4,
    check_unease::Float64=0.3,
    follow::Float64=0.2,
    unfollow::Float64=0.4
)
    return (
        like=like,
        retweet=retweet,
        backfire=backfire,
        check_unease=check_unease,
        follow=follow,
        unfollow=unfollow
    )
end

"""
    cfg_ag(;[own_opinion_weight=0.99, check_decrease=0.9, inclin_interact_lambda=log(25), unfollow_rate=0.2])

Define agent parameters in an agent-based simulation.

# Example
```julia-repl
julia>cfg_ag()
(own_opinion_weight = 0.99, check_decrease = 0.9, inclin_interact_lambda = 3.2188758248682006, unfollow_rate = 0.2)
```

# Arguments
- `own_opinion_weight`: weight of own opinion in relation to other opinions
- `check_decrease`: decrease factor for check regularity 
- `inclin_interact_lambda`: lambda for exponential distribution for inclination to interact 
- `unfollow_rate`: fraction of agents to unfollow each tick

See also: [Config](@ref), [cfg_net](@ref), [cfg_sim](@ref), [cfg_ot](@ref), [cfg_feed](@ref)
"""
function cfg_ag(
    ;
    own_opinion_weight::Float64=0.99,
    check_decrease::Float64=0.9,
    inclin_interact_lambda::Float64=log(25),
    unfollow_rate::Float64=0.2,
)
    return (
        own_opinion_weight=own_opinion_weight,
        check_decrease=check_decrease,
        inclin_interact_lambda=inclin_interact_lambda,
        unfollow_rate=unfollow_rate
    )
end

"""
    cfg_feed(;[feed_size=10, tweet_decay=0.5])

Define feed parameters in an agent-based simulation.

# Example
```julia-repl
julia>cfg_feed()
(feed_size = 10, tweet_decay = 0.5)
```

# Arguments
- `feed_size`: length of tweet feed 
- `tweet_decay`: decay factor for tweets in each tick

See also: [Config](@ref), [cfg_net](@ref), [cfg_sim](@ref), [cfg_ot](@ref), [cfg_ag](@ref)
"""
function cfg_feed(
    ;
    feed_size::Int64=10,
    tweet_decay::Float64=0.5
)
    return (
        feed_size=feed_size, 
        tweet_decay=tweet_decay
    )
end

"""
    Config(;[network=cfg_net(), simulation=cfg_sim(), opinion_treshs=cfg_ot(), agent_props=cfg_ag(), feed_props=cfg_feed()])

Provide configuration parameters for an agent-based simulation.

# Example
```julia-repl
julia>Config()
Config((agent_count = 100, m0 = 10, growth_rate = 4, new_follows = 4), (n_iter = 100, max_inactive_ticks = 2), (like = 0.2, retweet = 0.3, backfire = 0.4, check_unease = 0.3, follow = 0.2, unfollow = 0.4), (own_opinion_weight = 0.99, check_decrease = 0.9, inclin_interact_lambda = 3.2188758248682006, unfollow_rate = 0.2), (feed_size = 10, tweet_decay = 0.5))
```

# Arguments
- `network`: tuple of network parameters as created by cfg_net 
- `simulation`: tuple of simulation parameters as created by cfg_sim 
- `opinion_treshs`: tuple of opinion difference thresholds as created by cfg_ot
- `agent_props`: tuple of agent parameters as created by cfg_ag 
- `feed_props`: tuple of feed parameters as created by cfg_feed

See also: [cfg_net](@ref), [cfg_sim](@ref), [cfg_ot](@ref), [cfg_ag](@ref), [cfg_feed](@ref)
"""
struct Config
    network::NamedTuple{
        (:agent_count, :m0, :growth_rate, :new_follows), 
        NTuple{4,Int64}
    }
    simulation::NamedTuple{
        (:n_iter, :max_inactive_ticks), 
        NTuple{2,Int64}
    }
    opinion_treshs::NamedTuple{
        (:like, :retweet, :backfire, :check_unease, :follow, :unfollow), 
        NTuple{6,Float64}
    }
    agent_props::NamedTuple{
        (:own_opinion_weight, :check_decrease, :inclin_interact_lambda, :unfollow_rate), 
        NTuple{4,Float64}
    }
    feed_props::NamedTuple{
        (:feed_size, :tweet_decay), 
        <:Tuple{Int64, Float64}
    }
    # constructor
    function Config(
        ;
        network = cfg_net(), 
        simulation = cfg_sim(), 
        opinion_treshs = cfg_ot(), 
        agent_props = cfg_ag(), 
        feed_props = cfg_feed()
    )
        new(network, simulation, opinion_treshs, agent_props, feed_props)
    end
end

# suppress output of include()
;