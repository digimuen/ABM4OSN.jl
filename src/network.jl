# this algorithm is modelled after the python networkx implementation:
# https://github.com/networkx/networkx/blob/master/networkx/generators/random_graphs.py#L655
function create_network(
    n::Int64, m0::Int64
)
    # check if n is smaller than m0
    if n >= m0
        # setup
        g = SimpleDiGraph(n)
        # set of nodes to connect to
        targets = collect(1:m0)
        # growing set of nodes for preferential attachment
        repeated_nodes = Array{Int64}(undef, 0)
        # initial source node
        source = m0 + 1
        # preferential attachment algorithm
        while source <= n
            for e in zip(targets, fill(source, m0))
                add_edge!(g, e[1], e[2])
            end
            append!(repeated_nodes, targets)
            targets = shuffle(repeated_nodes)[1:m0]
            source += 1
        end
        return g
    else
        error("n cannot be smaller than m0")
    end
end


function update_network!(
    state::Tuple{AbstractGraph, AbstractArray},
    config::Config
)
    graph, agent_list = state
    pref_attach_list = [src(e) for e in edges(graph) if agent_list[src(e)].active]
    for _ in 1:config.network.growth_rate
        push!(agent_list, Agent(generate_opinion(), generate_inclin_interact(), generate_check_regularity()))
        add_vertex!(graph)
        shuffle!(pref_attach_list)
        for i in 1:config.network.initial_follows
            add_edge!(graph, nv(graph), pref_attach_list[i])
        end
    end
end

# suppress output of include()
;
