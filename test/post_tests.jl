using ABM4OSN

p_1 = ABM4OSN.Post(0.5, 0.2, 1, 1)
p_2 = ABM4OSN.Post(0.5, 0.1, 1, 1)

@test p_1 > p_2