%
% Garp-style derivative causality / inertia layer
%

#program base.

qstep(p(from), i(from,to)) :-
    time(p(from)).

qstep(i(from,to), p(to)) :-
    time(p(to)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Direction support
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

prop_dir(1,D,D) :-
    qdir(D).

prop_dir(-1,D,DI) :-
    qdirNeg(D,DI).


% Direct influence support.
direction_supported(T,To,D) :-
    holds_constraint(T,influence(P,From,To)),
    influence_dir(T,From,To,D),
    not suspended_constraint(T,influence(P,From,To)).

% Equal influence balance supports std.
direction_supported(T,To,std) :-
    equal_influence_balance(T,To).

% Proportionality support.
direction_supported(T,To,DTo) :-
    holds_constraint(T,proportionality(P,From,To)),
    holds_dir(T,From,DFrom),
    prop_dir(P,DFrom,DTo).

% Exogenous quantities may take any derivative.
direction_supported(T,V,D) :-
    exogenous(V),
    qdir(D),
    time(T).

direction_supported(T,V,D) :-
    exogenous(V,T),
    qdir(D),
    time(T).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rule 1: no non-neutral derivative without directional support
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- time(T),
   qvar(V),
   holds_dir(T,V,D),
   D != std,
   not direction_supported(T,V,D).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rule 2: derivative changes need source-state support
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dir_changed(T0,T1,V) :-
    qstep(T0,T1),
    holds_dir(T0,V,D0),
    holds_dir(T1,V,D1),
    D0 != D1.

% A derivative may change to D if D was already supported in the source state.
dir_change_allowed(T0,T1,V) :-
    qstep(T0,T1),
    holds_dir(T1,V,D),
    direction_supported(T0,V,D).

% A derivative may change to std if std is supported in the target state.
% This handles newly reached balances.
dir_change_allowed(T0,T1,V) :-
    qstep(T0,T1),
    holds_dir(T1,V,std),
    direction_supported(T1,V,std).

% Terminal stop: increasing into upper landmark.
dir_change_allowed(i(from,to),p(to),V) :-
    holds(i(from,to),V,interval(_,L),inc),
    holds(p(to),V,land(L),std),
    last_landmark(V,L).

% Terminal stop: decreasing into lower landmark.
dir_change_allowed(i(from,to),p(to),V) :-
    holds(i(from,to),V,interval(L,_),dec),
    holds(p(to),V,land(L),std),
    first_landmark(V,L).

:- dir_changed(T0,T1,V),
   not dir_change_allowed(T0,T1,V).