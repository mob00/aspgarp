timepoint(0).
%timepoint(1..4).

entity(light).
entity(material).
entity(electrons).

quantity(light, frequency).
quantityspace(frequency, 1, "?").
quantity(light,amplitude).
quantityspace(amplitude, 1, "?").


quantity(material, threshold_frequency).
quantityspace(threshold_frequency, 1, "?").

quantity(electrons, kinetic_energy).
quantityspace(kinetic_energy, 0, none).
quantityspace(kinetic_energy, 1, positive).
quantity(electrons, current).
quantityspace(current, 0, none).
quantityspace(current, 1, positive).

relation(frequency, threshold_frequency).
%% DIAGNOSABLE RULES 

rule(proportionality( 1, frequency, kinetic_energy)).
proportionality( 1, frequency, kinetic_energy) :- not ignore(proportionality(1, frequency, kinetic_energy)).

rule(calculus(frequency,minus,threshold_frequency,"=",kinetic_energy)).
calculus(frequency,minus,threshold_frequency,"=",kinetic_energy) :- not ignore(calculus(frequency,minus,threshold_frequency,"=",kinetic_energy)).

rule(calculus(frequency,minus,threshold_frequency,"=",current)).
calculus(frequency,minus,threshold_frequency,"=",current) :- not ignore(calculus(frequency,minus,threshold_frequency,"=",current)).

rule(proportionality(1, amplitude, current)).
proportionality(1, amplitude, current,T) :- relation(frequency, threshold_frequency, T, 1), not ignore(proportionality(1, amplitude, current)).

{assume(proportionality(1, amplitude, current))} :- counterfactual.
proportionality(1, amplitude, current) :- assume(proportionality(1, amplitude, current)).

% any quantitiies value can be guessed
assume(value(Q, 1, V)) :- quantity(Q, _), quantityspace(Q, _, V), counterfactual.
value(Q, 1, V) :- assume(value(Q, 1, V)).
% 
% VISUALS
relation(frequency, threshold_frequency, caseA, 1).

position(light, 30,70).
position(material, 15,45).
position(electrons, 40,70).

position(frequency, 20,60).
position(kinetic_energy, 50,60).
position(threshold_frequency, 25, 40).
position(current, 35, 45).
position(amplitude, 50, 50). 

