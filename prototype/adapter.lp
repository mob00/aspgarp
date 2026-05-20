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

% Pbservations for cannon state
obs(holds(Var,Mag,Dir)) :-
    obs_time(T),
    holds(T,Var,Mag,Dir).


% Observations for transitions
obsT(holds(0,Var,Mag,Dir)) :-
    time(T),
    T = p(from),
    holds(T,Var,Mag,Dir).

obsT(holds(1,Var,Mag,Dir)) :-
    time(T),
    T = p(to),
    holds(T,Var,Mag,Dir).

obsT(holds(1,Var,Mag,Dir)) :-
    time(T),
    T = i(from,to),
    time(p(from)),
    holds(T,Var,Mag,Dir).

obsT(holds(0,Var,Mag,Dir)) :-
    time(T),
    T = i(from,to),
    time(p(to)),
    holds(T,Var,Mag,Dir).