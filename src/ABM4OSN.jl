"""
    ABM4OSN

Provide agent-based simulation environment for Online Social Networks.

# Examples
```julia-repl
julia>using ABM4OSN
```
"""
module ABM4OSN

    # requirements
    using LightGraphs
    using DataFrames
    using Statistics
    using Random
    using StatsBase
    using JLD
    using JLD2

    # contain structs
    include("config.jl")
    include("tweet.jl")
    include("agent.jl")
    include("network.jl")
    include("simulation.jl")

    # contain functions
    include("add_input.jl")
    include("create_agents.jl")
    include("drop_input.jl")
    include("generate_agent_props.jl")
    include("like.jl")
    include("log_network.jl")
    include("publish_tweet.jl")
    include("retweet.jl")
    include("set_inactive.jl")
    include("update_check_regularity.jl")
    include("update_feed.jl")
    include("update_opinion.jl")
    include("update_perceiv_publ_opinion.jl")

    # exports for user interaction
    export simulate
    export Config
    export cfg_ag
    export cfg_feed
    export cfg_net
    export cfg_ot
    export cfg_sim

end # module
