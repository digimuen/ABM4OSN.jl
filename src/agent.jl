"""
    Agent(id, opinion, inclin_interact, check_regularity, desired_input_count)

Provide data structure for agents within agent-based simulation.

# Examples
```julia-repl
julia>using ABM4OSN

julia>ABM4OSN.Agent(0, 0, 0, 0, 0)
ABM4OSN.Agent(0, 0.0, 0.0, 0.0, 0.0, 0, true, 0, ABM4OSN.Post[], ABM4OSN.Post[], ABM4OSN.Post[], ABM4OSN.Post[])
```

# Arguments
- `id`: Agent identifier within simulation
- `opinion`: Opinion value between -1 and 1
- `inclin_interact`: Value for inclination to interact between 0 and 1
- `check_regularity`: Value for check regularity between 0 and 1
- `desired_input_count`: How many other agents an agent ideally wants to follow

See also: [Post](@ref), [generate_opinion](@ref), [generate_inclin_interact](@ref), [generate_check_regularity](@ref), [generate_desired_input_count](@ref)
"""
mutable struct Agent

    id::Int64
    opinion::Float64
    inclin_interact::Float64
    perceiv_publ_opinion::Float64
    check_regularity::Float64
    desired_input_count::Int64
    active::Bool
    inactive_ticks::Int16
    feed::Array{Post, 1}
    liked_posts::Array{Post, 1}
    disliked_posts::Array{Post, 1}
    shared_posts::Array{Post, 1}

    function Agent(
        id,
        opinion,
        inclin_interact,
        check_regularity,
        desired_input_count
    )

        if opinion < -1 || opinion > 1
            error("invalid opinion value")
        end
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
            Array{Post, 1}(undef, 0),
            Array{Post, 1}(undef, 0)
        )

    end

end

# suppress output of include()
;
