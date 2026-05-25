% CONSTRUCT QCN FROM TYPED QUANTITIES

qcn_node(qvar(V)) :- qvar(V).
qcn_node(landmark(V,L)) :- landmark(V,L).
qcn_edge(FROM,TO) :- qcn_node(FROM), qcn_node(TO), FROM < TO.

% CONSTRAINS ON QCN RELATIONS
% Model Constraints
qcn_constraint(T, qvar(Var1), qvar(Var2), Rel) :- holds_constraint(T, algebraic(Var1, Rel, Var2)), qvar(Var1) < qvar(Var2).
qcn_constraint(T, qvar(Var2), qvar(Var1), RelInv) :- holds_constraint(T, algebraic(Var1, Rel, Var2)),qvar(Var1) > qvar(Var2), converse(point, Rel, RelInv).

% Landmakr ordering constraints
qcn_constraint(T, landmark(V,L1), landmark(V,L2), lt) :- adjacent_landmark(V,L1,L2), time(T).
qcn_constraint(T, landmark(V,L2), landmark(V,L1), gt) :- adjacent_landmark(V,L1,L2), time(T).

% magnitude ordering constraints, on rel_mag, lower or higher gets resolved to a relation.
qcn_raw_relation(T, qvar(V), landmark(V,L), eq) :- holds_mag(T,V,land(L)).
qcn_raw_relation(T, qvar(V), landmark(V,L1), gt) :- holds_mag(T,V,interval(L1,L2)).
qcn_raw_relation(T, qvar(V), landmark(V,L2), lt) :-holds_mag(T,V,interval(L1,L2)).

%value correspondences, if two variables are value-correspondent at certain landmarks, then those landmarks must be ordered the same way as the variables.
qcn_raw_relation(T, landmark(V1,L1), landmark(V2,L2), eq) :- holds_constraint(T, value_correspondence(V1, land(L1), V2, land(L2))), time(T).

% Canonicalize raw constraints
qcn_relation(T,A,B,R) :- qcn_raw_relation(T,A,B,R), qcn_edge(A,B).
qcn_relation(T,B,A,RI) :- qcn_raw_relation(T,A,B,R), qcn_edge(B,A), converse(point,R,RI).

% LABEL BASE RELATIONS
1 {qcn_relation(T,FROM,TO,RELATION): baserelation(point,RELATION)} 1:- qcn_edge(FROM,TO), time(T).

% ALGEBRAIC CLOSURE
:- qcn_relation(T,FROM,OVER,R1), qcn_relation(T,OVER,TO,R2), qcn_relation(T,FROM,TO,R3), not composition(point,R1,R2,R3), time(T), qcn_edge(FROM,TO).

% STATIC CONSTRAINTS
:- qcn_relation(T,FROM,TO,REL), not qcn_constraint(T,FROM,TO,REL), qcn_constraint(T,FROM,TO,OTHER).