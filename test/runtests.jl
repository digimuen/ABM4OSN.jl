using ABM4OSN
using Test
using JLD
using JLD2
using CSV
using LightGraphs

batch = Config[]
for ac in 50:50:200
    push!(batch,Config(network=cfg_net(agent_count=ac)))
end

batch

simulate_batch(batch, batch_desc="Agentcount")

convert_results()
result[1]

result = load("results/_tmpstate.jld2")[""]

using Statistics
using LightGraphs
mean(agent.desired_input_count for agent in result[3][2])

std(indegree(result[3][1]))

ABM4OSN.generate_desired_input_count(100,25)

for i in 1:1000
    push!(randenn, randn)
end

using Plots
plot(randenn)
histogram(randenn)

sim2 = load("sim500.jld2")
net_evolution = deepcopy(sim2["sim500"][1][3])

CSV.write("dataframe.csv", sim2["sim500"][1][1])

bla = "bla"

using Plots
plot(outdegrees, alpha=0.2)
outdegrees
arrtest = []
last(arrtest)

network = ABM4OSN.create_network(100,10)
agents = ABM4OSN.create_agents(network)
ABM4OSN.update_network!((network,agents),Config())
agents
agents[12].active = false
agents
active_agents = [agent.id for agent in agents if !agent.active]
find(agents, active_agents)
testset = indexin([agent for agent in agents if !agent.active],agents)

testset = [indexin([1.2, 1.3], [1,1.1,1.2,1.3])][1]
testset2 = Int64[]
for elem in testset[1]
    push!(testset2, elem)
end



testset2

for elem in testset[1]
indexin(1.2, [1,1.1,1.2,1.3])
indexin

using LightGraphs
rem_vertices!(network, testset2)


@time sim2 = simulate(Config(network = cfg_net(agent_count = 100), simulation=cfg_sim(n_iter=200)));

sim[2]


mean([weight for weight in sim[1][2].Weight if weight>=0])
sim[1][1][:, [1,2,5,6,7]]

sim
save("sim500.jld2", "sim500", sim)

testing = load("sim500.jld2")
testing["sim500"]

length(sim[3][2])

@testset "ABM4OSN.jl" begin
    # Write your own tests here.
    @test typeof(Config()) == Config
    @test Config(network=cfg_net(agent_count=100)).network.agent_count == 100
    @test length(simulate()[3][2]) == 100
end

maximum([1,2,3])
