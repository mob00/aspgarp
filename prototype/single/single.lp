% Cannon state (origin of transition)
holds(V,Q,D) :- not time(p(from)), holds(i(from,to),V,Q,D).
holds(V,Q,D) :- time(p(from)), holds( p(from),V,Q,D).

% Time steps and intervals
1 { time(p(from)) ; time(p(to)) } 1.
time(i(from, to)).

1 { holds( p(from),V,Q,D) : qmag(V,Q), qdir(D) } 1 :-
   qvar(V), time(p(from)).
1 { holds(i(from,to),V,Q,D) : qmag(V,Q), qdir(D) } 1 :-
   qvar(V), not time(p(from)).

holds(p(from),V,Q,D) :- init(V,Q,D), time(p(from)).
holds(i(from,to),V,Q,D) :- init(V,Q,D), not time(p(from)).


qstep(p(from), i(from,to)) :-
    time(p(from)).

qstep(i(from,to), p(to)) :-
    time(p(to)).

