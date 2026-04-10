% Hierarchy
entity(S) :- entity(S,_).
entity(E) :- quantity(E,_).
quantity(Q) :- quantity(_,Q).

quantityspace(Q, VALUE) :- quantityspace(Q,VALUE, LABEL).

% Unconditional 
rule(influence(RATE, FROM, TO, T)) :- influence(RATE, FROM, TO), timepoint(T).
influence(RATE, FROM, TO, T) :- not exclude(influence(RATE, FROM, TO, T)), rule(influence(RATE, FROM, TO, T)).

rule(proportionality(RATE, FROM, TO, T)) :- proportionality(RATE, FROM, TO), timepoint(T).
proportionality(RATE, FROM, TO, T) :- not exclude(proportionality(RATE, FROM, TO, T)), rule(proportionality(RATE, FROM, TO, T)).

rule(correspondence(Q1, Q2, T)) :- correspondence(Q1, Q2), timepoint(T).
correspondence(Q1, Q2, T) :- not exclude(correspondence(Q1, Q2, T)), rule(correspondence(Q1, Q2, T)).

rule(correspondence_inverse(Q1, Q2, T)) :- correspondence_inverse(Q1, Q2), timepoint(T).
correspondence_inverse(Q1, Q2, T) :- not exclude(correspondence_inverse(Q1, Q2, T)), rule(correspondence_inverse(Q1, Q2, T)).

% Simmulation Utils
timestep(T,NEXT) :- timepoint(T), timepoint(NEXT),
    NEXT = T + 1.

inc(Q,VALUE,NEW) :- quantityspace(Q, VALUE),quantityspace(Q, NEW),
    NEW = VALUE + 1.

dec(Q,VALUE,NEW) :- quantityspace(Q, VALUE),quantityspace(Q, NEW),
    NEW = VALUE - 1.


% Any initial state that is undefined will be abduced:
% % Guessed Initial State
{guessed(value(Q,0,V)): quantityspace(Q,V)} = 1 :- quantity(Q).
{guessed(delta(Q,0,D)): quantityspace(delta,D)} = 1 :- quantity(Q).
{guessed(relation(Q1,Q2,0,R)): quantityspace(relation,R)} = 1 :- relation(Q1,Q2).
value(Q,T,V) :- guessed(value(Q,T,V)).
delta(Q,T,D) :- guessed(delta(Q,T,D)).
relation(Q1,Q2,T,R) :- guessed(relation(Q1,Q2,T,R)).


% Idle
{value(Q1, NEXT, VALUE)}   :- timestep(T,NEXT),
    value(Q1, T, VALUE).

{delta(Q1, NEXT, RATE)}  :- timestep(T,NEXT),
    delta(Q1, T, RATE).

{relation(Q1,Q2,NEXT,REL)} :- timestep(T,NEXT),
    relation(Q1,Q2,T,REL).

% The idel rule can not apply when the deltas are differnt on a = relation
:- timestep(T,NEXT), relation(I,O,T,0), relation(I,O,NEXT,0), 
    delta(I,T,VALUE), delta(O,T,DIFFERNET),
    VALUE != DIFFERNET.


% Default Transition
{value(Q1, NEXT, NEW)} :- timestep(T,NEXT),
    delta(Q1, T, 1),
    value(Q1, T, OLD),
    inc(Q1, OLD, NEW).

{value(Q1, NEXT, NEW)} :- timestep(T,NEXT),
    delta(Q1, T, -1),
    value(Q1, T, OLD),
    dec(Q1, OLD, NEW).


relation(I,O) :- competing(I,T,O,STATE), timepoint(STATE).

% Concrete Relations
:- relation(I,O),
    value(I,STATE,0),
    value(O,STATE,0),
    not relation(I,O,STATE, 0).

:- relation(I,O),
    value(I,STATE,IV),
    value(O,STATE,OV),
    IV > OV,
    not relation(I,O,STATE, 1).

:- relation(I,O),
    value(I,STATE,IV),
    value(O,STATE,OV),
    IV < OV,
    not relation(I,O,STATE, -1).

    

%%% INEQUALITY REASONING
% Possible Transitions of relations

