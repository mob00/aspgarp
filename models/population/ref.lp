rule(r1,true,proportionality(1, population, biomass)).
rule(r2,true,correspondence(1, population, biomass)).

rule(r3,true,influence(1, birth, population)).
rule(r4,true,influence(-1, death, population)).

rule(r5,true,proportionality(1, population, birth)).
rule(r6,true,proportionality(1, population, death)).

rule(r7,true,algebraic(birth, lt, death)).
