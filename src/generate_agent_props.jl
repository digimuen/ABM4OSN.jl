function generate_opinion()
    return 2 * rand() - 1
end

# this function was adapted from:
# https://www.johndcook.com/julia_rng.html
function generate_inclin_interact(lambda=log(25))
    if lambda <= 0.0
        error("mean must be positive")
    end
    -(1 / lambda) * log(rand())
end

function generate_check_regularity()
    return 1 - (rand() / 4)^2
end
