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

% The equation C = A - B also gives B = A - C. In either form the
% difference has the sign of the ordering between the operands.
subtraction_comparison(T,A,B,C) :- holds_constraint(T,minus(A,B,C)).
subtraction_comparison(T,A,C,B) :- holds_constraint(T,minus(A,B,C)).

:- subtraction_comparison(T,A,B,C),
   qcn_holds_relation(T,qvar(A),qvar(B),R),
   not qcn_holds_relation(T,qvar(C),numeric_zero,R).

% A forced ordering on either side of the equation also gives one on the other.
qcn_known_relation(T,qvar(C),numeric_zero,R) :-
    subtraction_comparison(T,A,B,C),
    qcn_known_relation(T,qvar(A),qvar(B),R).

qcn_known_relation(T,qvar(A),qvar(B),R) :-
    subtraction_comparison(T,A,B,C),
    qcn_known_relation(T,qvar(C),numeric_zero,R).
