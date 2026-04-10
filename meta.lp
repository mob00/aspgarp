
{abduced(proportionality(1,Q,R))} :- quantity(E1,Q), quantity(E2,R), Q != R.
proportionality(1,Q,R) :- abduced(proportionality(1,Q,R)).

{abduced(proportionality(-1,Q,R))} :- quantity(E1,Q), quantity(E2,R), Q != R.
proportionality(-1,Q,R) :- abduced(proportionality(-1,Q,R)).

{abduced(influence(1,Q,R))} :- quantity(E1,Q), quantity(E2,R), Q != R.
influence(1,Q,R) :- abduced(influence(1,Q,R)).

{abduced(influence(-1,Q,R))} :- quantity(E1,Q), quantity(E2,R), Q != R.
influence(-1,Q,R) :- abduced(influence(-1,Q,R)).

{abduced(correspondence(Q, R))} :- quantity(E1,Q), quantity(E2,R), Q != R.
correspondence(Q, R) :- abduced(correspondence(Q, R)).

:- not #count{C : abduced(C)} = 1.