%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Garp MINUS calculus
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% minus(A,B,C) means C = A - B
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#program base.

rule(garp_minus(A,B,C), true, minus(A,B,C)) :-
    minus(A,B,C).


qcn_rel(T,A,B,R) :-
    qcn_relation(T,A,B,R).

qcn_rel(T,A,B,R) :-
    qcn_relation(T,B,A,RI),
    converse(point,RI,R).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A ? B -> C ? zero
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

minus_implies(T,qvar(C),landmark(C,Z),R) :-
    holds_constraint(T,minus(A,B,C)),
    zero_landmark(C,Z),
    qcn_rel(T,qvar(A),qvar(B),R).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% C ? zero -> A ? B
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

minus_implies(T,qvar(A),qvar(B),R) :-
    holds_constraint(T,minus(A,B,C)),
    zero_landmark(C,Z),
    qcn_rel(T,qvar(C),landmark(C,Z),R).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Emit canonical qcn_constraint/4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

qcn_constraint(T,A,B,R) :-
    minus_implies(T,A,B,R),
    qcn_edge(A,B).

qcn_constraint(T,B,A,RI) :-
    minus_implies(T,A,B,R),
    qcn_edge(B,A),
    converse(point,R,RI).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Align operand quantity spaces for MINUS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% For minus(A,B,C), A and B must be comparable.
% Equal-ranked landmarks of A and B represent the same reference values.
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