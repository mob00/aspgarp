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

obs(holds(Var,Label,DirLabel)) :-
    obs_time(T),
    holds(T,Var,Mag,Dir),
    mag_label(Var,Mag,Label),
    dir_label(Dir,DirLabel).

#show obs/1.