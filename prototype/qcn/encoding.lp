% CONSTRUCT QCN FROM TYPED QUANTITIES

qcn_node(qvar(V)) :- qvar(V).
qcn_node(landmark(V,L)) :- landmark(V,L).
qcn_edge(FROM,TO) :- qcn_node(FROM), qcn_node(TO), FROM < TO.

% CONSTRAINS ON QCN RELATIONS
% Model Constraints
qcn_constraint(
    T,
    landmark(V1,L1),
    landmark(V2,L2),
    R
) :-
    holds_constraint(
        T,
        landmark_relation(
            V1,land(L1),
            V2,land(L2),
            R
        )
    ),
    qcn_edge(
        landmark(V1,L1),
        landmark(V2,L2)
    ).

qcn_constraint(
    T,
    landmark(V2,L2),
    landmark(V1,L1),
    RI
) :-
    holds_constraint(
        T,
        landmark_relation(
            V1,land(L1),
            V2,land(L2),
            R
        )
    ),
    qcn_edge(
        landmark(V2,L2),
        landmark(V1,L1)
    ),
    converse(point,R,RI).
%Model constraints: landmarks
qcn_raw_relation(
    T,
    landmark(V1,L1),
    landmark(V2,L2),
    R
) :-
    holds_constraint(
        T,
        landmark_relation(
            V1, land(L1),
            V2, land(L2),
            R
        )
    ),
    time(T).


% Landmakr ordering constraints
qcn_holds_relation(T,A,B,R) :-
    qcn_relation(T,A,B,R).

qcn_holds_relation(T,A,B,R) :-
    qcn_relation(T,B,A,RI),
    converse(point,RI,R).

:- holds_constraint(
       T,
       landmark_relation(
           V1, land(L1),
           V2, land(L2),
           R
       )
   ),
   not qcn_holds_relation(
       T,
       landmark(V1,L1),
       landmark(V2,L2),
       R
   ).

% magnitude ordering constraints, on rel_mag, lower or higher gets resolved to a relation.
qcn_raw_relation(T, qvar(V), landmark(V,L), eq) :- holds_mag(T,V,land(L)).
qcn_raw_relation(T, qvar(V), landmark(V,L1), gt) :- holds_mag(T,V,interval(L1,L2)).
qcn_raw_relation(T, qvar(V), landmark(V,L2), lt) :-holds_mag(T,V,interval(L1,L2)).

%value correspondences, if two variables are value-correspondent at certain landmarks, then those landmarks must be ordered the same way as the variables.
qcn_raw_relation(T, landmark(V1,L1), landmark(V2,L2), eq) :- holds_constraint(T, value_correspondence(V1, land(L1), V2, land(L2))), time(T).

% Canonicalize raw constraints
qcn_relation(T,A,B,R) :- qcn_raw_relation(T,A,B,R), qcn_edge(A,B).
qcn_relation(T,B,A,RI) :- qcn_raw_relation(T,A,B,R), qcn_edge(B,A), converse(point,R,RI).

qcn_holds_relation(T,A,B,R) :-
    qcn_relation(T,A,B,R).

qcn_holds_relation(T,A,B,R) :-
    qcn_relation(T,B,A,RI),
    converse(point,RI,R).

:- holds_constraint(
       T,
       landmark_relation(
           V1, land(L1),
           V2, land(L2),
           R
       )
   ),
   not qcn_holds_relation(
       T,
       landmark(V1,L1),
       landmark(V2,L2),
       R
   ).

% LABEL BASE RELATIONS
1 {qcn_relation(T,FROM,TO,RELATION): baserelation(point,RELATION)} 1:- qcn_edge(FROM,TO), time(T).

% ALGEBRAIC CLOSURE
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
   
% STATIC CONSTRAINTS:- qcn_relation(T,FROM,TO,REL), not qcn_constraint(T,FROM,TO,REL), qcn_constraint(T,FROM,TO,OTHER).