sim(s).

% Cannon state (origin of transition)
holds(S,V,Q,D) :- not time(p((S,from))), holds(i((S,from), (S,to)),V,Q,D).
holds(S,V,Q,D) :- time(p((S,from))), holds( p((S,from)),V,Q,D).

% Time steps and intervals
1 { time(p((S,from))) ; time(p((S,to))) } 1 :- sim(S).
time(i((S,from), (S,to))):- sim(S).

1 { holds( p((S,from)),V,Q,D) : qmag(V,Q), qdir(D) } 1 :-
   qvar(V), time(p((S,from))).
1 { holds(i((S,from), (S,to)),V,Q,D) : qmag(V,Q), qdir(D) } 1 :-
   qvar(V), not time(p((S,from))), sim(S).

holds(p((S,from)),V,Q,D) :- init(V,Q,D), time(p((S,from))).
holds(i((S,from), (S,to)),V,Q,D) :- init(V,Q,D), not time(p((S,from))), sim(S).

qstep_p2i(p((S,from)), i((S,from), (S,to))) :-
    time(p((S,from))).

qstep_i2p(i((S,from), (S,to)), p((S,to))) :-
    time(p((S,to))).

qstep(T0,T1) :-
    qstep_p2i(T0,T1).
qstep(T0,T1) :-
    qstep_i2p(T0,T1).