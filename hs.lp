% instance
% choose any elements
{ hit(E) } :- in(_,E).

% every set must be hit
:- in(S,_), not 1 { hit(E) : in(S,E) }.

% minimize size
#minimize {
    1,E    : hit(E)
}.
#show hit/1.

