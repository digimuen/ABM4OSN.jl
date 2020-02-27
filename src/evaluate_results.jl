"""
    evaluate_results(;[simname=""])

Convert simulation results for data exchange with other frameworks.

# Arguments
- `simname`: Path to a specific .jld file to be converted

See also: [Config](@ref), [cfg_sim](@ref), [cfg_ot](@ref), [cfg_ag](@ref), [cfg_feed](@ref), [cfg_mech](@ref)
"""
function evaluate_results(
    ;
    simname::String=""
)

    evalqueue = Array{Simulation, 1}[]

    if simname != ""

        raw_data = load(joinpath("results", simname))
        data = raw_data[first(keys(raw_data))]

        push!(evalqueue, data)

    else
        for simname in readdir("results")
            raw_data = load(joinpath("results", simname))
            data = raw_data[first(keys(raw_data))]

            push!(evalqueue, data)
        end
    end

    for simarray in evalqueue
        results = DataFrame(
            RunName = String[],
            ConfigAgentCount = Int64[],
            ConfigUnfriendThresh = Float64[],
            ConfigAddfriendMethod = String[],
            Densities = Float64[],
            OutdegreeSD = Float64[],
            IndegreeSD = Float64[],
            OutdegreeIndegreeRatioMean = Float64[],
            ClosenessCentralityMean = Float64[],
            BetweennessCentralityMean = Float64[],
            EigenCentralityMean = Float64[],
            ClustCoeff = Float64[],
            CommunityCount = Int64[],
            CommunityCountNontrivial = Int64[],
            ConnectedComponents = Int64[],
            OpinionSD = Float64[],
            OpChangeDeltaMean = Float64[],
            PublOwnOpinionDiff = Float64[],
            SupernodeOutdegree = Int64[],
            SupernodeCloseness = Float64[],
            SupernodeBetweenness = Float64[],
            SupernodeEigen = Float64[],
            SupernodeOpinion = Float64[],
            Supernode1st2ndOpdiff = Float64[],
            CommunityOpMeanSDs = Float64[]
        )

        for simulation in simarray

            repcount = length(simulation)
            nodes_ranked = [first.(sort([(i, outdegree(simulation[j].final_state[1], i)) for i in 1:nv(simulation[j].final_state[1])], by=last, rev=true)) for j in 1:repcount]

            opinionsd = [std([agent.opinion for agent in simulation[i].final_state[2]]) for i in 1:repcount]
            opchange_delta_mean = [mean([abs(simulation[j].init_state[2][i].opinion - simulation[j].final_state[2][i].opinion) for i in 1:simulation[j].config.network.agent_count]) for j in 1:repcount]
            densities = [density(simulation[i].final_state[1]) for i in 1:repcount]
            outdegree_sd = [std(outdegree(simulation[i].final_state[1])) for i in 1:repcount]
            outdegree_mean = [mean(outdegree(simulation[i].final_state[1])) for i in 1:repcount]
            indegree_sd = [std(indegree(simulation[i].final_state[1])) for i in 1:repcount]
            outinratio = [mean([outdegree(simulation[i].final_state[1], j) / degree(simulation[i].final_state[1], j) for j in 1:nv(simulation[i].final_state[1]) if degree(simulation[i].final_state[1], j) > 0]) for i in 1:repcount]
            publownopiniondiff = [mean([abs(agent.perceiv_publ_opinion - agent.opinion) for agent in simulation[i].final_state[2]]) for i in 1:repcount]
            closeness_centrality_mean = [mean(closeness_centrality(simulation[i].final_state[1])) for i in 1:repcount]
            betweenness_centrality_mean = [mean(betweenness_centrality(simulation[i].final_state[1])) for i in 1:repcount]
            eigen_centrality_mean = [mean(eigenvector_centrality(simulation[i].final_state[1])) for i in 1:repcount]
            supernode_outdegree = [outdegree(simulation[i].final_state[1], nodes_ranked[i][1]) for i in 1:repcount]
            supernode_closeness = [closeness_centrality(simulation[i].final_state[1])[nodes_ranked[i][1]] for i in 1:repcount]
            supernode_betweenness = [betweenness_centrality(simulation[i].final_state[1])[nodes_ranked[i][1]] for i in 1:repcount]
            supernode_eigen = [eigenvector_centrality(simulation[i].final_state[1])[nodes_ranked[i][1]] for i in 1:repcount]
            supernode_opinion = [simulation[i].final_state[2][nodes_ranked[i][1]].opinion for i in 1:repcount]
            supernode1st2nd_opdiff = [abs(simulation[i].final_state[2][nodes_ranked[i][1]].opinion - simulation[i].final_state[2][nodes_ranked[i][2]].opinion) for i in 1:repcount]
            clust_coeff = [global_clustering_coefficient(simulation[i].final_state[1]) for i in 1:repcount]
            conn_components = [length(connected_components(simulation[i].final_state[1])) for i in 1:repcount]

            # Calc the SD of the opinion means of the identified clusters
            n_communities = Int64[]
            community_opinion_mean_sds = Float64[]
            n_communities_nontrivial = Int64[]
            for i in 1:repcount
                label_prop = label_propagation(simulation[i].final_state[1])[1]
                community_sizes = last.(collect(countmap(label_prop)))
                push!(n_communities_nontrivial, length([i for i in community_sizes if i > 1]))
                push!(n_communities, maximum(label_prop))
                if maximum(label_prop) == 1
                    push!(community_opinion_mean_sds, 0)
                    continue
                end
                push!(community_opinion_mean_sds, std([mean([agent.opinion for agent in simulation[i].final_state[2] if agent.id in findall(x->x==j, label_prop)]) for j in 1:maximum(label_prop)]))
            end

            append!(
                results,
                DataFrame(
                    RunName = simulation.name,
                    Densities = densities,
                    OutdegreeSD = outdegree_sd,
                    IndegreeSD = indegree_sd,
                    OutdegreeIndegreeRatioMean = outinratio,
                    ClosenessCentralityMean = closeness_centrality_mean,
                    BetweennessCentralityMean = betweenness_centrality_mean,
                    EigenCentralityMean = eigen_centrality_mean,
                    ClustCoeff = clust_coeff,
                    CommunityCount = n_communities,
                    CommunityCountNontrivial = n_communities_nontrivial,
                    ConnectedComponents = conn_components,
                    OpinionSD = opinionsd,
                    OpChangeDeltaMean = opchange_delta_mean,
                    PublOwnOpinionDiff = publownopiniondiff,
                    SupernodeOutdegree = supernode_outdegree,
                    SupernodeCloseness = supernode_closeness,
                    SupernodeBetweenness = supernode_betweenness,
                    SupernodeEigen = supernode_eigen,
                    SupernodeOpinion = supernode_opinion,
                    Supernode1st2ndOpdiff = supernode1st2nd_opdiff,
                    CommunityOpMeanSDs = community_opinion_mean_sds
                )
            )
        end

        if simulation.batch_name == ""
            if !in(simulation.name, readdir("dataexchange"))
                mkdir(joinpath("dataexchange", simulation.name))
            end

            CSV.write(
                joinpath(
                    "dataexchange",
                    "simulation.name",
                    "results_" * simulation.name * ".csv"
                ),
                results
            )

        else
            if !in(simulation.batch_name, readdir("dataexchange"))
                mkdir(joinpath("dataexchange", simulation.batch_name))
            end

            CSV.write(
                joinpath(
                    "dataexchange",
                    "simulation.batch_name",
                    "results_" * simulation.name * ".csv"
                ),
                results
            )
        end

    end



end
