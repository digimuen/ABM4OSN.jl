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
function generate_inclin_interact(
    lambda=log(25)
)
    # this function was adapted from:
    # https://www.johndcook.com/julia_rng.html
    if lambda <= 0.0
        error("mean must be positive")
    end
    return -(1 / lambda) * log(rand())
end

"""
    generate_check_regularity()

Generate a check regularity value for an agent.

See also: [`Agent`](@ref)
"""
function generate_check_regularity()
    return 1 - (rand() / 4)^2
end

"""
    generate_desired_input_count(mean)

Generate a desired input count value for an agent from the overall mean.

See also: [`Agent`](@ref)
"""
function generate_desired_input_count(
    mean
)
    # this function was adapted from:
    # https://www.johndcook.com/julia_rng.html
    if mean <= 0.0
        error("Mean must be positive")
    end
    stdev = mean / 4
    u1 = rand()
    u2 = rand()
    r = sqrt(-2.0 * log(u1))
    theta = 2.0 * pi * u2
    return trunc(Int, mean + stdev * r * sin(theta))
end

# suppress output of include()
;
