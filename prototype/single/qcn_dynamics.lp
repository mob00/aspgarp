%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% QCN conceptual neighbourhood over transitions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Same relation may persist.
qcn_cnh_allowed(R,R) :-
    baserelation(point,R).

% Or it may move to a conceptual neighbour.
qcn_cnh_allowed(R1,R2) :-
    cnhs(point,R1,R2).


% A QCN relation may only change via the conceptual neighbourhood.
:- qstep(T0,T1),
   qcn_edge(A,B),
   qcn_relation(T0,A,B,R0),
   qcn_relation(T1,A,B,R1),
   not qcn_cnh_allowed(R0,R1).