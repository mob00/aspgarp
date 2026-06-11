% rule(r1,true,proportionality(1, population, biomass)).
% rule(r2,true,correspondence(1, population, biomass)).


rule(r3,true,influence(1, birth, population)).
rule(r4,true,influence(-1, death, population)).

rule(r5,true,proportionality(1, population, birth)).
rule(r6,true,proportionality(1, population, death)).

% rule(r7,true,algebraic(birth, lt, death)).
observable(relation(birth, death)).
observable(relation(death, birth)).

rule(r8,true,value_correspondence(population, land(zero), birth, land(zero))).
rule(r9,true,value_correspondence(population, land(zero), death, land(zero))).

% Domain assumption for the population example:
% If population is non-zero, then birth and death are positive.

violation :-
    time(T),
    holds_mag(T,population,MP),
    relative_qmag(population,MP,land(zero),pos),
    holds_mag(T,birth,land(zero)).

violation :-
    time(T),
    holds_mag(T,population,MP),
    relative_qmag(population,MP,land(zero),pos),
    holds_mag(T,death,land(zero)).