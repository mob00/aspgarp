%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reference Model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

precond(all, true).

rule(r1,all,influence(-1, flow, lamount)).

rule(r2,all,influence(1, flow, ramount)).

rule(r3,all,proportionality(1, lamount, llevel)).

rule(r4,all,proportionality(1, ramount, rlevel)).

rule(r5,all,correspondence(lamount, llevel)).
rule(r6,all,correspondence(ramount, rlevel)).

rule(r7,all,proportionality(1, llevel, lpressure)).
rule(r8,all,proportionality(1, rlevel, rpressure)).

rule(r9,all,correspondence(lamount, lpressure)).
rule(r10,all,correspondence(ramount, rpressure)).

rule(r11,all,proportionality(1, lpressure, flow)).
rule(r12,all,proportionality(-1, rpressure, flow)).