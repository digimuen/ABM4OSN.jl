"""
    Agent(opinion, inclin_interact, check_regularity)

Provide data structure for agents within agent-based simulation.

# Examples
```julia-repl
julia>Agent(0, 0, 0, 0, 0)
Agent(0, 0.0, 0.0 , 0.0, 0.0, 0.0, true, 0, Post[], Post[], Post[])
```

# Arguments
- `id`: agent identifier within simulation
- `opinion`: opinion value between -1 and 1
- `inclin_interact`: value for inclination to interact between 0 and 1
- `check_regularity`: value for check regularity between 0 and 1
- `desired_input_count`: how many other agents an agent ideally wants to follow

See also: [Post](@ref), [generate_opinion](@ref), [generate_inlinc_interact](@ref), [generate_check_regularity](@ref), [generate_desired_input_count](@ref)
"""
mutable struct Agent
    id::Int64
    opinion::Float64
    inclin_interact::Float64
    perceiv_publ_opinion::Float64
    check_regularity::Float64
    desired_input_count::Float64
    active::Bool
    inactive_ticks::Int16
    feed::Array{Post, 1}
    liked_posts::Array{Post, 1}
    shared_posts::Array{Post, 1}
    function Agent(id, opinion, inclin_interact, check_regularity, desired_input_count)
        # check if opinion value is valid
        if opinion < -1 || opinion > 1
            error("invalid opinion value")
        end
        # check if value for inclination to interact is valid
        if inclin_interact < 0
            error("invalid value for inclination to interact")
        end
        new(
            id,
            opinion,
            inclin_interact,
            opinion,
            check_regularity,
            desired_input_count,
            true,
            0,
            Array{Post, 1}(undef, 0),
            Array{Post, 1}(undef, 0),
            Array{Post, 1}(undef, 0)
        )
    end
end

# suppress output of include()
;
