timepoint(0).
timepoint(1).

entity(human_actions).
entity(atmosphere).
entity(biosphere).

quantity(human_actions, emissions).
quantityspace(emissions, 0, none).
quantityspace(emissions, 1, positive).

quantity(human_actions, economic_production).

quantity(atmosphere, co2).

quantity(atmosphere, temperature).
quantityspace(temperature, 1, high).
quantityspace(temperature, 0, optimum).
quantityspace(temperature,-1 ,low).


quantity(biosphere, uptake).
quantityspace(uptake, 0, none).
quantityspace(uptake, 1, positive).

relation(emissions, uptake).
relation(emissions,uptake, 0, ">").

influence(1,emissions,co2).
influence(-1,uptake,co2).

proportionality(1,co2,temperature).


proportionality(-1, temperature, economic_production, T) :- value(temperature, T, 1).
proportionality(1, temperature, economic_production, T) :- value(temperature, T, -1).

% Visuals
% -------s
value(temperature, caseA, 1).
value(temperature, caseB, -1).

position(human_actions, 25, 75).
position(emissions, 25, 50).
position(atmosphere, 50, 75).
position(co2, 50, 50).
position(biosphere, 75, 75).
position(uptake, 75, 50).
position(temperature, 40, 25).
position(economic_production, 60, 25).
