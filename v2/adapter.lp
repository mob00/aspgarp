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


obsT(holds(0,Var,Label,DirLabel)) :-
    time(T),
    T = p(from),
    holds(T,Var,Mag,Dir),
    mag_label(Var,Mag,Label),
    dir_label(Dir,DirLabel).

obsT(holds(1,Var,Label,DirLabel)) :-
    time(T),
    T = p(to),
    holds(T,Var,Mag,Dir),
    mag_label(Var,Mag,Label),
    dir_label(Dir,DirLabel).

obsT(holds(1,Var,Label,DirLabel)) :-
    time(T),
    T = i(from,to),
    time(p(from)),
    holds(T,Var,Mag,Dir),
    mag_label(Var,Mag,Label),
    dir_label(Dir,DirLabel).

obsT(holds(0,Var,Label,DirLabel)) :-
    time(T),
    T = i(from,to),
    time(p(to)),
    holds(T,Var,Mag,Dir),
    mag_label(Var,Mag,Label),
    dir_label(Dir,DirLabel).