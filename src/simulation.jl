"""
    Simulation(config, init_state, final_state, agent_log, post_log, graph_list)

Provide data structure for a simulation.

# Examples
```julia-repl
julia>using ABM4OSN

julia>Simulation()
Simulation{Config, Any, Any, DataFrame, Any, Array{AbstractGraph}}
```

# Arguments
- `config`: Config object as provided by Config
- `init_state`: Initial graph and agent_list of Simulation
- `final_state`: Final graph and agent_list of Simulation
- `agent_log`: DataFrame that logs the agent states at each simulation tick
- `post_log`: During simulation holds an array of all posts, for output converted to DataFrame
- `graph_list`: Array of graphs which are generated at 10%-intermediate steps of simulation

See also: [Post](@ref), [generate_opinion](@ref), [generate_inlinc_interact](@ref), [generate_check_regularity](@ref), [generate_desired_input_count](@ref)
"""
mutable struct Simulation

	name::String
	batch_name::String
	repnr::Int64
	config::Config
	rng::MersenneTwister
    init_state::Any
    final_state::Any
    agent_log::DataFrame
    post_log::Any
    graph_list::Array{AbstractGraph}

    function Simulation(config=Config(); batch_name="")
        new(
			"",
			batch_name,
			0,
            config,
			MersenneTwister(),
            (nothing, nothing),
            (nothing, nothing),
            DataFrame(),
            DataFrame(),
            Array{AbstractGraph, 1}(undef, 0)
        )
    end

end

# Base.show(io::IO, s::Simulation) = print(
#     io, "Simulation{Config, Any, Any, DataFrame, Any, Array{AbstractGraph}}"
# )

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
    state::Tuple{AbstractGraph, AbstractArray},
    post_list::AbstractArray,
    tick_nr::Int64,
	config::Config
)

    agent_list = state[2]

    for agent_idx in shuffle(1:length(agent_list))

        this_agent = agent_list[agent_idx]

        if this_agent.active && (rand() < this_agent.check_regularity)

            this_agent.inactive_ticks = 0
            update_feed!(state, agent_idx, config)
            update_perceiv_publ_opinion!(state, agent_idx)
            update_opinion!(state, agent_idx, config)

            if config.mechanics.like
                like!(state, agent_idx, config)
            end

            if config.mechanics.dislike
                dislike!(state, agent_idx, config)
            end

            if config.mechanics.share
                share!(state, agent_idx, config)
            end

            if config.mechanics.dynamic_net
                drop_input!(state, agent_idx, config)
				if (
					indegree(state[1], agent_idx)
					< this_agent.desired_input_count
				)
					add_input!(state, agent_idx, post_list, config)
				end
				update_check_regularity!(state, agent_idx, config)
			else
				update_input!(state, agent_idx, config)
			end

            inclin_interact = deepcopy(this_agent.inclin_interact)
            while inclin_interact > 0
                if rand() < inclin_interact
                    publish_post!(state, post_list, agent_idx, tick_nr)
                end
                inclin_interact -= 1.0
            end

        elseif this_agent.active
            this_agent.inactive_ticks += 1
            if (
                this_agent.inactive_ticks > config.simulation.max_inactive_ticks
                && config.mechanics.dynamic_net
            )
                set_inactive!(state, agent_idx, post_list)
            end
        end

    end

    if config.mechanics.dynamic_net
        update_network!(state, config)
    end

    return log_network(state, tick_nr)

end

"""
    run!(simulation=Simulation(); [name="_"])

Creates the initial state, performs and logs simulation ticks and returns the collected data

# Arguments
- `simulation`: Simulation object that provides data structure for simulation results and a config
- `name`: Name of current simulation

See also: [rerun_single!](@ref), [log_network](@ref), [tick!](@ref), [Config](@ref)
"""
function run!(
    simulation::Simulation=Simulation()
    ;
    name::String="_"
)

	if "results" in readdir() && name * ".jld2" in readdir("results")
		raw = load(joinpath("results", name * ".jld2"))
		rep = raw[first(keys(raw))]
	else
		rep = Simulation[]
	end

	for current_rep in 1:simulation.config.simulation.repcount

		simulation.name = name
		simulation.repnr = length(rep) + 1
		simulation.rng = Random.seed!(sum(codeunits(name)) + simulation.repnr)

		agent_list = create_agents(simulation.config)
	    simulation.init_state = (
	        create_network(agent_list, simulation.config), agent_list
	    )
	    state = deepcopy(simulation.init_state)
	    post_log = Array{Post, 1}(undef, 0)

		if simulation.config.simulation.logging
		    simulation.graph_list = Array{AbstractGraph, 1}([simulation.init_state[1]])
		    agent_log = DataFrame(
		        TickNr = Int64[],
		        AgentID = Int64[],
		        Opinion = Float64[],
		        PerceivPublOpinion = Float64[],
		        CheckRegularity = Float64[],
		        InclinInteract = Float64[],
		        DesiredInputCount = Int64[],
		        InactiveTicks = Int64[],
		        Indegree = Int64[],
		        Outdegree = Int64[],
		        ActiveState = Bool[]
		    )
		end

	    for i in 1:simulation.config.simulation.n_iter

			if simulation.config.simulation.logging
				append!(
					agent_log,
					tick!(state, post_log, i, simulation.config))
			else
				tick!(state, post_log, i, simulation.config)
			end


	        if i % ceil(simulation.config.simulation.n_iter / 10) == 0

	            print(".")

				if (
					simulation.config.simulation.logging
					&& simulation.config.mechanics.dynamic_net
				)
					current_network = deepcopy(state[1])
		            rem_vertices!(
		                current_network,
		                [agent.id for agent in state[2] if !agent.active]
		            )
		            push!(simulation.graph_list, current_network)
				end
	        end
	    end

	    simulation.final_state = state
		if simulation.config.simulation.logging
			simulation.agent_log = agent_log
		    simulation.post_log = DataFrame(
		        Opinion = [p.opinion for p in post_log],
		        Weight = [p.weight for p in post_log],
		        Source_Agent = [p.source_agent for p in post_log],
		        Published_At = [p.published_at for p in post_log],
		        Seen = [p.seen_by for p in post_log],
		        Likes = [p.like_count for p in post_log],
		        Dislikes = [p.dislike_count for p in post_log],
		        Reposts = [p.share_count for p in post_log]
		    )
		end

		push!(rep, deepcopy(simulation))

		if !in("results", readdir())
	        mkdir("results")
	    end
    	save(joinpath("results", name * ".jld2"), name, rep)
	end

    print(
        "\n---\nFinished simulation run with the following specifications:\n
        $(simulation.config)\n---\n"
    )

    return rep

