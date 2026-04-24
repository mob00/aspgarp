%
% Garp-style derivative causality / inertia layer
%
% This layer prevents QSIM-style spontaneous changes of derivative.
%
% Policy:
%   1. A non-neutral derivative must be causally supported.
%   2. A derivative may change only if the target has an active causal
%      dependency, is exogenous, or is forced to stop at a terminal landmark.
%

#program base.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step relation between the two QSIM states in the single-transition encoding
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

qstep(p(from), i(from,to)) :-
    time(p(from)).

qstep(i(from,to), p(to)) :-
    time(p(to)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Causal targets
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% A variable has causal derivative support if it is the target of an active
% Garp dependency.
%
% influence(_,From,To)        supports derivative of To
% proportionality(_,From,To)  supports derivative of To
%
% correspondence does NOT support a derivative by itself. It only constrains
% magnitudes.
%

causal_target(T,To) :-
    holds_constraint(T, influence(_,_,To)).

causal_target(T,To) :-
    holds_constraint(T, proportionality(_,_,To)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exogenous quantities
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Use this if you intentionally want a quantity to change without being caused
% by another quantity.
%
% Example:
%   exogenous(rainfall).
%
% or time-specific:
%   exogenous(rainfall,p(from)).
%   exogenous(rainfall,i(from,to)).
%

causal_target(T,V) :-
    exogenous(V),
    time(T).

causal_target(T,V) :-
    exogenous(V,T),
    time(T).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rule 1: no non-neutral derivative without support
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Empty model consequence:
%   no influence/proportionality/exogenous declarations
%   => every variable must have direction std.
%

:- time(T),
   qvar(V),
   holds_dir(T,V,D),
   D != std,
   not causal_target(T,V).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rule 2: derivative changes need justification
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dir_changed(T0,T1,V) :-
    qstep(T0,T1),
    holds_dir(T0,V,D0),
    holds_dir(T1,V,D1),
    D0 != D1.

dir_change_allowed(T0,T1,V) :-
    qstep(T0,T1),
    causal_target(T1,V).

dir_change_allowed(T0,T1,V) :-
    qstep(T0,T1),
    exogenous(V).

dir_change_allowed(T0,T1,V) :-
    qstep(T0,T1),
    exogenous(V,T1).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Terminal stopping exception
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% If a variable reaches the last landmark while increasing, it may become std.
% If a variable reaches the first landmark while decreasing, it may become std.
%
% This allows transitions like:
%
%   interval(medium,large), inc  ->  land(large), std
%
% without treating that as an unexplained derivative change.
%

dir_change_allowed(i(from,to),p(to),V) :-
    holds(i(from,to),V,interval(_,L),inc),
    holds(p(to),V,land(L),std),
    last_landmark(V,L).

dir_change_allowed(i(from,to),p(to),V) :-
    holds(i(from,to),V,interval(L,_),dec),
    holds(p(to),V,land(L),std),
    first_landmark(V,L).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Enforce derivative inertia
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- dir_changed(T0,T1,V),
   not dir_change_allowed(T0,T1,V).