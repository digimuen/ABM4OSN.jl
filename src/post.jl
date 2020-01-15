"""
    Post(opinion, weight, source_agent, published_at)

Provide data structure for posts of agents within agent-based simulation.

# Examples
```julia-repl
julia>Post(0, 0, 1, 1)
Post(0.0, 0.0 , 1, 1, Int[], 0, 0, 0)
```

# Arguments
- `opinion`: opinion value between -1 and 1
- `weight`: weight value for importance of post
- `source_agent`: ID of origin agent of post
- `published_at`: publication time of post
- `seen_by`: List of agents that saw it in their feed
- `like_count`: Number of post likes
- `dislike_count`: Number of post dislikes
- `share_count`: Number of post shares


See also: [Agent](@ref), [update_feed!](@ref)
"""
mutable struct Post
    opinion::Float64
    weight::Float64
    source_agent::Int64
    published_at::Int64
    seen_by::Array{Int64, 1}
    like_count::Int64
    dislike_count::Int64
    share_count::Int64

    function Post(
        opinion,
        weight,
        source_agent,
        published_at
    )

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
            Int64[],
            0,
            0,
            0
        )
    end
end

Base.:isless(x::Post, y::Post) = x.weight < y.weight

# suppress output of include()
;
