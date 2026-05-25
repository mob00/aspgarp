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