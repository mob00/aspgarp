
% Proportionality
violation :- proportionality(1, FROM, TO, T),
    not blocked(FROM,TO,T),
    delta(FROM, T, RATE),
    not delta(TO, T, RATE), active(T).

violation :-  proportionality(-1, FROM, TO, T),
    not blocked(FROM,TO,T),
    flip(delta,CONVERSE, RATE),
    delta(FROM, T, CONVERSE),
    not delta(TO, T, RATE),active(T).

% Influence
violation :- timestep(T,NEXT),
    influence(RATE, FROM, TO, T),
    delta(FROM, T, PREVIOUS),
    effective(FROM,NEXT),
    not blocked(FROM,TO,NEXT),
    not delta(TO, NEXT, RATE), active(NEXT).

effective(INFLUENCE, T) :-
    value(INFLUENCE, T, EFFECTIVE),
    EFFECTIVE > 0.

% STATE WHISE CONSTRAINT:
% an active influence can not have another delta than the expected one particularly when guessed.
violation :- influence(RATE, FROM, TO, T), delta(FROM, T, DELTA), effective(FROM,T), not blocked(FROM,TO,T),
    RATE != DELTA, active(T).

% an active proportionality can not have another delta than the expected one particularly when guessed.
violation :- proportionality(RATE, FROM, TO, T), delta(FROM, T, DELTA), effective(FROM,T), not blocked(FROM,TO,T),
    RATE != DELTA, active(T).

% Correspondence
% For Landmark Correspondence use Conditionals!
violation :- correspondence(Q1, Q2, T), value(Q1, T, VALUE), not value(Q2, T, VALUE), active(T).
violation :- correspondence(Q1, Q2, T), value(Q2, T, VALUE), not value(Q1, T, VALUE), active(T).

% Inverse Correspondence means nessessary flipped values on quantityspace
violation :- correspondence_inverse(Q1, Q2, T), flip(Q2, VALUE, FLIPPED), value(Q2, T, FLIPPED), not value(Q1, T, VALUE), active(T).
violation :- correspondence_inverse(Q1, Q2, T), flip(Q1, VALUE, FLIPPED), value(Q1, T, FLIPPED), not value(Q2, T, VALUE), active(T).

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

% Calculations 
% Subtracting two quantities
violation :- calculus(Q1, minus, Q2, "=", Q3), 
    relation(Q1, Q2, T, 0),
    not value(Q3, T, 0).

violation :- calculus(Q1, minus, Q2, "=", Q3), 
    relation(Q1, Q2, T, -1), 
    value(Q3, T, V), V > 0.

violation :- calculus(Q1, minus, Q2, "=", Q3),
    relation(Q1, Q2, T, 1), 
    value(Q3, T, V), V <= 0.


% Calculations
% Handcoded rule for mult
% This should be solved more elegantly in the future.... no time to overthink it for now....
violation :- calculus(Q1a, mult, Q2a, "=", Q3a), calculus(Q1b, mult, Q2b, "=", Q3b), Q1a != Q1b, Q2a != Q2b, Q3a != Q3b,
   relation(Q1a, Q1b, T, R1), relation(Q2a, Q2b, T, R2),  relation(Q3a, Q3b, T, R3),
   not compose(R1, R2, R3), not value(Q3a, T, 0), not value(Q3b, T, 0).

violation :- calculus(Q1, mult, Q2, "=", Q3), value(Q1, T, 0), not value(Q3, T, 0).
violation :- calculus(Q1, mult, Q2, "=", Q3), value(Q2, T, 0), not value(Q3, T, 0).