{relation(Q1,Q2,NEXT,1)} :- timestep(T,NEXT),
    relation(Q1,Q2,T,0),
    delta(Q1,T,1).
    
{relation(Q1,Q2,NEXT,0)} :- timestep(T,NEXT),
    relation(Q1,Q2,T,-1),
    delta(Q1,T,1).

{relation(Q1,Q2,NEXT,1)} :- timestep(T,NEXT),
    relation(Q1,Q2,T,0),
    delta(Q2,T,1).

{relation(Q1,Q2,NEXT,0)} :- timestep(T,NEXT),
    relation(Q1,Q2,T,-1),
    delta(Q2,T,1).

{relation(Q1,Q2,NEXT,-1)} :- timestep(T,NEXT),
    relation(Q1,Q2,T,0),
    delta(Q1,T,-1).

{relation(Q1,Q2,NEXT,0)} :- timestep(T,NEXT),
    relation(Q1,Q2,T,1),
    delta(Q1,T,-1).

{relation(Q1,Q2,NEXT,-1)} :- timestep(T,NEXT),
    relation(Q1,Q2,T,0),
    delta(Q2,T,-1).

{relation(Q1,Q2,NEXT,0)} :- timestep(T,NEXT),
    relation(Q1,Q2,T,1),
    delta(Q2,T,-1).


:- timestep(T,NEXT), relation(I,O,T,0),
    delta(I,T,SAME), delta(O,T,SAME), SAME != 0,
    influence(SAME,ANYI,I,T), influence(SAME,ANYO,O,T),
    not blocked(ANYI,I,T), not blocked(ANYO,O,T),
    effective(ANYI,T), effective(ANYO,T),
    relation(ANYI,ANYO,T,REL),
    not relation(I,O,NEXT,REL * SAME).

% Forbidden transition Special clause
% When the last relation was a "=" then the transition can not work against the faster changing quantity

quantityspace(relation, 1, ">").
quantityspace(relation, 0, "=").
quantityspace(relation,-1, "<").

quantityspace(delta, 1, increase).
quantityspace(delta, 0, neutral).
quantityspace(delta,-1, decrease).

% % CONSTRAINTS
:- quantity(Q),  timepoint(T), not value(Q,T,_).
:- relation(Q1,Q2), timepoint(T), not relation(Q1,Q2,T,_).
:- observationQuantity(Q,T,VALUE), not value(Q,T,VALUE).
:- observationDelta(Q,T,VALUE), not delta(Q,T,VALUE).
:- observationRelation(Q1,Q2,T,VALUE), not relation(Q1,Q2,T,VALUE).
:- value(Q,T,VALUE), VALUE != OTHER, value(Q,T,OTHER).
:- delta(Q,T,VALUE), VALUE != OTHER, delta(Q,T,OTHER).
:- quantity(Q),  timepoint(T), not delta(Q,T,_).
:- irelation(A,B,T,V), irelation(A,B,T,O), V != O.


irelation(A,B,T,V) :- relation(A,B,T,V).
irelation(A,B,T,INV) :- irelation(B,A,T,V), flip(relation,V,INV).
% an implied relation
% they propagate over corrsponcences
irelation(A,B,T,R) :- correspondence(C,A,T), irelation(C,B,T,R).
irelation(A,B,T,R) :- correspondence(A,C,T), irelation(C,B,T,R).


% RELATIONAL ALGEBRA:
% Composition Table
compose( 0, 0, 0). % compose("=","=", "=").
compose( 0,-1,-1). % compose("=","<", "<").
compose( 0, 1, 1). % compose("=",">", ">").
compose(-1, 0,-1). % compose("<","=", "<").
compose(-1,-1,-1). % compose("<","<", "<").
compose(-1, 1,-1). % compose("<",">", "<"). 
compose(-1, 1, 1). % compose("<",">", ">").
compose(-1, 1, 0). % compose("<",">", "=").
compose( 1, 0, 1). % compose(">","=", ">").
compose( 1,-1,-1). % compose(">","<", "<").
compose( 1,-1, 0). % compose(">","<", "=").
compose( 1,-1, 1). % compose(">","<", ">").
compose( 1, 1, 1). % compose(">",">", ">").
