timepoint(0).
%timepoint(1..20).

entity(leftContainer).
quantity(leftContainer, leftMass).
 quantityspace(leftMass, 0, none).
 quantityspace(leftMass, 1, low).
 quantityspace(leftMass, 2, medium).
 quantityspace(leftMass, 3, high).
quantity(leftContainer, leftWidth).
 quantityspace(leftWidth, 1, some).
quantity(leftContainer, leftFlowOut).
 quantityspace(leftFlowOut, 0, none).
 quantityspace(leftFlowOut, 1, low).
 quantityspace(leftFlowOut, 2, medium).
 quantityspace(leftFlowOut, 3, high).
quantity(leftContainer, leftWaterlevel).
 quantityspace(leftWaterlevel, 0, none).
 quantityspace(leftWaterlevel, 1, low).
 quantityspace(leftWaterlevel, 2, medium).
 quantityspace(leftWaterlevel, 3, high).
quantity(leftContainer, leftPressure).
 quantityspace(leftPressure, 0, none).
 quantityspace(leftPressure, 1, low).
 quantityspace(leftPressure, 2, medium).
 quantityspace(leftPressure, 3, high).
quantity(leftContainer, leftVolume).
 quantityspace(leftVolume, 0, empty).
 quantityspace(leftVolume, 1, low).
 quantityspace(leftVolume, 2, medium).
 quantityspace(leftVolume, 3, high).


entity(rightContainer).
quantity(rightContainer, rightMass).
 quantityspace(rightMass, 0, none).
 quantityspace(rightMass, 1, low).
 quantityspace(rightMass, 2, medium).
 quantityspace(rightMass, 3, high).
quantity(rightContainer, rightWidth).
 quantityspace(rightWidth, 1, some).
quantity(rightContainer, rightFlowOut).
 quantityspace(rightFlowOut, 0, none).
 quantityspace(rightFlowOut, 1, low).
 quantityspace(rightFlowOut, 2, medium).
 quantityspace(rightFlowOut, 3, high).
quantity(rightContainer, rightPressure).
 quantityspace(rightPressure, 0, none).
 quantityspace(rightPressure, 1, low).
 quantityspace(rightPressure, 2, medium).
 quantityspace(rightPressure, 3, high).
quantity(rightContainer, rightWaterlevel).
 quantityspace(rightWaterlevel, 0, none).
 quantityspace(rightWaterlevel, 1, low).
 quantityspace(rightWaterlevel, 2, medium).
 quantityspace(rightWaterlevel, 3, high).
quantity(rightContainer, rightVolume).
 quantityspace(rightVolume, 0, empty).
 quantityspace(rightVolume, 1, low).
 quantityspace(rightVolume, 2, medium).
 quantityspace(rightVolume, 3, high).

entity(balance).
quantity(balance,angle).
 quantityspace(angle,-1, left).
 quantityspace(angle, 0, balanced).
 quantityspace(angle, 1, right).

% Relational
relation(leftMass, rightMass).
relation(leftWidth, rightWidth).
relation(leftFlowOut, rightFlowOut).
relation(leftWaterlevel, rightWaterlevel).
relation(leftPressure, rightPressure).
relation(leftVolume, rightVolume).

% % Improvised Balancing feedback loop...

quantity(balance,gravity).
quantityspace(gravity, 1, some).

rule(influence(mass, angle)).
influence(-1, leftMass, angle) :- not ignore(influence(mass, angle)).
influence(1, rightMass, angle) :- not ignore(influence(mass, angle)).

rule(influence(gravity, angle)).
influence(-1, gravity, angle,T) :- value(angle, T, 1), not ignore(influence(gravity, angle)).
influence(1, gravity, angle,T) :- value(angle, T, -1), not ignore(influence(gravity, angle)).

rule(influence(-1, flowOut, volume)).
influence(-1, leftFlowOut, leftVolume) :- not ignore(influence(-1, flowOut, volume)).
influence(-1, rightFlowOut, rightVolume) :- not ignore(influence(-1, flowOut, volume)).

rule(proportionality(1, volume, waterlevel)).
proportionality(1, leftVolume, leftWaterlevel) :- not ignore(proportionality(1, volume, waterlevel)).
proportionality(1, rightVolume, rightWaterlevel) :- not ignore(proportionality(1, volume, waterlevel)).

rule(correspondence(waterlevel,pressure)).
correspondence(leftWaterlevel,leftPressure) :- not ignore(correspondence(waterlevel,pressure)).
correspondence(rightWaterlevel,rightPressure) :- not ignore(correspondence(waterlevel,pressure)).

rule(correspondence(pressure,flowOut)).
correspondence(leftPressure,leftFlowOut) :- not ignore(correspondence(pressure,flowOut)).
correspondence(rightPressure,rightFlowOut) :- not ignore(correspondence(pressure,flowOut)).

rule(correspondence(volume, mass)).
correspondence(leftVolume, leftMass) :- not ignore(correspondence(volume, mass)).
correspondence(rightVolume, rightMass) :- not ignore(correspondence(volume, mass)).

rule(calculus(waterlevel, mult, width, "=", volume)).
calculus(leftWaterlevel, mult, leftWidth, "=", leftVolume) :- not ignore(calculus(waterlevel, mult, width, "=", volume)).
calculus(rightWaterlevel, mult, rightWidth, "=", rightVolume) :- not ignore(calculus(waterlevel, mult, width, "=", volume)).

rule(correspondence(waterlevel, volume)).
correspondence(leftWaterlevel, leftVolume, T) :- value(leftVolume, T, 0), not ignore(correspondence(waterlevel, volume)).
correspondence(rightWaterlevel, rightVolume, T) :- value(rightVolume, T, 0), not ignore(correspondence(waterlevel, volume)).


% Special Rule to make model more expressive:
% Default Transition
value(angle, NEXT, NEW) :- timestep(T,NEXT),
    delta(angle, T, 1),
    value(angle, T, OLD),
    inc(angle, OLD, NEW),
    OLD = 0.

value(angle, NEXT, NEW) :- timestep(T,NEXT),
    delta(angle, T, -1),
    value(angle, T, OLD),
    dec(angle, OLD, NEW),
    OLD = 0.



position(balance, 30, 80).
position(leftContainer,-10,30).

position(leftMass, 10, 50).
position(leftVolume, 10, 40).
position(leftPressure, 10, 30).
position(leftFlowOut, 10, 20).
position(leftWaterlevel, 10, 10).
position(leftWidth, 10, 0).

position(rightMass, 40, 50).
position(rightVolume, 40, 40).
position(rightPressure, 40, 30).
position(rightFlowOut, 40, 20).
position(rightWaterlevel, 40, 10).
position(rightWidth, 40, 0).

position(rightContainer, 60, 30).


%showirelation.


% write differecne condition wiht denys.

% Special case
