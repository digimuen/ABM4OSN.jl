import ParserCombinator

function convert_results(;specificrun::String="")

        if specificrun != ""
                raw_data = load(joinpath("results", specificrun))
                data = raw_data[first(keys(raw_data))]
                filename = specificrun[1:first(findfirst(".jld2", specificrun))-1]

                if !in(filename, readdir("dataexchange"))
                        mkdir(joinpath("dataexchange", filename))
                end

                CSV.write(joinpath("dataexchange", filename, "agent_log" * ".csv"), data.agent_log)
                CSV.write(joinpath("dataexchange", filename, "post_log" * ".csv"), data.post_log)

                for i in 1:length(data.graph_list)
                        savegraph(joinpath("dataexchange", filename, "graph_$i.gml"), data.graph_list[i], GraphIO.GML.GMLFormat())
                end
        else

                if !in("dataexchange", readdir())
                        mkdir("dataexchange")
                end

                for file in readdir("results")
                        raw_data = load(joinpath("results", file))
                        data = raw_data[first(keys(raw_data))]
                        filename = file[1:first(findfirst(".jld2", file))-1]

                        if !in(filename, readdir("dataexchange"))
                                mkdir(joinpath("dataexchange", filename))
                        end

                        CSV.write(joinpath("dataexchange", filename, "agent_log" * ".csv"), data.agent_log)
                        CSV.write(joinpath("dataexchange", filename, "post_log" * ".csv"), data.post_log)

                        for i in 1:length(data.graph_list)
                                savegraph(joinpath("dataexchange", filename, "graph_$i.gml"), data.graph_list[i], GraphIO.GML.GMLFormat())
                        end
                end
        end
end
