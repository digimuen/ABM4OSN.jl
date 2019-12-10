"""
    generate_opinion()

Generate an opinion value for an agent.

See also: [`Agent`](@ref)
"""
function generate_opinion()
    return 2 * rand() - 1
end

"""
    generate_inclin_interact(lambda=log(25))

Generate a value for inclination to interact for an agent.

See also: [`Agent`](@ref)
"""
function generate_inclin_interact(lambda=log(25))
    # this function was adapted from:
    # https://www.johndcook.com/julia_rng.html
    if lambda <= 0.0
        error("mean must be positive")
    end
    -(1 / lambda) * log(rand())
end

"""
    generate_check_regularity()

Generate a check regularity value for an agent.

See also: [`Agent`](@ref)
"""
function generate_check_regularity()
    return 1 - (rand() / 4)^2
end

# suppress output of include()
;
