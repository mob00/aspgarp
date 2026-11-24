%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculi (minus)
% minus(A,B,C) where C = A - B
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rule(garp_minus(A,B,C), true, minus(A,B,C)) :-
    minus(A,B,C).

% Use one numeric zero for all subtractions, including in spaces without a
% zero landmark. Keep it equal to any zero landmarks declared by the model.
qcn_fixed_node(numeric_zero) :-
    holds_constraint(_,minus(_,_,_)).

qcn_constraint(T,numeric_zero,landmark(V,Z),eq) :-
    qcn_fixed_node(numeric_zero),
    zero_landmark(V,Z),
    time(T).

% The signs of A-B and C must agree in the completed assignment.
:- holds_constraint(T,minus(A,B,C)),
   qcn_holds_relation(T,qvar(A),qvar(B),R),
   not qcn_holds_relation(T,qvar(C),numeric_zero,R).

% A forced ordering on either side of the equation also gives one on the other.
qcn_known_relation(T,qvar(C),numeric_zero,R) :-
    holds_constraint(T,minus(A,B,C)),
    qcn_known_relation(T,qvar(A),qvar(B),R).

qcn_known_relation(T,qvar(A),qvar(B),R) :-
    holds_constraint(T,minus(A,B,C)),
    qcn_known_relation(T,qvar(C),numeric_zero,R).

% Subtracting zero preserves the minuend.
:- holds_constraint(T,minus(A,B,C)),
   qcn_holds_relation(T,qvar(B),numeric_zero,eq),
   not qcn_holds_relation(T,qvar(A),qvar(C),eq).

qcn_known_relation(T,qvar(A),qvar(C),eq) :-
    holds_constraint(T,minus(A,B,C)),
    qcn_known_relation(T,qvar(B),numeric_zero,eq).
