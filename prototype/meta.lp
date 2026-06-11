#const r = 1. % number of rules
#const p = 1. % number of preconds

% MODEL BOUNDS:
rule_ids(rl(1..r)).
precond_ids(pc(1..p)).

:- abduced(rule(_, _, _)), r < 1.

component(proportionality(1,Q,R)) :- qvar(Q), qvar(R), Q != R.
component(proportionality(-1,Q,R)) :- qvar(Q), qvar(R), Q != R.
component(influence(1,Q,R)) :- qvar(Q), qvar(R), Q != R.
component(influence(-1,Q,R)) :- qvar(Q), qvar(R), Q != R.
component(correspondence(1,Q, R)) :- qvar(Q), qvar(R), Q != R.
component(correspondence(-1,Q, R)) :- qvar(Q), qvar(R), Q != R.
component(value_correspondence(Q, land(QLM), R, land(RLM))) :- qvar(Q), qvar(R), Q != R, landmark(Q, QLM), landmark(R, RLM).

0 {abduced(rule(RULE_ID, PC, COMPONENT)) : precond_ids(PC), component(COMPONENT) } 1 :- rule_ids(RULE_ID).
:- abduced(rule(SOME, PC, COMPONENT)), abduced(rule(OTHER, PC2, COMPONENT)), SOME != OTHER.

% ABDUCTION TO INSTANCE:
rule(RULE_ID, PC, COMPONENT) :- abduced(rule(RULE_ID, PC, COMPONENT)).

abduced(precond(PC,true)) :- precond_ids(PC).
precond(PC, true) :- abduced(precond(PC, true)).
