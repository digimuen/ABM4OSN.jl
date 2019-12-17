"""
    tick!(state, tweet_list, tick_nr, config)

Runs a single tick of the simulation and returns the updated state and simulation logs.

# Arguments
- `state`: a tuple of the current graph and agent_list
- `tweet_list`: List of all published tweets in network
- `tick_nr`: Number of current simulation tick
- `config`: Config object as provided by Config()

See also: [log_network](@ref), [simulate!](@ref), [Config](@ref)
"""
function tick!(
    state::Tuple{AbstractGraph, AbstractArray}, tweet_list::AbstractArray,
    tick_nr::Int64, config::Config
)
    agent_list = state[2]
    for agent_idx in shuffle(1:length(agent_list))
        this_agent = agent_list[agent_idx]
        if this_agent.active && (rand() < this_agent.check_regularity)
            update_feed!(state, agent_idx, config)
            update_perceiv_publ_opinion!(state, agent_idx)
            update_opinion!(state, agent_idx, config)
            like(state, agent_idx, config)
            retweet!(state, agent_idx, config)
            drop_input!(state, agent_idx, config)
            if indegree(state[1], agent_idx) / nv(state[1]) * 2 < rand()
                add_input!(state, agent_idx, tweet_list, config)
            end
            inclin_interact = deepcopy(this_agent.inclin_interact)
            while inclin_interact > 0
                if rand() < inclin_interact
                    publish_tweet!(state, tweet_list, agent_idx, tick_nr)
                end
                inclin_interact -= 1.0
            end
            update_check_regularity!(state, agent_idx, config)
            this_agent.inactive_ticks = 0
        elseif this_agent.active
            this_agent.inactive_ticks += 1
            if this_agent.inactive_ticks > config.simulation.max_inactive_ticks
                set_inactive!(state, agent_idx, tweet_list)
            end
        end
    end
    update_network!(state, config)
    return log_network(state, tick_nr)
end

"""
    simulate(config)

Creates the initial state, performs and logs simulation ticks and returns the collected data

# Arguments
- `config`: Config object as provided by Config()

See also: [log_network](@ref), [tick!](@ref), [Config](@ref)
"""
function simulate(
    config::Config = Config(); batch_desc::String=""
)
    graph = create_network(config.network.agent_count, config.network.m0)
    init_state = (graph, create_agents(graph))
    state = deepcopy(init_state)
    tweet_list = Array{Tweet, 1}(undef, 0)
    graph_list = Array{AbstractGraph, 1}([graph])
    df = DataFrame(
        TickNr = Int64[],
        AgentID = Int64[],
        Opinion = Float64[],
        PerceivPublOpinion = Float64[],
        InclinInteract = Float64[],
        InactiveTicks = Int64[],
        Indegree = Float64[],
        ActiveState = Bool[]
    )
    if !in("tmp", readdir())
        mkdir("tmp")
    end
    if batch_desc == ""
        print("Current Tick: 0")
    end
    for i in 1:config.simulation.n_iter
        current_network = deepcopy(state[1])
        rem_vertices!(current_network, [agent.id for agent in state[2] if !agent.active])
        if batch_desc == ""
            print('\r')
            print("Current Tick: $i, current AVG agents connection count::" * string(round(ne(current_network)/nv(current_network))) * ", max outdegree: " * string(maximum(outdegree(current_network))) * ", mean outdegree: " * string(mean(outdegree(current_network))) * ", current Tweets: " * string(length(tweet_list)))
        end
        append!(df, tick!(state, tweet_list, i, config))
        if i % ceil(config.simulation.n_iter / 10) == 0
            if batch_desc != ""
                print(".")
            end
            push!(graph_list, current_network)

            save(("./tmp/" * batch_desc * "_tmpstate.jld2"), string(i), (string(config), (df, tweet_list, graph_list), state, init_state))
        end

    end

    tweet_df = DataFrame(
        Opinion = [t.opinion for t in tweet_list],
        Weight = [t.weight for t in tweet_list],
        Source_Agent = [t.source_agent for t in tweet_list],
        Published_At = [t.published_at for t in tweet_list],
        Seen = [t.seen for t in tweet_list],
        Likes = [t.like_count for t in tweet_list],
        Retweets = [t.retweet_count for t in tweet_list]
    )

    save(("./results/" * batch_desc * "_results.jld2"), batch_desc, (string(config), (df, tweet_df, graph_list), state, init_state))
    rm("./tmp/" * batch_desc * "_tmpstate.jld2")

    print("\n---\nFinished simulation run with the following specifications:\n $config\n---\n")

    return (df, tweet_df, graph_list), state, init_state
end

# suppress output of include()
;
