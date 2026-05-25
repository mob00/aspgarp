qvar(birth,1).
qvar(death,2).
qvar(population,3).
% qvar(biomass,4).

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

% landmark(biomass, zero).
% landmark(biomass, medium).
% landmark(biomass, inf).
% adjacent_landmark(biomass, zero, medium).
% adjacent_landmark(biomass, medium, inf).
