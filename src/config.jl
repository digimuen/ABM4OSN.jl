"""
    cfg_net(;[agent_count=100, growth_rate=4, new_follows=4])

Define configuration parameters for the network.

# Example
```julia-repl
julia>using ABM4OSN

julia>cfg_net()
(agent_count = 100, growth_rate = 4, new_follows = 4)
```

# Arguments
- `agent_count`: How many agents are in the simulation
- `growth_rate`: How many agents to add each tick
- `new_follows`: How many new agent an agent follows each tick

See also: [Config](@ref), [cfg_sim](@ref), [cfg_ot](@ref), [cfg_ag](@ref), [cfg_feed](@ref), [cfg_mech](@ref)
"""
function cfg_net(
    ;
    agent_count::Int64=100,
    growth_rate::Int64=4,
    new_follows::Int64=4
)
    return (
        agent_count=agent_count,
        growth_rate=growth_rate,
        new_follows=new_follows
    )
end

"""
    cfg_sim(;[n_iter=100, max_inactive_ticks=2])

Define configuration parameters for the simulation run.

# Example
```julia-repl
julia>using ABM4OSN

julia>cfg_sim()
(n_iter = 100, max_inactive_ticks = 2, logging = false)
```

# Arguments
- `n_iter`: Number of iterations
- `max_inactive_ticks`: After how many ticks an agent's status is set to inactive
- `Logging`: Determines if extended logging on simulation run is performed

See also: [Config](@ref), [cfg_net](@ref), [cfg_ot](@ref), [cfg_ag](@ref), [cfg_feed](@ref), [cfg_mech](@ref)
"""
function cfg_sim(
    ;
    n_iter::Int64=100,
    max_inactive_ticks::Int64=2,
    logging::Bool=false,
    repcount::Int64=1
)
    return (
        n_iter=n_iter,
        max_inactive_ticks=max_inactive_ticks,
        logging=logging,
        repcount=repcount
    )
end

"""
    cfg_ot(;[like=0.2, share=0.3, backfire=0.4, check_unease=0.3, follow=0.2, unfollow=0.4])

Define thresholds for opinion differences.

# Example
```julia-repl
julia using ABM4OSN

julia>cfg_ot()
(like = 0.2, share = 0.3, backfire = 0.5, check_unease = 0.4, follow = 0.3, unfollow = 0.5)
```

# Arguments
- `like`: Opinion difference threshold for likes
- `share`:  Opinion difference threshold for shares
- `backfire`: Opinion difference for the backfire effect
- `check_unease`: Opinion difference threshold for lowering check regularity
- `follow`: Opinion difference threshold for follows
- `unfollow`: Opinion difference threshold for unfollows

See also: [Config](@ref), [cfg_net](@ref), [cfg_sim](@ref), [cfg_ag](@ref), [cfg_feed](@ref), [cfg_mech](@ref)
"""
function cfg_ot(
    ;
    like::Float64=0.2,
    share::Float64=0.3,
    backfire::Float64=0.5,
    check_unease::Float64=0.4,
    follow::Float64=0.3,
    unfollow::Float64=0.5
)
    return (
        like=like,
        share=share,
        backfire=backfire,
        check_unease=check_unease,
        follow=follow,
        unfollow=unfollow
    )
end

"""
    cfg_ag(;[own_opinion_weight=0.95, check_decrease=0.9, inclin_interact_lambda=log(25), unfollow_rate=0.05, min_input_count=0, mean_desired_input_count=100])

Define agent parameters.

# Example
```julia-repl
julia>using ABM4OSN

julia>cfg_ag()
(own_opinion_weight = 0.99, check_decrease = 0.9, inclin_interact_lambda = 3.2188758248682006, unfollow_rate = 0.2, mean_desired_input_count = 100)
```

# Arguments
- `own_opinion_weight`: Weight of own opinion in relation to other opinions
- `check_decrease`: Decrease factor for check regularity
- `inclin_interact_lambda`: Lambda for exponential distribution for inclination to interact
- `unfollow_rate`: Fraction of agents to unfollow each tick
- `min_input_count`: Minimum input count for an agent to stay in the network
- `mean_desired_input_count`: Mean of desired input count over all agents

See also: [Config](@ref), [cfg_net](@ref), [cfg_sim](@ref), [cfg_ot](@ref), [cfg_feed](@ref), [cfg_mech](@ref)
"""
function cfg_ag(
    ;
    own_opinion_weight::Float64=0.95,
    check_decrease::Float64=0.9,
    inclin_interact_lambda::Float64=log(25),
    unfollow_rate::Float64=0.05,
    min_input_count::Int64=0,
    mean_desired_input_count::Int64=100
)
    return (
        own_opinion_weight=own_opinion_weight,
        check_decrease=check_decrease,
        inclin_interact_lambda=inclin_interact_lambda,
        unfollow_rate=unfollow_rate,
        min_input_count=min_input_count,
        mean_desired_input_count=mean_desired_input_count
    )
