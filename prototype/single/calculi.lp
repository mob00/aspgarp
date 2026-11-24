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

% Subtracting zero preserves the minuend. Any shared zero can serve as a reference.
:- holds_constraint(T,minus(A,B,C)),
   zero_landmark(V,Z),
   qcn_holds_relation(T,qvar(B),landmark(V,Z),eq),
   not qcn_holds_relation(T,qvar(A),qvar(C),eq).

qcn_known_relation(T,qvar(A),qvar(C),eq) :-
    holds_constraint(T,minus(A,B,C)),
    zero_landmark(V,Z),
    qcn_known_relation(T,qvar(B),landmark(V,Z),eq).
