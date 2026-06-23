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
    
obsT(holds(0,Var,Mag,Dir)) :-
    time(T),
    T = p(from),
    holds(T,Var,Mag,Dir),
    observable(Var).

obsT(holds(1,Var,Mag,Dir)) :-
    time(T),
    T = p(to),
    holds(T,Var,Mag,Dir),
    observable(Var).

obsT(holds(1,Var,Mag,Dir)) :-
    time(T),
    T = i(from,to),
    time(p(from)),
    holds(T,Var,Mag,Dir),
    observable(Var).

obsT(holds(0,Var,Mag,Dir)) :-
    time(T),
    T = i(from,to),
    time(p(to)),
    holds(T,Var,Mag,Dir),  
    observable(Var).

obsT(holds_relation(0,(From,To),Rel)) :-
    time(T),
    T = p(from),
    holds_relation(T,(From,To),Rel),
    observable(relation(From, To)). 

obsT(holds_relation(1,(From,To),Rel)) :-
    time(T),
    T = p(to),
    holds_relation(T,(From,To),Rel),    
    observable(relation(From, To)).

obsT(holds_relation(1,(From,To),Rel)) :-
    time(T),
    T = i(from,to),
    time(p(from)),
    holds_relation(T,(From,To),Rel),
    observable(relation(From, To)).

obsT(holds_relation(0,(From,To),Rel)) :-
    time(T),
    T = i(from,to),
    time(p(to)),
    holds_relation(T,(From,To),Rel),
    observable(relation(From, To)).

