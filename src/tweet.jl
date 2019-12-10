mutable struct Tweet
    opinion::Float64
    weight::Float64
    source_agent::Int64
    published_at::Int64
    like_count::Int64
    retweet_count::Int64
    function Tweet(opinion, weight, source_agent, published_at)
        # check if opinion value is valid
        if opinion < -1 || opinion > 1
            error("invalid opinion value")
        end
        if weight < 0
            error("invalid weight value")
        end
        new(
            opinion,
            weight,
            source_agent,
            published_at,
            0,
            0
        )
    end
end

Base.:<(x::Tweet, y::Tweet) = x.weight < y.weight
