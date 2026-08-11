%
% Garp causality and custom dynamics
%

#program base.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Direction support
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

prop_dir(1,D,D) :-
    qdir(D).

prop_dir(-1,D,DI) :-
    qdirNeg(D,DI).

direction_supported(T,To,D) :-
    net_influence_dir(T,To,D).

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

mag_changed(T0,T1,V) :-
    qstep(T0,T1),
    holds_mag(T0,V,M0),
    holds_mag(T1,V,M1),
    M0 != M1.

% A change in the available causal directions is an event that can justify
% reconsidering the derivative even without crossing a magnitude boundary.
direction_support_changed(T0,T1,V) :-
    qstep(T0,T1),
    direction_supported(T0,V,D),
    not direction_supported(T1,V,D).

direction_support_changed(T0,T1,V) :-
    qstep(T0,T1),
    direction_supported(T1,V,D),
    not direction_supported(T0,V,D).

% At a qualitative magnitude boundary, an ambiguous influence result may be
% resolved again. The new direction must be causally possible on at least one
% side of the transition.
dir_change_allowed(T0,T1,V) :-
    qstep(T0,T1),
    mag_changed(T0,T1,V),
    holds_dir(T0,V,D0),
    D0 != std,
    holds_dir(T1,V,D),
    direction_supported(T0,V,D).

dir_change_allowed(T0,T1,V) :-
    qstep(T0,T1),
    mag_changed(T0,T1,V),
    holds_dir(T0,V,D0),
    D0 != std,
    holds_dir(T1,V,D),
    direction_supported(T1,V,D).

% Identify a circular process activation: an influence becomes applicable
% only after its own target has crossed the precondition boundary.
precond_depends_on(P,V) :-
    precond(P,equal,V,_).

precond_depends_on(P,V) :-
    precond(P,less_than,V,_).

precond_depends_on(P,V) :-
    precond(P,greater_than,V,_).

precond_depends_on(P,V) :-
    precond(P,bound,V,_,_,_,_).

precond_depends_on(P,V) :-
    precond(P,and,Sub),
    precond_depends_on(Sub,V).

precond_depends_on(P,V) :-
    precond(P,or,Sub),
    precond_depends_on(Sub,V).

precond_depends_on(P,V) :-
    precond(P,neg,Sub),
    precond_depends_on(Sub,V).

self_activated_influence(T0,T1,V) :-
    qstep(T0,T1),
    mag_changed(T0,T1,V),
    rule(_,P,influence(_,_,V)),
    precond_depends_on(P,V),
    not holds_precond(T0,P),
    holds_precond(T1,P).

self_activated_influence(T0,T1,V) :-
    qstep(T0,T1),
    mag_changed(T0,T1,V),
    rule(_,P,proportionality(_,_,V)),
    precond_depends_on(P,V),
    not holds_precond(T0,P),
    holds_precond(T1,P).

% A changed causal context may introduce a newly supported derivative, unless
% that support comes from a process whose activation depends on the target's
% change itself.
dir_change_allowed(T0,T1,V) :-
    qstep(T0,T1),
    direction_support_changed(T0,T1,V),
    holds_dir(T1,V,D),
    direction_supported(T1,V,D),
    not self_activated_influence(T0,T1,V).

% If the causal support for a non-neutral derivative disappears at an event,
% the quantity may settle. Unlike a new non-neutral derivative, std needs no
% positive causal support of its own.
dir_change_allowed(T0,T1,V) :-
    qstep(T0,T1),
    direction_support_changed(T0,T1,V),
    holds_dir(T0,V,D0),
    D0 != std,
    holds_dir(T1,V,std),
    not direction_supported(T1,V,D0).

dir_change_allowed(i(from,to),p(to),V) :-
    holds(i(from,to),V,interval(_,L),inc),
    holds(p(to),V,land(L),std),
    last_landmark(V,L).

dir_change_allowed(i(from,to),p(to),V) :-
    holds(i(from,to),V,interval(L,_),dec),
    holds(p(to),V,land(L),std),
    first_landmark(V,L).

:- dir_changed(T0,T1,V),
   not dir_change_allowed(T0,T1,V).
