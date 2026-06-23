%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Syntactic Constraints
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ACTIVE PROPORTIONALITY MAY NOT BE CYCLIC
proportionality_edge(T,Q,R) :-
    holds_constraint(T,_,proportionality(_,Q,R)),
    time(T).

proportionality_path(T,Q,R) :-
    proportionality_edge(T,Q,R).

proportionality_path(T,Q,R) :-
    proportionality_path(T,Q,Z),
    proportionality_edge(T,Z,R).

% no pure cycle of proportionalities may hold in one state
:- proportionality_path(T,Q,Q).