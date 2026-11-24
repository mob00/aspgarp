%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculi (minus)
% minus(A,B,C) where C = A - B
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rule(garp_minus(A,B,C), true, minus(A,B,C)) :-
    minus(A,B,C).


% The signs of A-B and C must agree in the completed assignment.
:- holds_constraint(T,minus(A,B,C)),
   zero_landmark(C,Z),
   qcn_holds_relation(T,qvar(A),qvar(B),R),
   not qcn_holds_relation(T,qvar(C),landmark(C,Z),R).

% A forced ordering on either side of the equation also gives one on the other.
qcn_known_relation(T,qvar(C),landmark(C,Z),R) :-
    holds_constraint(T,minus(A,B,C)),
    zero_landmark(C,Z),
    qcn_known_relation(T,qvar(A),qvar(B),R).

qcn_known_relation(T,qvar(A),qvar(B),R) :-
    holds_constraint(T,minus(A,B,C)),
    zero_landmark(C,Z),
    qcn_known_relation(T,qvar(C),landmark(C,Z),R).

%
% Equal-ranked landmarks of A and B represent the same reference values. (This might be a strong assumption)
%

minus_operand_landmark_eq(T,A,B,LA,LB) :-
    holds_constraint(T,minus(A,B,_)),
    land_rank(A,LA,N),
    land_rank(B,LB,N).

qcn_constraint(T,landmark(A,LA),landmark(B,LB),eq) :-
    minus_operand_landmark_eq(T,A,B,LA,LB),
    qcn_edge(landmark(A,LA),landmark(B,LB)).

qcn_constraint(T,landmark(B,LB),landmark(A,LA),eq) :-
    minus_operand_landmark_eq(T,A,B,LA,LB),
    qcn_edge(landmark(B,LB),landmark(A,LA)).
