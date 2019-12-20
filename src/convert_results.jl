import ParserCombinator

function convert_results(;specificrun::String="")

        if specificrun != ""
                raw_data = load(joinpath("results", specificrun))
                data = raw_data[first(keys(raw_data))]
                filename = specificrun[1:first(findfirst(".jld2", specificrun))-1]

                if !in(filename, readdir("dataexchange"))
                        mkdir(joinpath("dataexchange", filename))
                end

                CSV.write(joinpath("dataexchange", filename, "sim_df" * ".csv"), data[2][1])
                CSV.write(joinpath("dataexchange", filename, "post_df" * ".csv"), data[2][2])

                for i in 1:length(data[2][3])
                        savegraph(joinpath("dataexchange", filename, "graph_$i.gml"), data[2][3][i], GraphIO.GML.GMLFormat())
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

                        CSV.write(joinpath("dataexchange", filename, "sim_df" * ".csv"), data[2][1])
                        CSV.write(joinpath("dataexchange", filename, "post_df" * ".csv"), data[2][2])

                        for i in 1:length(data[2][3])
                                savegraph(joinpath("dataexchange", filename, "graph_$i.gml"), data[2][3][i], GraphIO.GML.GMLFormat())
                        end
                end
        end
end
