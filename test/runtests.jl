using ABM4OSN
using Test

@testset "ABM4OSN.jl" begin
    # Write your own tests here.
    @test typeof(Config()) == Config
    @test Config(network=cfg_net(agent_count=100)).network.agent_count == 100
end
