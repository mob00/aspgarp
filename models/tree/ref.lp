%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reference Model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

precond(all, true).

rule(r1,all,influence(1, growth, size)).
rule(r2,all,proportionality(1, size, shade)).
rule(r3,all,correspondence(size, shade)).
rule(r4,all,proportionality(-1, size, growth)).
rule(r5,all,value_correspondence(growth, land(zero), size, land(large))).
rule(r6,all,value_correspondence(size, land(large), growth, land(zero))).
