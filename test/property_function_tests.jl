using Test
using ABM4OSN
using Statistics

@test !(true in [((x > 1.0) | (x < -1.0)) for x in [ABM4OSN.generate_opinion() for i in 1:100]])
@test !(true in [(x < 0) for x in [ABM4OSN.generate_inclin_interact() for i in 1:100]])
@test !(true in [((x <= 0.9375) | (x > 1.0)) for x in [ABM4OSN.generate_check_regularity() for i in 1:100]])
@test mean([ABM4OSN.generate_desired_input_count(1) for i in 1:1000]) > 0