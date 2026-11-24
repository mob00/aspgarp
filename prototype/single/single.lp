% Observations at the origin of the transition
origin_time(p(from)) :- time(p(from)).
origin_time(i(from,to)) :- time(i(from,to)), not time(p(from)).

holds(V,Q,D) :- origin_time(T), holds(T,V,Q,D).
origin_relation(Pair,R) :- origin_time(T), holds_relation(T,Pair,R).

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

