using ABM4OSN
using Test

sim = simulate()

length(sim[3][2])

@testset "ABM4OSN.jl" begin
    # Write your own tests here.
    @test typeof(Config()) == Config
    @test Config(network=cfg_net(agent_count=100)).network.agent_count == 100
    @test length(simulate()[3][2]) == 102
end
