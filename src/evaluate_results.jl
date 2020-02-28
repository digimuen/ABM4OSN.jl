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

    if !in("dataexchange", readdir())
        mkdir("dataexchange")
    end

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

    results = DataFrame(
        RunName = String[],
        RepNr = Int64[],
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

    for simarray in evalqueue

        repcount = length(simarray)
        nodes_ranked = [first.(sort([(i, outdegree(simarray[j].final_state[1], i)) for i in 1:nv(simarray[j].final_state[1])], by=last, rev=true)) for j in 1:repcount]

        opinionsd = [std([agent.opinion for agent in simarray[i].final_state[2]]) for i in 1:repcount]
        opchange_delta_mean = [mean([abs(simarray[j].init_state[2][i].opinion - simarray[j].final_state[2][i].opinion) for i in 1:simarray[j].config.network.agent_count]) for j in 1:repcount]
        densities = [density(simarray[i].final_state[1]) for i in 1:repcount]
        outdegree_sd = [std(outdegree(simarray[i].final_state[1])) for i in 1:repcount]
        outdegree_mean = [mean(outdegree(simarray[i].final_state[1])) for i in 1:repcount]
        indegree_sd = [std(indegree(simarray[i].final_state[1])) for i in 1:repcount]
        outinratio = [mean([outdegree(simarray[i].final_state[1], j) / degree(simarray[i].final_state[1], j) for j in 1:nv(simarray[i].final_state[1]) if degree(simarray[i].final_state[1], j) > 0]) for i in 1:repcount]
        publownopiniondiff = [mean([abs(agent.perceiv_publ_opinion - agent.opinion) for agent in simarray[i].final_state[2]]) for i in 1:repcount]
        closeness_centrality_mean = [mean(closeness_centrality(simarray[i].final_state[1])) for i in 1:repcount]
        betweenness_centrality_mean = [mean(betweenness_centrality(simarray[i].final_state[1])) for i in 1:repcount]
        eigen_centrality_mean = [mean(eigenvector_centrality(simarray[i].final_state[1])) for i in 1:repcount]
        supernode_outdegree = [outdegree(simarray[i].final_state[1], nodes_ranked[i][1]) for i in 1:repcount]
        supernode_closeness = [closeness_centrality(simarray[i].final_state[1])[nodes_ranked[i][1]] for i in 1:repcount]
        supernode_betweenness = [betweenness_centrality(simarray[i].final_state[1])[nodes_ranked[i][1]] for i in 1:repcount]
        supernode_eigen = [eigenvector_centrality(simarray[i].final_state[1])[nodes_ranked[i][1]] for i in 1:repcount]
        supernode_opinion = [simarray[i].final_state[2][nodes_ranked[i][1]].opinion for i in 1:repcount]
        supernode1st2nd_opdiff = [abs(simarray[i].final_state[2][nodes_ranked[i][1]].opinion - simarray[i].final_state[2][nodes_ranked[i][2]].opinion) for i in 1:repcount]
        clust_coeff = [global_clustering_coefficient(simarray[i].final_state[1]) for i in 1:repcount]
        conn_components = [length(connected_components(simarray[i].final_state[1])) for i in 1:repcount]

        # Calc the SD of the opinion means of the identified clusters
        n_communities = Int64[]
        community_opinion_mean_sds = Float64[]
        n_communities_nontrivial = Int64[]
        for i in 1:repcount
            label_prop = label_propagation(simarray[i].final_state[1])[1]
            community_sizes = last.(collect(countmap(label_prop)))
            push!(n_communities_nontrivial, length([i for i in community_sizes if i > 1]))
            push!(n_communities, maximum(label_prop))
            if maximum(label_prop) == 1
                push!(community_opinion_mean_sds, 0)
                continue
            end
            push!(community_opinion_mean_sds, std([mean([agent.opinion for agent in simarray[i].final_state[2] if agent.id in findall(x->x==j, label_prop)]) for j in 1:maximum(label_prop)]))
        end

        if simarray[1].batch_name != ""
            runname = ["Run$i" for i in 1:length(simarray)]
        else
            runname = simarray[1].name
        end

        append!(
            results,
            DataFrame(
                RunName = runname,
                RepNr = collect(1:repcount),
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

    if simarray[1].batch_name == ""
        if !in(simarray[1].name, readdir("dataexchange"))
            mkdir(joinpath("dataexchange", simarray[1].name))
        end

        CSV.write(
        joinpath(
        "dataexchange",
        simarray[1].name,
        "results_" * simarray[1].name * ".csv"
        ),
        results
        )
        

    else
        if !in(simarray[1].batch_name, readdir("dataexchange"))
            mkdir(joinpath("dataexchange", simarray[1].batch_name))
        end

        CSV.write(
        joinpath(
        "dataexchange",
        simarray[1].batch_name,
        "results.csv"
        ),
        results
        )
    end
end
