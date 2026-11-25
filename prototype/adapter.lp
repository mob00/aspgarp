%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Observation / projection layer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

from_state :-
    time(p(from)).

to_state :-
    time(p(to)).

obs_time(p(from)) :-
    from_state.

obs_time(p(to)) :-
    to_state.

obs(holds(Var,Mag,Dir)) :-
    obs_time(T),
    holds(T,Var,Mag,Dir),
    observable(Var).

obs(holds_relation((From,To),Rel)):-
    obs_time(T),
    holds_relation(T,(From,To),Rel),
    observable(relation(From, To)).

% An observed ordering is part of the candidate state and constrains its
% influence balance.
qcn_known_relation(T,qvar(From),qvar(To),Rel) :-
    qcn_closure_needed(T),
    observable(relation(From,To)),
    holds_relation(T,(From,To),Rel).

% Endpoint 0 is the source and endpoint 1 is the destination of the step.
transition_endpoint(0,p(from)) :- time(p(from)).
transition_endpoint(1,p(to)) :- time(p(to)).
transition_endpoint(1,i(from,to)) :- time(i(from,to)), time(p(from)).
transition_endpoint(0,i(from,to)) :- time(i(from,to)), time(p(to)).

obsT(holds(Endpoint,Var,Mag,Dir)) :-
    transition_endpoint(Endpoint,T),
    holds(T,Var,Mag,Dir),
    observable(Var).

obsT(holds_relation(Endpoint,(From,To),Rel)) :-
    transition_endpoint(Endpoint,T),
    holds_relation(T,(From,To),Rel),
    observable(relation(From,To)).
