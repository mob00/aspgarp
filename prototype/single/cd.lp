%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Causal Dependencies (CD) for Garp3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

holds_constraint(T,N,C) :-
    rule(N,P,C),
    holds_precond(T,P),
    time(T).

holds_constraint(T,C) :-
    holds_constraint(T,_,C).

holds_relation(T,(A,B),R) :-
    qcn_relation(T,qvar(A),qvar(B),R).

holds_relation(T,(A,B),R) :-
    qcn_relation(T,qvar(B),qvar(A),RI),
    converse(point,RI,R).

influence_dir(T,From,To,Dir) :-
    holds_constraint(T,influence(P,From,To)),
    mag_sign(T,From,Sign),
    influence_expected_dir(P,Sign,Dir).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Influence resolution
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% A completed QCN assigns a base relation to every pair. Such an assignment
% is a consistency witness, not necessarily knowledge stated by the model.
% Only an active algebraic constraint counts as a known ordering when
% resolving competing influences.

known_influence_relation(T,A,B,R) :-
    holds_constraint(T,algebraic(A,R,B)).

known_influence_relation(T,B,A,RI) :-
    holds_constraint(T,algebraic(A,R,B)),
    converse(point,R,RI).


% Canonical pair of non-zero, opposing contributions to the same target.

competing_influences(T,A,B,To,DA,DB) :-
    influence_dir(T,A,To,DA),
    influence_dir(T,B,To,DB),
    A < B,
    DA != std,
    DB != std,
    qdirNeg(DA,DB).

has_opposing_influence(T,From,To) :-
    competing_influences(T,From,_,To,_,_).

has_opposing_influence(T,From,To) :-
    competing_influences(T,_,From,To,_,_).


% An unopposed contribution determines the net direction. This also covers
% several contributions that all point in the same direction.

net_influence_dir(T,To,D) :-
    influence_dir(T,From,To,D),
    D != std,
    not has_opposing_influence(T,From,To).


% If every contribution is zero, the net influence is zero.

nonzero_influence(T,To) :-
    influence_dir(T,_,To,D),
    D != std.

net_influence_dir(T,To,std) :-
    influence_dir(T,_,To,_),
    not nonzero_influence(T,To).


% Resolve two competing contributions when their ordering is known.

net_influence_dir(T,To,DA) :-
    competing_influences(T,A,B,To,DA,_),
    known_influence_relation(T,A,B,gt).

net_influence_dir(T,To,DB) :-
    competing_influences(T,A,B,To,_,DB),
    known_influence_relation(T,A,B,lt).

net_influence_dir(T,To,std) :-
    competing_influences(T,A,B,To,_,_),
    known_influence_relation(T,A,B,eq).


% With no stated ordering, Garp keeps all qualitative resolutions possible.
% Importantly, this ambiguity is not turned into a persistent QCN relation.

known_influence_order(T,A,B) :-
    known_influence_relation(T,A,B,lt).

known_influence_order(T,A,B) :-
    known_influence_relation(T,A,B,eq).

known_influence_order(T,A,B) :-
    known_influence_relation(T,A,B,gt).

unresolved_competing_influences(T,A,B,To,DA,DB) :-
    competing_influences(T,A,B,To,DA,DB),
    not known_influence_order(T,A,B).

net_influence_dir(T,To,DA) :-
    unresolved_competing_influences(T,_,_,To,DA,_).

net_influence_dir(T,To,DB) :-
    unresolved_competing_influences(T,_,_,To,_,DB).

net_influence_dir(T,To,std) :-
    unresolved_competing_influences(T,_,_,To,_,_).
holds_precond(T,true) :-
    time(T).

rule(garp_influence(P,From,To), true, influence(P,From,To)) :-
    influence(P,From,To).

rule(garp_proportionality(P,From,To), true, proportionality(P,From,To)) :-
    proportionality(P,From,To).


rule(garp_correspondence(P,Q1,Q2), true, correspondence(P,Q1,Q2)) :-
    correspondence(P,Q1,Q2).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Helpers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
polarity(1).
polarity(-1).

zero_landmark(V,zero) :-
    landmark(V,zero).

zero_landmark(V,none) :-
    landmark(V,none).

% Any source of a direct influence must have a known zero landmark.
needs_zero_landmark(V) :-
    holds_constraint(_, influence(_,V,_)).

:- needs_zero_landmark(V),
   not zero_landmark(V,_).

% Magnitude sign of a variable relative to its zero landmark.
mag_sign(T,V,Sign) :-
    holds_mag(T,V,Mag),
    zero_landmark(V,Z),
    relative_qmag(V,Mag,land(Z),Sign).

% Direction corresponding to a qualitative sign.
sign_dir(pos,  inc).
sign_dir(zero, std).
sign_dir(neg,  dec).

% Direct influence polarity.
influence_expected_dir(1,Sign,Dir) :-
    sign_dir(Sign,Dir).

influence_expected_dir(-1,Sign,OppositeDir) :-
    sign_dir(Sign,Dir),
    qdirNeg(Dir,OppositeDir).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Garp correspondence
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Correpondence
% This assumes Q1 and Q2 use matching qmag terms.
corresponding_qmag(1,Q1,M1,Q2,M2) :- same_qspace_length(Q1,Q2), qmag_rank(Q1,M1,I), qmag_rank(Q2,M2,I).
% Inverse Correspondence
corresponding_qmag(-1,Q1,M1,Q2,M2) :- same_qspace_length(Q1,Q2), qspace_max_rank(Q1,Max), qmag_rank(Q1,M1,I1), qmag_rank(Q2,M2,I2), I2 = Max - I1.

violation(T) :-
    holds_constraint(T, correspondence(P,Q1,Q2)),
    holds_mag(T,Q1,M1),
    holds_mag(T,Q2,M2),
    not corresponding_qmag(P,Q1,M1,Q2,M2).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Directed value correspondences
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

violation(T) :- holds_constraint(T, value_correspondence(Q1,M1,Q2,M2)),
   holds_mag(T,Q1,M1),
   not holds_mag(T,Q2,M2).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Garp proportionalities
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

violation(T) :- holds_constraint(T, proportionality(1,From,To)),
   holds_dir(T,From,DFrom),
   holds_dir(T,To,DTo),
   DFrom != DTo.
violation(T) :- holds_constraint(T, proportionality(-1,From,To)),
   holds_dir(T,From,DFrom),
   holds_dir(T,To,DTo),
   not qdirNeg(DFrom,DTo).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Garp direct influences
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

influenced_target(T,To) :-
    holds_constraint(T,influence(_,_,To)).

net_influence_saturated(T,To) :-
    holds_dir(T,To,std),
    net_influence_dir(T,To,ExpectedDir),
    ExpectedDir != std,
    influence_saturated(T,To,ExpectedDir).

violation(T) :-
    influenced_target(T,To),
    holds_dir(T,To,ActualDir),
    not net_influence_dir(T,To,ActualDir),
    not net_influence_saturated(T,To).

% Positive influence is saturated at the upper terminal landmark.
influence_saturated(T,V,inc) :-
    last_landmark(V,L),
    holds(T,V,land(L),std).

% Negative influence is saturated at the lower terminal landmark.
influence_saturated(T,V,dec) :-
    first_landmark(V,L),
    holds(T,V,land(L),std).



% Violations projections:
violation :- violation(T).
sviolation(S) :- violation(p((S,_))).
sviolation(S) :- violation(i((S,_),(S,_))).
