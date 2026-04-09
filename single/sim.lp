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

% Proportionality
:- proportionality(1, FROM, TO, T),
    not blocked(FROM,TO,T),
    delta(FROM, T, RATE),
    not delta(TO, T, RATE).

:-  proportionality(-1, FROM, TO, T),
    not blocked(FROM,TO,T),
    flip(delta,CONVERSE, RATE),
    delta(FROM, T, CONVERSE),
    not delta(TO, T, RATE).

% Influence
:- timestep(T,NEXT),
    influence(RATE, FROM, TO, T),
    delta(FROM, T, PREVIOUS),
    effective(FROM,NEXT),
    not blocked(FROM,TO,NEXT),
    not delta(TO, NEXT, RATE).

effective(INFLUENCE, T) :-
    value(INFLUENCE, T, EFFECTIVE),
    EFFECTIVE > 0.

% STATE WHISE CONSTRAINT:
% an active influence can not have another delta than the expected one particularly when guessed.
:- influence(RATE, FROM, TO, T), delta(FROM, T, DELTA), effective(FROM,T), not blocked(FROM,TO,T),
    RATE != DELTA.

% an active proportionality can not have another delta than the expected one particularly when guessed.
:- proportionality(RATE, FROM, TO, T), delta(FROM, T, DELTA), effective(FROM,T), not blocked(FROM,TO,T),
    RATE != DELTA.


% Correspondence
% For Landmark Correspondence use Conditionals!
 :- correspondence(Q1, Q2, T), value(Q1, T, VALUE), not value(Q2, T, VALUE).
 :- correspondence(Q1, Q2, T), value(Q2, T, VALUE), not value(Q1, T, VALUE).

% Inverse Correspondence means nessessary flipped values on quantityspace
:- correspondence_inverse(Q1, Q2, T), flip(Q2, VALUE, FLIPPED), value(Q2, T, FLIPPED), not value(Q1, T, VALUE).
:- correspondence_inverse(Q1, Q2, T), flip(Q1, VALUE, FLIPPED), value(Q1, T, FLIPPED), not value(Q2, T, VALUE).

flip(SCALE, VALUE, FLIPPED) :- 
    quantityspace(SCALE, VALUE),
    quantityspace(SCALE, FLIPPED),
    MAX = #max { V : quantityspace(SCALE, V) },
    MIN = #min { V : quantityspace(SCALE, V) },
    DIST = MAX - VALUE,
    FLIPPED = DIST + MIN.

competing(POSITIVE, TARGET, NEGATIVE, T) :- 
    influence( 1, POSITIVE, TARGET, T),
    influence(-1, NEGATIVE, TARGET, T),
    timepoint(T).

competing(POSITIVE, TARGET, NEGATIVE, T) :- 
    proportionality( 1, POSITIVE, TARGET, T),
    proportionality(-1, NEGATIVE, TARGET, T),
    timepoint(T).

% Blocked When another Relaton overpowers the effect...
blocked(INFLUENCE, TARGET, STATE) :- 
    competing(INFLUENCE, TARGET, OTHER, STATE),
    relation(INFLUENCE, OTHER, STATE, OVERPOWERED),
    OVERPOWERED <= 0,
    timepoint(STATE).

blocked(OTHER, TARGET, STATE) :-
    competing(INFLUENCE, TARGET, OTHER, STATE),
    relation(INFLUENCE, OTHER, STATE, OVERPOWERED),
    OVERPOWERED >= 0,
    timepoint(STATE).

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


% Calculations 
% Subtracting two quantities
:- calculus(Q1, minus, Q2, "=", Q3), 
    relation(Q1, Q2, T, 0),
    not value(Q3, T, 0).

:- calculus(Q1, minus, Q2, "=", Q3), 
    relation(Q1, Q2, T, -1), 
    value(Q3, T, V), V > 0.

:- calculus(Q1, minus, Q2, "=", Q3),
    relation(Q1, Q2, T, 1), 
    value(Q3, T, V), V <= 0.


% Calculations
% Handcoded rule for mult
% This should be solved more elegantly in the future.... no time to overthink it for now....
:- calculus(Q1a, mult, Q2a, "=", Q3a), calculus(Q1b, mult, Q2b, "=", Q3b), Q1a != Q1b, Q2a != Q2b, Q3a != Q3b,
   relation(Q1a, Q1b, T, R1), relation(Q2a, Q2b, T, R2),  relation(Q3a, Q3b, T, R3),
   not compose(R1, R2, R3), not value(Q3a, T, 0), not value(Q3b, T, 0).

:- calculus(Q1, mult, Q2, "=", Q3), value(Q1, T, 0), not value(Q3, T, 0).
:- calculus(Q1, mult, Q2, "=", Q3), value(Q2, T, 0), not value(Q3, T, 0).

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
