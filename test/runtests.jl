using ABM4OSN
using Test
using JLD
using JLD2

save("sim500.jld2", "sim500", sim)

@time sim = simulate(Config(simulation=cfg_sim(n_iter=50)));

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
