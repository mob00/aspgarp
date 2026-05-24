% Misc

source(qvar(From), influence(P,From,To)) :- rule(RID,_, influence(P,From,To)).
source(qvar(From), proportionality(P,From,To)) :- rule(RID,_, proportionality(P,From,To)).
target(qvar(To), influence(P,From,To)) :- rule(RID,_, influence(P,From,To)).
target(qvar(To), proportionality(P,From,To)) :- rule(RID,_, proportionality(P,From,To)).
cdtype(influence, influence(P,From,To)) :- rule(RID,_, influence(P,From,To)).
cdtype(proportionality, proportionality(P,From,To)) :- rule(RID,_, proportionality(P,From,To)).
polarity(P,influence(P,From,To)) :- rule(RID,_, influence(P,From,To)).
polarity(P,proportionality(P,From,To)) :- rule(RID,_, proportionality(P,From,To)).

display("I+", influence(P,From,To)) :- rule(RID,_, influence(P,From,To)), polarity(1, influence(P,From,To)).
display("I-", influence(P,From,To)) :- rule(RID,_, influence(P,From,To)), polarity(-1, influence(P,From,To)).
display("P+", proportionality(P,From,To)) :- rule(RID,_, proportionality(P,From,To)), polarity(1, proportionality(P,From,To)).
display("P-", proportionality(P,From,To)) :- rule(RID,_, proportionality(P,From,To)), polarity(-1, proportionality(P,From,To)).
% Causal Models
% =============

% Quantities
node(qvar(V)) :- qvar(V).
attr(node, qvar(V), label, V) :- qvar(V).

% Causal Depencencies
edge((qvar(From), qvar(To),RID)) :- rule(RID,_, CD), source(qvar(From), CD), target(qvar(To), CD).
attr(edge, (qvar(From), qvar(To), RID), dir, forward) :- rule(RID,_, CD), source(qvar(From), CD), target(qvar(To), CD).
attr(edge, (qvar(From), qvar(To), RID), label, X) :- rule(RID,_, CD), source(qvar(From), CD), target(qvar(To), CD), polarity(P, CD), display(X, CD).

% Correspondences (Value Correspondences)
edge((qvar(From), qvar(To, RID))) :- rule(RID,_, correspondence(From, To)).
attr(edge, (qvar(From), qvar(To), RID
