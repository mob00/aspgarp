rule(r1, all, correspondence(size,shade)).
rule(r2, all, proportionality(1, size, shade)).
rule(r3, all, sum(h2,deltah,h1)).
rule(r4, all, mplus(deltah,qx)).
rule(r5, all, minus(qx,mqx)).

precond(all, true).