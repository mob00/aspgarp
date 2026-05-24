% Misc

source(qvar(From), influence(P,From,To)) :- rule(RID,_, influence(P,From,To)).
source(qvar(From), proportionality(P,From,To)) :- rule(RID,_, proportionality(P,From,To)).
target(qvar(To), influence(P,From,To)) :- rule(RID,_, influence(P,From,To)).
target(qvar(To), proportionality(P,From,To)) :- rule(RID,_, proportionality(P,From,To)).
cdtype(influence, influence(P,From,To)) :- rule(RID,_, influence(P,From,To)).
cdtype(proportionality, proportionality(P,From,To)) :- rule(RID,_, proportionality(P,From,To)).
polarity(P,influence(P,From,To)) :- rule(RID,_, influence(P,From,To)).
polarity(P,proportionality(P,From,To)) :- rule(RID,_, proportionality(P,From,To)).
polarity(P,correspondence(P,Q1,Q2)) :- rule(RID,_, correspondence(P,Q1,Q2)).

display("I+", influence(P,From,To)) :- rule(RID,_, influence(P,From,To)), polarity(1, influence(P,From,To)).
display("I-", influence(P,From,To)) :- rule(RID,_, influence(P,From,To)), polarity(-1, influence(P,From,To)).
display("P+", proportionality(P,From,To)) :- rule(RID,_, proportionality(P,From,To)), polarity(1, proportionality(P,From,To)).
display("P-", proportionality(P,From,To)) :- rule(RID,_, proportionality(P,From,To)), polarity(-1, proportionality(P,From,To)).
display("C", correspondence(P,V1,V2)) :- rule(RID,_, correspondence(P,V1,V2)), polarity(1, correspondence(P,V1,V2)).
display("-C", correspondence(P,V1,V2)) :- rule(RID,_, correspondence(P,V1,V2)), polarity(-1, correspondence(P,V1,V2)).


directional_value_correspondence(value_correspondence(V1, MAG1, V2, MAG2)) :- rule(RID,_, value_correspondence(V1, MAG1, V2, MAG2)), not rule(_,_, value_correspondence(V2, MAG2, V1, MAG1)).
1{undirected_value_correspondence(value_correspondence(V1, MAG1, V2, MAG2)); % need to discide which one has the precident when drawing...
  undirected_value_correspondence(value_correspondence(V2, MAG2, V1, MAG1))}1 :- rule(RID,_, value_correspondence(V1, MAG1, V2, MAG2)), rule(_,_, value_correspondence(V2, MAG2, V1, MAG1)).
% Causal Models
% =============

% Quantities
node(qvar(V)) :- qvar(V,_).
attr(node, qvar(V), label, V) :- qvar(V,_).

% Causal Depencencies
edge((qvar(From), qvar(To),RID)) :- rule(RID,_, CD), source(qvar(From), CD), target(qvar(To), CD).
attr(edge, (qvar(From), qvar(To), RID), dir, forward) :- rule(RID,_, CD), source(qvar(From), CD), target(qvar(To), CD).
attr(edge, (qvar(From), qvar(To), RID), label, X) :- rule(RID,_, CD), source(qvar(From), CD), target(qvar(To), CD), polarity(P, CD), display(X, CD).

% Correspondences (Value Correspondences)
% Directed
edge((qvar(V1), qvar(V2), RID)) :- directional_value_correspondence(value_correspondence(V1, MAG1, V2, MAG2)), rule(RID,_, value_correspondence(V1, MAG1, V2, MAG2)).
attr(edge, (qvar(V1), qvar(V2), RID), dir, forward) :- directional_value_correspondence(value_correspondence(V1, MAG1, V2, MAG2)), rule(RID,_, value_correspondence(V1, MAG1, V2, MAG2)).
attr(edge, (qvar(V1), qvar(V2), RID), headlabel, MAG2) :- directional_value_correspondence(value_correspondence(V1, MAG1, V2, MAG2)), rule(RID,_, value_correspondence(V1, MAG1, V2, MAG2)).
attr(edge, (qvar(V1), qvar(V2), RID), taillabel, MAG1) :- directional_value_correspondence(value_correspondence(V1, MAG1, V2, MAG2)), rule(RID,_, value_correspondence(V1, MAG1, V2, MAG2)).

% Undirected
edge((qvar(V1), qvar(V2), RID)) :- undirected_value_correspondence(value_correspondence(V1, MAG1, V2, MAG2)), rule(RID,_, value_correspondence(V1, MAG1, V2, MAG2)).
attr(edge, (qvar(V1), qvar(V2), RID), headlabel, MAG2) :- undirected_value_correspondence(value_correspondence(V1, MAG1, V2, MAG2)), rule(RID,_, value_correspondence(V1, MAG1, V2, MAG2)).
attr(edge, (qvar(V1), qvar(V2), RID), taillabel, MAG1) :- undirected_value_correspondence(value_correspondence(V1, MAG1, V2, MAG2)), rule(RID,_, value_correspondence(V1, MAG1, V2, MAG2)).


% Correspondences
% Undirected
edge((qvar(V1), qvar(V2), RID)) :- rule(RID,_,correspondence(M, V1, V2)).
attr(edge, (qvar(V1), qvar(V2), RID), dir, none) :- rule(RID,_,correspondence(M, V1, V2)).
attr(edge, (qvar(V1), qvar(V2), RID), label, DISPLAY) :- rule(RID,_,correspondence(M, V1, V2)), display(DISPLAY,correspondence(M, V1, V2)).


% Relational Constraints
edge((qvar(V1), qvar(V2), RID)) :- rule(RID,_, algebraic(V1, REL, V2)).
attr(edge, (qvar(V1), qvar(V2), RID), dir, forward) :- rule(RID,_, algebraic(V1, REL, V2)).
attr(edge, (qvar(V1), qvar(V2), RID), label, REL) :- rule(RID,_, algebraic(V1, REL, V2)).
