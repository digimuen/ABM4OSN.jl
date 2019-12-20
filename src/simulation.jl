"""
    tick!(state, post_list, tick_nr, config)

Runs a single tick of the simulation and returns the updated state and simulation logs.

# Arguments
- `state`: a tuple of the current graph and agent_list
- `post_list`: List of all published posts in network
- `tick_nr`: Number of current simulation tick
- `config`: Config object as provided by Config()

See also: [log_network](@ref), [simulate!](@ref), [Config](@ref)
"""
function tick!(
    state::Tuple{AbstractGraph, AbstractArray}, post_list::AbstractArray,
    tick_nr::Int64, config::Config
)
    agent_list = state[2]
    for agent_idx in shuffle(1:length(agent_list))
        this_agent = agent_list[agent_idx]
        if this_agent.active && (rand() < this_agent.check_regularity)
            this_agent.inactive_ticks = 0
            update_feed!(state, agent_idx, config)
            update_perceiv_publ_opinion!(state, agent_idx)
            update_opinion!(state, agent_idx, config)
            like(state, agent_idx, config)
            share!(state, agent_idx, config)
            drop_input!(state, agent_idx, config)
            if indegree(state[1], agent_idx) < this_agent.desired_input_count
                add_input!(state, agent_idx, post_list, config)
            else
                if rand() < 0.4
                    add_input!(state, agent_idx, post_list, Config(network=cfg_net(new_follows = 1)))
                end
            end
            inclin_interact = deepcopy(this_agent.inclin_interact)
            while inclin_interact > 0
                if rand() < inclin_interact
                    publish_post!(state, post_list, agent_idx, tick_nr)
                end
                inclin_interact -= 1.0
            end
            update_check_regularity!(state, agent_idx, config)
        elseif this_agent.active
            this_agent.inactive_ticks += 1
            if this_agent.inactive_ticks > config.simulation.max_inactive_ticks
                set_inactive!(state, agent_idx, post_list)
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
    config::Config = Config(); batch_desc::String = "result"
)
    graph = create_network(config.network.agent_count, config.network.m0)
    init_state = (graph, create_agents(graph, config))
    state = deepcopy(init_state)
    post_list = Array{Post, 1}(undef, 0)
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
    if batch_desc == "result"
        print("Current Tick: 0")
    end
    for i in 1:config.simulation.n_iter
        current_network = deepcopy(state[1])
        rem_vertices!(current_network, [agent.id for agent in state[2] if !agent.active])
        if batch_desc == "result"
            print('\r')
            print("Current Tick: $i, current AVG agents connection count::" * string(round(ne(current_network)/nv(current_network))) * ", max outdegree: " * string(maximum(outdegree(current_network))) * ", mean outdegree: " * string(mean(outdegree(current_network))) * ", current Posts: " * string(length(post_list)))
        end
        append!(df, tick!(state, post_list, i, config))
        if i % ceil(config.simulation.n_iter / 10) == 0
            if batch_desc != "result"
                print(".")
            end
            push!(graph_list, current_network)

            save(joinpath("tmp", batch_desc * "_tmpstate.jld2"), string(i), (string(config), (df, post_list, graph_list), state, init_state))
        end

    end

    post_df = DataFrame(
        Opinion = [p.opinion for p in post_list],
        Weight = [p.weight for p in post_list],
        Source_Agent = [p.source_agent for p in post_list],
        Published_At = [p.published_at for p in post_list],
        Seen = [p.seen_by for p in post_list],
        Likes = [p.like_count for p in post_list],
        Reposts = [p.share_count for p in post_list]
    )

    if !in("results", readdir())
        mkdir("results")
    end
    save(joinpath("results", batch_desc * ".jld2"), batch_desc, (config, (df, post_df, graph_list), state, init_state))
    rm(joinpath("tmp", batch_desc * "_tmpstate.jld2"))

    print("\n---\nFinished simulation run with the following specifications:\n $config\n---\n")

    return config, (df, post_df, graph_list), state, init_state
end

function simulate_batch(
    configlist::Array{Config, 1};
    batch_desc::String = ""
    )

    for i in 1:length(configlist)
        simulate(configlist[i], batch_desc = (batch_desc * "_run$i"))
    end
end

function simulate_resume(
    tempresult::Dict{String, Any},
    batch_desc::String = ""
    )
    
    tick_nr = keys(tempresult)[1]
    config, (df, post_list, graph_list), state, init_state = collect(values(tempresult))[1]

    if !in("tmp", readdir())
        mkdir("tmp")
    end
    if batch_desc == "result"
        print("Current Tick: 0")
    end
    for i in tick_nr:config.simulation.n_iter
        current_network = deepcopy(state[1])
        rem_vertices!(current_network, [agent.id for agent in state[2] if !agent.active])
        if batch_desc == "result"
            print('\r')
            print("Current Tick: $i, current AVG agents connection count::" * string(round(ne(current_network)/nv(current_network))) * ", max outdegree: " * string(maximum(outdegree(current_network))) * ", mean outdegree: " * string(mean(outdegree(current_network))) * ", current Posts: " * string(length(post_list)))
        end
        append!(df, tick!(state, post_list, i, config))
        if i % ceil(config.simulation.n_iter / 10) == 0
            if batch_desc != "result"
                print(".")
            end
            push!(graph_list, current_network)

            save(joinpath("tmp", batch_desc * "_tmpstate2.jld2"), string(i), (string(config), (df, post_list, graph_list), state, init_state))
        end

    end

    post_df = DataFrame(
        Opinion = [p.opinion for p in post_list],
        Weight = [p.weight for p in post_list],
        Source_Agent = [p.source_agent for p in post_list],
        Published_At = [p.published_at for p in post_list],
        Seen = [p.seen_by for p in post_list],
        Likes = [p.like_count for p in post_list],
        Reposts = [p.share_count for p in post_list]
    )

    if !in("results", readdir())
        mkdir("results")
    end
    save(joinpath("results", batch_desc * ".jld2"), batch_desc, (config, (df, post_df, graph_list), state, init_state))
    rm(joinpath("tmp", batch_desc * "_tmpstate2.jld2"))

    print("\n---\nFinished simulation run with the following specifications:\n $config\n---\n")

    return config, (df, post_df, graph_list), state, init_state
end

# suppress output of include()
;
