%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reference Model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

precond(all, true).

rule(r1,all,influence(-1, flow, lamount)).

rule(r2,all,influence(1, flow, ramount)).

rule(r3,all,proportionality(1, lamount, llevel)).

rule(r4,all,proportionality(1, ramount, rlevel)).

rule(r5,all,correspondence(1,lamount, llevel)).
rule(r6,all,correspondence(1,ramount, rlevel)).

rule(r7,all,proportionality(1, llevel, lpressure)).
rule(r8,all,proportionality(1, rlevel, rpressure)).

rule(r9,all,correspondence(1,lamount, lpressure)).
rule(r10,all,correspondence(1,ramount, rpressure)).

rule(r11,all,proportionality(1, lpressure, flow)).
rule(r12,all,proportionality(-1, rpressure, flow)).

rule(r13,all,landmark_relation(lheight, land(point), llevel, land(max), eq)).
rule(r14,all,landmark_relation(rheight, land(point), rlevel, land(max), eq)).

rule(r15,all,landmark_relation(rheight, land(point), lheight, land(point), eq)).

rule(r16,all,minus(lpressure, rpressure, flow)).

rule(r17,all,algebraic(llevel, eq, lpressure)).
rule(r18,all,algebraic(rlevel, eq, rpressure)).



