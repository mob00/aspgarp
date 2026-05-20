
timepoint(0).
% timepoint(1).

entity(blood).
entity(hypothalamus).
entity(skin).
entity(blood_vessels, skin).
entity(skeletal_muscle).

quantity(blood, temperature).
quantityspace(temperature, -2, hypothermia).
quantityspace(temperature, -1, freezing).
quantityspace(temperature, 0, neutral).
quantityspace(temperature, 1, overheating).
quantityspace(temperature, 2, hyperthermia).

quantity(hypothalamus, difference).
quantityspace(difference, -1, negative).
quantityspace(difference, 0, neutral).
quantityspace(difference, 1, positive).

quantity(hypothalamus, norm).
quantityspace(norm, 0, set_point).

quantity(skin, sweating).
quantityspace(sweating, 0, none).
quantityspace(sweating, 1, positive).

quantity(blood_vessels, blood_flow).
quantityspace(blood_flow, 0, none).
quantityspace(blood_flow, 1, positive).

quantity(skeletal_muscle, shivering).
quantityspace(shivering, 0, none).
quantityspace(shivering, 1, positive).


relation(temperature, norm).

rule(calculus(temperature, minus, norm, "=", difference)).
calculus(temperature, minus, norm, "=", difference) :-not ignore(calculus(temperature, minus, norm, "=", difference)).

rule(proportionality(1, temperature, difference)).
proportionality(1, temperature, difference) :- not ignore(proportionality(1, temperature, difference)).

% rule(proportionality(-1, norm, difference)).
% proportionality(-1, norm, difference) :- not ignore(proportionality(-1, norm, difference)).

rule(proportionality(-1, blood_flow, temperature)).
proportionality(-1, blood_flow, temperature) :- not ignore(proportionality(-1, blood_flow, temperature)).

rule(influence(1, difference,blood_flow)) :- not ignore(influence(1, difference,blood_flow)).
influence(1, difference,blood_flow).

% conditionals

rule(influence(-1, difference, shivering)).
influence(-1, difference, shivering,T) :- relation(temperature, norm, T, -1), not ignore(influence(-1, difference, shivering)).

rule(proportionality(1, shivering, temperature)).
proportionality(1, shivering, temperature,T) :- relation(temperature, norm, T, -1), not ignore(proportionality(1, shivering, temperature)).

rule(influence(1, difference, sweating)).
influence(1, difference, sweating,T) :-relation(temperature, norm, T, 1), not ignore(influence(1, difference, sweating)).

rule(proportionality(-1, sweating, temperature)).
proportionality(-1, sweating, temperature,T) :-relation(temperature, norm, T, 1), not ignore(proportionality(-1, sweating, temperature)).



%% Visuals
% Cases must have a abstract instanciation fot tor the visuals to ground to...

value(difference, caseA, -1).
value(difference, caseB, 1).

position(blood,25,80).
position(hypothalamus,60,90).
position(skin,70,80).
position(blood_vessels,100,70).
position(skeletal_muscle,70,25).

position(difference,50,40).
position(temperature,25,50).
position(blood_flow,100,50).
position(sweating,70,70).
position(norm, 25,25).
position(shivering, 70,10).

