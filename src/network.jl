"""
    create_network(n, m0)

Create a network with the Barabási-Albert model.

# Arguments
- `n`: number of nodes
- `m0`: m0 parameter for Barabási-Albert model

# Example
```julia-repl
julia> using Random

julia> Random.seed!(0);

julia> create_network(100, 3)
{100, 206} directed simple Int64 graph

```

See also: [`update_network!`](@ref)
"""
function create_network(
    n::Int64, m0::Int64
)
    # this algorithm is modelled after the python networkx implementation:
    # https://github.com/networkx/networkx/blob/master/networkx/generators/random_graphs.py#L655
    if n >= m0  # check if n is smaller than m0
        g = SimpleDiGraph(n)
        targets = collect(1:m0)  # set of nodes to connect to
        repeated_nodes = Array{Int64}(undef, 0)  # growing set of nodes for preferential attachment
        source = m0 + 1  # initial source node
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

"""
    update_network!(state, config)

Update a network in a simulation.

# Arguments
- `state`: a tuple of the current graph and agent_list
- `config`: Config object as provided by Config

See also: [`create_network`](@ref), [`Agent`](@ref), [`generate_opinion`](@ref), [`generate_inclin_interact`](@ref), , [`generate_check_regularity`](@ref)
"""
function update_network!(
    state::Tuple{AbstractGraph, AbstractArray},
    config::Config
)
    graph, agent_list = state
    pref_attach_list = [src(e) for e in edges(graph) if agent_list[src(e)].active]
    for _ in 1:config.network.growth_rate
        push!(
            agent_list, 
            Agent(
                generate_opinion(), 
                generate_inclin_interact(), 
                generate_check_regularity()
            )
        )
        add_vertex!(graph)
        shuffle!(pref_attach_list)
        for i in 1:config.network.m0
            add_edge!(graph, nv(graph), pref_attach_list[i])
        end
    end
end

# suppress output of include()
;
