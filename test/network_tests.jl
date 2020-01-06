using Test
using ABM4OSN
using LightGraphs

n = ABM4OSN.create_network(100, 5)

@test nv(n) == 100
@test is_directed(n)
@test eltype(n) == Int64