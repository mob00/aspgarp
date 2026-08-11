% Construct a QCN from typed quantities.

qcn_node(qvar(V)) :-
    qvar(V).

qcn_node(landmark(V,L)) :-
    landmark(V,L).

qcn_edge(A,B) :-
    qcn_node(A),
    qcn_node(B),
    A < B.


% Model constraints.

qcn_constraint(T,qvar(V1),qvar(V2),R) :-
    holds_constraint(T,algebraic(V1,R,V2)),
    qcn_edge(qvar(V1),qvar(V2)).

qcn_constraint(T,qvar(V2),qvar(V1),RI) :-
    holds_constraint(T,algebraic(V1,R,V2)),
    qcn_edge(qvar(V2),qvar(V1)),
    converse(point,R,RI).

qcn_constraint(T,landmark(V1,L1),landmark(V2,L2),R) :-
    holds_constraint(T,landmark_relation(V1,land(L1),V2,land(L2),R)),
    qcn_edge(landmark(V1,L1),landmark(V2,L2)).

qcn_constraint(T,landmark(V2,L2),landmark(V1,L1),RI) :-
    holds_constraint(T,landmark_relation(V1,land(L1),V2,land(L2),R)),
    qcn_edge(landmark(V2,L2),landmark(V1,L1)),
    converse(point,R,RI).


% Landmark ordering constraints.

qcn_constraint(T,landmark(V,L1),landmark(V,L2),lt) :-
    adjacent_landmark(V,L1,L2),
    qcn_edge(landmark(V,L1),landmark(V,L2)),
    time(T).

qcn_constraint(T,landmark(V,L2),landmark(V,L1),gt) :-
    adjacent_landmark(V,L1,L2),
    qcn_edge(landmark(V,L2),landmark(V,L1)),
    time(T).


% Magnitude ordering constraints.

qcn_raw_relation(T,qvar(V),landmark(V,L),eq) :-
    holds_mag(T,V,land(L)).

qcn_raw_relation(T,qvar(V),landmark(V,L1),gt) :-
    holds_mag(T,V,interval(L1,L2)).

qcn_raw_relation(T,qvar(V),landmark(V,L2),lt) :-
    holds_mag(T,V,interval(L1,L2)).


% Value-correspondent landmarks must have the same ordering as their variables.

qcn_raw_relation(T,landmark(V1,L1),landmark(V2,L2),eq) :-
    holds_constraint(T,value_correspondence(V1,land(L1),V2,land(L2))),
    time(T).


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

qcn_holds_relation(T,A,B,R) :-
    qcn_relation(T,A,B,R).

qcn_holds_relation(T,A,B,R) :-
    qcn_relation(T,B,A,RI),
    converse(point,RI,R).


% Enforce model and derived constraints.

:- qcn_constraint(T,A,B,_),
   qcn_relation(T,A,B,R),
   not qcn_constraint(T,A,B,R).


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
