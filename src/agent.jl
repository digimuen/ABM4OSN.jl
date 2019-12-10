"""
    Agent(opinion, inclin_interact, check_regularity)

Provide data structure for agents within agent-based simulation.

# Examples
```julia-repl
julia>Agent(0, 0, 0)
Agent(0.0, 0.0 , 0.0, 0.0, true, 0, Tweet[], Tweet[], Tweet[])
```

# Arguments
- `opinion`: opinion value between -1 and 1
- `inclin_interact`: value for inclination to interact between 0 and 1
- `check_regularity`: value for check regularity between 0 and 1

See also: [Tweet](@ref), [generate_opinion](@ref), [generate_inlinc_interact](@ref), [generate_check_regularity](@ref)
"""
mutable struct Agent
    opinion::Float64
    inclin_interact::Float64
    perceiv_publ_opinion::Float64
    check_regularity::Float64
    active::Bool
    inactive_ticks::Int16
    feed::Array{Tweet, 1}
    liked_tweets::Array{Tweet, 1}
    retweeted_tweets::Array{Tweet, 1}
    function Agent(opinion, inclin_interact, check_regularity)
        # check if opinion value is valid
        if opinion < -1 || opinion > 1
            error("invalid opinion value")
        end
        # check if value for inclination to interact is valid
        if inclin_interact < 0
            error("invalid value for inclination to interact")
        end
        new(
            opinion,
            inclin_interact,
            opinion,
            check_regularity,
            true,
            0,
            Array{Tweet, 1}(undef, 0),
            Array{Tweet, 1}(undef, 0),
            Array{Tweet, 1}(undef, 0)
        )
    end
end

# suppress output of include()
;