end

"""
    cfg_feed(;[feed_size=15, post_decay=0.5])

Define feed parameters.

# Example
```julia-repl
julia>using ABM4OSN

julia>cfg_feed()
(feed_size = 15, post_decay = 0.5)
```

# Arguments
- `feed_size`: length of post feed
- `post_decay`: decay factor for posts in each tick

See also: [Config](@ref), [cfg_net](@ref), [cfg_sim](@ref), [cfg_ot](@ref), [cfg_ag](@ref), [cfg_mech](@ref)
"""
function cfg_feed(
    ;
    feed_size::Int64=15,
    post_decay::Float64=0.5
)
    return (
        feed_size=feed_size,
        post_decay=post_decay
    )
end

"""
    cfg_mech(;[dynamic_net = false, like=true, dislike=true, share=true])

Define mechanics of the social network.

# Example
```julia-repl
julia>using ABM4OSN

julia>cfg_mech()
(dynamic_net = false, like = true, dislike = false, share = true)
```

# Arguments
- `dynamic_net`: Whether or not to include functionality 'dynamic net'
- `like`: Whether or not to include functionality 'like'
- `dislike`: Whether or not to include functionality 'dislike'
- `share`: Whether or not to include functionality 'share'

See also: [Config](@ref), [cfg_net](@ref), [cfg_sim](@ref), [cfg_ot](@ref), [cfg_ag](@ref), [cfg_feed](@ref)
"""
function cfg_mech(
    ;
    dynamic_net::Bool=false,
    like::Bool=true,
    dislike::Bool=false,
    share::Bool=true
)
    return (
        dynamic_net=dynamic_net,
        like=like,
        dislike=dislike,
        share=share
    )
end

"""
    Config(;[network=cfg_net(), simulation=cfg_sim(), opinion_threshs=cfg_ot(), agent_props=cfg_ag(), feed_props=cfg_feed(), mechanics=cfg_mech()])

Provide configuration parameters.

# Example
```julia-repl
julia>using ABM4OSN

julia> Config()
Config((agent_count = 100, growth_rate = 4, new_follows = 4), (n_iter = 100, max_inactive_ticks = 2), (like = 0.2, share = 0.3, backfire = 0.5, check_unease = 0.4, follow = 0.3, unfollow = 0.5), (own_opinion_weight = 0.95, check_decrease = 0.9, inclin_interact_lambda = 3.2188758248682006, unfollow_rate = 0.05, min_input_count = 0, mean_desired_input_count = 100), (feed_size = 15, post_decay = 0.5), (dynamic_net = false, like = true, dislike = false, share = true))
```

# Arguments
- `network`: Tuple of network parameters as created by `cfg_net`
- `simulation`: Tuple of simulation parameters as created by `cfg_sim`
- `opinion_threshs`: Tuple of opinion difference thresholds as created by `cfg_ot`
- `agent_props`: Tuple of agent parameters as created by `cfg_ag`
- `feed_props`: Tuple of feed parameters as created by `cfg_feed`
- `mechanics`: Tuple of mechanics configurations as created by `cfg_mech`

See also: [cfg_net](@ref), [cfg_sim](@ref), [cfg_ot](@ref), [cfg_ag](@ref), [cfg_feed](@ref), [cfg_mechanics](@ref)
"""
struct Config

    network::NamedTuple{
        (
            :agent_count,
            :growth_rate,
            :new_follows
        ),
        NTuple{3, Int64}
    }
    simulation::NamedTuple{
        (
            :n_iter,
            :max_inactive_ticks,
            :logging,
            :repcount
        ),
        <:Tuple{Int64, Int64, Bool, Int64}
    }
    opinion_threshs::NamedTuple{
        (
            :like,
            :share,
            :backfire,
            :check_unease,
            :follow,
            :unfollow
        ),
        NTuple{6, Float64}
    }
    agent_props::NamedTuple{
        (
            :own_opinion_weight,
            :check_decrease,
            :inclin_interact_lambda,
            :unfollow_rate,
            :min_input_count,
            :mean_desired_input_count
        ),
        <:Tuple{Float64, Float64, Float64, Float64, Int64, Int64}
    }
    feed_props::NamedTuple{
        (
            :feed_size,
            :post_decay
        ),
        <:Tuple{Int64, Float64}
    }
    mechanics::NamedTuple{
        (
            :dynamic_net,
            :like,
            :dislike,
            :share
        ),
        NTuple{4, Bool}
    }

    function Config(
        ;
        network=cfg_net(),
        simulation=cfg_sim(),
        opinion_threshs=cfg_ot(),
        agent_props=cfg_ag(),
        feed_props=cfg_feed(),
        mechanics=cfg_mech()
    )
        new(
            network,
            simulation,
            opinion_threshs,
            agent_props,
            feed_props,
            mechanics
        )
    end

end

# suppress output of include()
;
