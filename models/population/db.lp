
qvar(birth).
qvar(death).
qvar(population).

landmark(birth, zero).
landmark(birth, inf).
adjacent_landmark(birth, zero, inf).

landmark(death, zero).
landmark(death, inf).
adjacent_landmark(death, zero, inf).

landmark(population, zero).
landmark(population, medium).
landmark(population, inf).
adjacent_landmark(population, zero, medium).
adjacent_landmark(population, medium, inf).
