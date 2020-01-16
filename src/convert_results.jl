"""
    convert_results(;[specific_run=""])

Convert simulation results for data exchange with other frameworks.

# Arguments
- `specific_run`: Path to a specific .jld file to be converted

See also: [Config](@ref), [cfg_sim](@ref), [cfg_ot](@ref), [cfg_ag](@ref), [cfg_feed](@ref), [cfg_mech](@ref)
"""
function convert_results(
    ;
    specific_run::String=""
)

    if specific_run != ""

        raw_data = load(joinpath("results", specific_run))
        data = raw_data[first(keys(raw_data))]
        filename = specific_run[1:(first(findfirst(".jld2", specific_run)) - 1)]

        if !in(filename, readdir("dataexchange"))
            mkdir(joinpath("dataexchange", filename))
        end

        CSV.write(
            joinpath("dataexchange", filename, "agent_log" * ".csv"),
            data.agent_log
        )
        CSV.write(
            joinpath("dataexchange", filename, "post_log" * ".csv"),
            data.post_log
        )

        for i in 1:length(data.graph_list)
            graph_nr = lpad(
                string(i),
                length(string(length(graph_list))),
                "0"
            )
            savegraph(
                joinpath("dataexchange", filename, "graph_$graph_nr.gml"),
                data.graph_list[i],
                GraphIO.GML.GMLFormat()
            )
        end

    else

        if !in("dataexchange", readdir())
            mkdir("dataexchange")
        end

        for file in readdir("results")

            raw_data = load(joinpath("results", file))
            data = raw_data[first(keys(raw_data))]
            filename = file[1:(first(findfirst(".jld2", file)) - 1)]

            if !in(filename, readdir("dataexchange"))
                mkdir(joinpath("dataexchange", filename))
            end

            CSV.write(
                joinpath("dataexchange", filename, "agent_log" * ".csv"),
                data.agent_log
            )
            CSV.write(
                joinpath("dataexchange", filename, "post_log" * ".csv"),
                data.post_log
            )

            for i in 1:length(data.graph_list)
                graph_nr = lpad(
                    string(i),
                    length(string(length(graph_list))),
                    "0"
                )
                savegraph(
                    joinpath("dataexchange", filename, "graph_$graph_nr.gml"),
                    data.graph_list[i],
                    GraphIO.GML.GMLFormat()
                )
            end

        end

    end

end
