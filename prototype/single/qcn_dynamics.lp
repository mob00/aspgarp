%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% QCN conceptual neighbourhood over transitions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Same relation may persist.
qcn_cnh_allowed(R,R) :-
    baserelation(point,R).

% Or it may move to a conceptual neighbour.
qcn_cnh_allowed(R1,R2) :-
    cnhs(point,R1,R2).


% A QCN relation may only change via the conceptual neighbourhood.
:- qstep(T0,T1),
   qcn_edge(A,B),
   qcn_relation(T0,A,B,R0),
   qcn_relation(T1,A,B,R1),
   not qcn_cnh_allowed(R0,R1).

% Fixed landmarks keep their relative order across a step.
:- qstep(T0,T1),
   qcn_relation(T0,landmark(A,LA),landmark(B,LB),R0),
   qcn_relation(T1,landmark(A,LA),landmark(B,LB),R1),
   R0 != R1.

% Compare derivatives over the interval, since a point can mark a change
% in either derivative. The difference A-B has derivative A' + (-B').
step_interval(p(A),i(A,B),i(A,B)) :- qstep(p(A),i(A,B)).
step_interval(i(A,B),p(B),i(A,B)) :- qstep(i(A,B),p(B)).

relation_change_dir(lt,eq,inc).
relation_change_dir(eq,gt,inc).
relation_change_dir(gt,eq,dec).
relation_change_dir(eq,lt,dec).

:- step_interval(T0,T1,I),
   qcn_relation(T0,qvar(A),qvar(B),R0),
   qcn_relation(T1,qvar(A),qvar(B),R1),
   relation_change_dir(R0,R1,Difference),
   not discrete(A), not discrete(B),
   holds_dir(I,A,DA),
   holds_dir(I,B,DB),
   qdirNeg(DB,NegatedDB),
   not qdirsum(DA,NegatedDB,Difference).

% Continuous quantities that are equal throughout an interval have the same
% derivative sign. At a point, they can meet or separate with different signs.
:- time(i(From,To)),
   qcn_relation(i(From,To),qvar(A),qvar(B),eq),
   not discrete(A), not discrete(B),
   holds_dir(i(From,To),A,DA),
   holds_dir(i(From,To),B,DB),
   DA != DB.

% Two stationary variables may not change their relation in the same step.
:- qstep(T0,T1),
   qcn_edge(qvar(A),qvar(B)),
   holds_dir(T0,A,std),
   holds_dir(T0,B,std),
   holds_dir(T1,A,std),
   holds_dir(T1,B,std),
   qcn_relation(T0,qvar(A),qvar(B),R0),
   qcn_relation(T1,qvar(A),qvar(B),R1),
   R0 != R1.
