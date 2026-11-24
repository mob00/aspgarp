%
% Garp causality and custom dynamics
%

#program base.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Direction support
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

direction_supported(T,To,D) :-
    net_influence_dir(T,To,D).

direction_supported(T,To,D) :-
    net_proportionality_dir(T,To,D).

% Exogenous quantities may take any derivative.
exogenous_at(T,V) :-
    exogenous(V),
    time(T).

exogenous_at(T,V) :-
    exogenous(V,T),
    time(T).

direction_supported(T,V,D) :-
    exogenous_at(T,V),
    qdir(D).


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

% An external change can supply a new derivative even when the set of
% supported directions stays the same across the step.
dir_change_allowed(T0,T1,V) :-
    dir_changed(T0,T1,V),
    exogenous_at(T0,V),
    exogenous_at(T1,V).

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

causal_target(influence(Sign,From,To),To) :-
    rule(_,_,influence(Sign,From,To)).

causal_target(proportionality(Sign,From,To),To) :-
    rule(_,_,proportionality(Sign,From,To)).

% A newly active cause is circular when every active rule for that cause
% depends on the target's magnitude change.
self_activated_influence(T0,T1,V) :-
    mag_changed(T0,T1,V),
    causal_target(Cause,V),
    holds_constraint(T1,Cause),
    not holds_constraint(T0,Cause),
    precond_depends_on(P,V) : rule(_,P,Cause), holds_precond(T1,P).

% An influence may become non-zero because its source has just crossed zero.
% In that event the target may acquire the new derivative, but it cannot also
% leave its current magnitude region in the same transition. The derivative
% change must be represented by the intermediate point state first.
source_activated_influence_motion(T0,T1,To) :-
    qstep(T0,T1),
    mag_changed(T0,T1,To),
    holds_dir(T0,To,std),
    rule(_,P,influence(Sign,From,To)),
    holds_precond(T1,P),
    holds_mag(T0,From,land(Z)),
    zero_landmark(From,Z),
    holds_mag(T1,From,M),
    M != land(Z),
    influence_dir(T1,From,To,D),
    D != std,
    not direction_supported(T0,To,D).

% A changed causal context may introduce a newly supported derivative, unless
% that support comes from a process whose activation depends on the target's
% change itself.
dir_change_allowed(T0,T1,V) :-
    qstep(T0,T1),
    direction_support_changed(T0,T1,V),
    holds_dir(T1,V,D),
    direction_supported(T1,V,D),
    not self_activated_influence(T0,T1,V),
    not source_activated_influence_motion(T0,T1,V).

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

dir_change_allowed(i(From,To),p(To),V) :-
    qstep(i(From,To),p(To)),
    holds(i(From,To),V,interval(_,L),inc),
    holds(p(To),V,land(L),std),
    last_landmark(V,L).

dir_change_allowed(i(From,To),p(To),V) :-
    qstep(i(From,To),p(To)),
    holds(i(From,To),V,interval(L,_),dec),
    holds(p(To),V,land(L),std),
    first_landmark(V,L).

:- dir_changed(T0,T1,V),
   not dir_change_allowed(T0,T1,V).
