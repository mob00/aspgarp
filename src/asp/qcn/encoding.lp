% Construct a QCN from typed quantities.

qcn_node(qvar(V)) :-
    qvar(V).

qcn_node(A) :-
    qcn_fixed_node(A).

qcn_fixed_node(landmark(V,L)) :-
    landmark(V,L).

qcn_edge(A,B) :-
    qcn_node(A),
    qcn_node(B),
    A < B.


% Model constraints.

qcn_constraint(T,qvar(V1),qvar(V2),R) :-
    holds_constraint(T,algebraic(V1,R,V2)).

qcn_constraint(T,landmark(V1,L1),landmark(V2,L2),R) :-
    holds_constraint(T,landmark_relation(V1,land(L1),V2,land(L2),R)).


% Landmark ordering constraints.

qcn_constraint(T,landmark(V,L1),landmark(V,L2),lt) :-
    adjacent_landmark(V,L1,L2),
    time(T).

% Numeric zero is shared across quantity spaces.
qcn_constraint(T,landmark(A,ZA),landmark(B,ZB),eq) :-
    zero_landmark(A,ZA),
    zero_landmark(B,ZB),
    qcn_edge(landmark(A,ZA),landmark(B,ZB)),
    time(T).


% Magnitude ordering constraints.

qcn_raw_relation(T,qvar(V),landmark(V,L),eq) :-
    holds_mag(T,V,land(L)).

qcn_raw_relation(T,qvar(V),landmark(V,L1),gt) :-
    holds_mag(T,V,interval(L1,L2)).

qcn_raw_relation(T,qvar(V),landmark(V,L2),lt) :-
    holds_mag(T,V,interval(L1,L2)).


% Canonicalize raw relations.

qcn_relation(T,A,B,R) :-
    qcn_raw_relation(T,A,B,R),
    qcn_edge(A,B).

qcn_relation(T,B,A,RI) :-
    qcn_raw_relation(T,A,B,R),
    qcn_edge(B,A),
    converse(point,R,RI).


% Assign one base relation to every QCN edge.

1 {
    qcn_relation(T,A,B,R) : baserelation(point,R)
} 1 :-
    qcn_edge(A,B),
    time(T).


% Access relations independent of their canonical storage direction.

qcn_holds_relation(T,A,A,eq) :-
    time(T),
    qcn_node(A).

qcn_holds_relation(T,A,B,R) :-
    qcn_relation(T,A,B,R).

qcn_holds_relation(T,A,B,R) :-
    qcn_relation(T,B,A,RI),
    converse(point,RI,R).


% Enforce model and derived constraints.

:- qcn_constraint(T,A,B,R),
   not qcn_holds_relation(T,A,B,R).

% Infer forced orderings when requested. Complete assignments may contain
% additional relations chosen to witness consistency.
qcn_known_relation(T,A,A,eq) :-
    qcn_closure_needed(T),
    qcn_node(A).

qcn_known_relation(T,A,B,R) :-
    qcn_closure_needed(T),
    qcn_constraint(T,A,B,R).

qcn_known_relation(T,A,B,R) :-
    qcn_closure_needed(T),
    qcn_raw_relation(T,A,B,R).

qcn_known_relation(T,B,A,RI) :-
    qcn_known_relation(T,A,B,R),
    converse(point,R,RI),
    A != B.

forced_composition(R1,R2,R) :-
    composition(point,R1,R2,R),
    1 = #count { R3 : composition(point,R1,R2,R3) }.

qcn_known_relation(T,A,C,R3) :-
    qcn_known_relation(T,A,B,R1),
    qcn_known_relation(T,B,C,R2),
    A != B, B != C, A != C,
    forced_composition(R1,R2,R3).


% Enforce algebraic closure for every ordered triple of distinct QCN nodes.

:- time(T),
   qcn_node(A),
   qcn_node(B),
   qcn_node(C),
   A != B,
   B != C,
   A != C,
   qcn_holds_relation(T,A,B,R1),
   qcn_holds_relation(T,B,C,R2),
   qcn_holds_relation(T,A,C,R3),
   not composition(point,R1,R2,R3).
