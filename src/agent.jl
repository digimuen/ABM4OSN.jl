mutable struct Agent
    opinion::Float64
    inclin_interact::Float64
    perceiv_publ_opinion::Float64
    check_regularity::Float64
    active::Bool
    inactive_ticks::Int16
    feed::Array{Tweet, 1}
    liked_Tweets::Array{Tweet, 1}
    retweeted_Tweets::Array{Tweet, 1}
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