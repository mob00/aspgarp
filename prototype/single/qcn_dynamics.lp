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

% Fixed points keep their relative order across a step.
:- qstep(T0,T1),
   qcn_fixed_node(A), qcn_fixed_node(B),
   qcn_relation(T0,A,B,R0),
   qcn_relation(T1,A,B,R1),
   R0 != R1.

% Compare derivatives over the interval, since a point can mark a change
% in either derivative. The difference A-B has derivative A' + (-B').
step_interval(p(A),i(A,B),i(A,B)) :- qstep(p(A),i(A,B)).
step_interval(i(A,B),p(B),i(A,B)) :- qstep(i(A,B),p(B)).

interval_direction(i(From,To),qvar(V),D) :-
    time(i(From,To)),
    holds_dir(i(From,To),V,D),
    not discrete(V).

interval_direction(i(From,To),Node,std) :-
    time(i(From,To)),
    qcn_fixed_node(Node).

% QSIM handles a quantity's own magnitude boundaries, including fixed
% points that coincide with one of its landmarks.
qcn_magnitude_boundary(T,qvar(V),Node) :-
    qmag(V,land(L)),
    qcn_fixed_node(Node),
    qcn_holds_relation(T,landmark(V,L),Node,eq).

relation_change_dir(lt,eq,inc).
relation_change_dir(eq,gt,inc).
relation_change_dir(gt,eq,dec).
relation_change_dir(eq,lt,dec).

:- step_interval(T0,T1,I),
   qcn_relation(T0,A,B,R0),
   qcn_relation(T1,A,B,R1),
   relation_change_dir(R0,R1,Difference),
   interval_direction(I,A,DA),
   interval_direction(I,B,DB),
   not qcn_magnitude_boundary(I,A,B),
   not qcn_magnitude_boundary(I,B,A),
   qdirNeg(DB,NegatedDB),
   not qdirsum(DA,NegatedDB,Difference).

% Equality throughout an interval requires matching derivative signs.
:- qcn_relation(I,A,B,eq),
   interval_direction(I,A,DA),
   interval_direction(I,B,DB),
   not qcn_magnitude_boundary(I,A,B),
   not qcn_magnitude_boundary(I,B,A),
   DA != DB.

% Variables that stay at the same magnitude with a steady derivative keep
% their relative order. Discrete jumps change magnitude while keeping std.
:- qstep(T0,T1),
   qcn_edge(qvar(A),qvar(B)),
   holds(T0,A,MA,std),
   holds(T1,A,MA,std),
   holds(T0,B,MB,std),
   holds(T1,B,MB,std),
   qcn_relation(T0,qvar(A),qvar(B),R0),
   qcn_relation(T1,qvar(A),qvar(B),R1),
   R0 != R1.