end

"""
    run_batch(config_list; batch_desc)

Creates the initial state, performs and logs simulation ticks and returns the collected data

# Arguments
- `config_list`: List of `Config` objects as provided by `Config()`
- `batch_name`: Name of current simulation batch

See also: [run!](@ref), [rerun_single!](@ref), [tick!](@ref), [Config](@ref)
"""
function run_batch(
    config_list::Array{Config, 1}
    ;
    resume_at::Int64=1,
    stop_at::Int64=length(config_list),
    batch_name::String = ""
)
    for i in resume_at:stop_at
        run_nr = lpad(string(i),length(string(length(config_list))),"0")
        run!(
            Simulation(config_list[i], batch_name=batch_name),
            name = (batch_name * "_run$run_nr")
        )
    end
end

"""
    rerun_single!(path)

Repeats a single simulation run with detailed simulation tracking

# Arguments
- `simulation_imported`: Simulation object of the run that shall be repeated
- `logging`: Bool for activating the detailed logging

See also: [run_batch](@ref), [run!](@ref), [tick!](@ref), [Config](@ref)
"""
function rerun_single!(
    simulation_imported::Simulation;
    logging::Bool = true
    )
    simulation = deepcopy(simulation_imported)

    simulation.config = Config(
        network = simulation.config.network,
        simulation = cfg_sim(
			n_iter = simulation.config.simulation.n_iter,
			max_inactive_ticks = simulation.config.simulation.max_inactive_ticks,
            repcount = simulation.config.simulation.repcount,
            logging = logging
        ),
        opinion_threshs = simulation.config.opinion_threshs,
        agent_props = simulation.config.agent_props,
		feed_props = simulation.config.feed_props,
		mechanics = simulation.config.mechanics
    )

	Random.seed!(simulation.rng.seed)
	agent_list = create_agents(simulation.config)
	simulation.init_state = (
		create_network(agent_list, simulation.config), agent_list
	)
	state = deepcopy(simulation.init_state)
	post_log = Array{Post, 1}(undef, 0)

	if simulation.config.simulation.logging
		simulation.graph_list = Array{AbstractGraph, 1}([simulation.init_state[1]])
		agent_log = DataFrame(
			TickNr = Int64[],
			AgentID = Int64[],
			Opinion = Float64[],
			PerceivPublOpinion = Float64[],
			CheckRegularity = Float64[],
			InclinInteract = Float64[],
			DesiredInputCount = Int64[],
			InactiveTicks = Int64[],
			Indegree = Int64[],
			Outdegree = Int64[],
			ActiveState = Bool[]
		)
	end

	for i in 1:simulation.config.simulation.n_iter

		if simulation.config.simulation.logging
			append!(
				agent_log,
				tick!(state, post_log, i, simulation.config))
		else
			tick!(state, post_log, i, simulation.config)
		end


		if i % ceil(simulation.config.simulation.n_iter / 10) == 0

			print(".")

			if (
				simulation.config.simulation.logging
				&& simulation.config.mechanics.dynamic_net
			)
				current_network = deepcopy(state[1])
				rem_vertices!(
					current_network,
					[agent.id for agent in state[2] if !agent.active]
				)
				push!(simulation.graph_list, current_network)
			end
		end
	end

	simulation.final_state = state
	if simulation.config.simulation.logging
		simulation.agent_log = agent_log
		simulation.post_log = DataFrame(
			Opinion = [p.opinion for p in post_log],
			Weight = [p.weight for p in post_log],
			Source_Agent = [p.source_agent for p in post_log],
			Published_At = [p.published_at for p in post_log],
			Seen = [p.seen_by for p in post_log],
			Likes = [p.like_count for p in post_log],
			Dislikes = [p.dislike_count for p in post_log],
			Reposts = [p.share_count for p in post_log]
		)
	end

	if !in("results", readdir())
        mkdir("results")
    end
    save(joinpath("results", simulation.name * "_singlerun.jld2"), simulation.name, simulation)

	return simulation
end


# suppress output of include()
;
