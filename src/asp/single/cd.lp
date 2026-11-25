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

% Opposite influences from the same source cancel exactly. Each remaining
% nonzero contribution has the absolute magnitude of its source.
direct_contribution(T,From,To,D) :-
    influence_dir(T,From,To,D),
    D != std,
    qdirNeg(D,Opposite),
    not influence_dir(T,From,To,Opposite).

opposing_direct_contributions(T,To) :-
    direct_contribution(T,_,To,inc),
    direct_contribution(T,_,To,dec).

qcn_closure_needed(T) :-
    opposing_direct_contributions(T,_).

% Within each sign, compare absolute magnitudes using known or observed orderings.
% Across zero, a raw ordering gives no comparison of absolute magnitudes.
magnitude_at_least(T,A,B) :-
    mag_sign(T,A,pos), mag_sign(T,B,pos),
    qcn_known_relation(T,qvar(A),qvar(B),(gt;eq)).

magnitude_at_least(T,A,B) :-
    mag_sign(T,A,neg), mag_sign(T,B,neg),
    qcn_known_relation(T,qvar(A),qvar(B),(lt;eq)).

% To test if a direction is possible, consider subsets of its contributors.
% If a subset outnumbers all opposing sources forced to be at least as large
% as one of its members, those contributors can dominate. Equivalently, some
% cut in the magnitude ordering has more weight on that side. All other
% differences between successive magnitudes can be arbitrarily small.
balance_subset(T,To,D,From,one(From)) :-
    opposing_direct_contributions(T,To),
    direct_contribution(T,From,To,D).

balance_subset(T,To,D,From,add(From,Subset)) :-
    balance_subset(T,To,D,Last,Subset),
    direct_contribution(T,From,To,D),
    Last < From.

balance_member(one(From),From) :- balance_subset(_,_,_,_,one(From)).
balance_member(add(From,Rest),From) :- balance_subset(_,_,_,_,add(From,Rest)).
balance_member(add(From,Rest),Source) :-
    balance_subset(_,_,_,_,add(From,Rest)),
    balance_member(Rest,Source).

balance_opponent(T,To,D,Subset,Other) :-
    balance_subset(T,To,D,_,Subset),
    balance_member(Subset,From),
    qdirNeg(D,Opposite),
    direct_contribution(T,Other,To,Opposite),
    magnitude_at_least(T,Other,From).

net_influence_dir(T,To,D) :-
    direct_contribution(T,_,To,D),
    not opposing_direct_contributions(T,To).

net_influence_dir(T,To,D) :-
    balance_subset(T,To,D,_,Subset),
    Contributors = #count { From : balance_member(Subset,From) },
    Opponents = #count { Other : balance_opponent(T,To,D,Subset,Other) },
    Contributors > Opponents.

% A zero balance is possible when both signs are possible, or when neither
% is possible and all admissible magnitudes therefore give exact balance.
net_influence_dir(T,To,std) :-
    net_influence_dir(T,To,inc),
    net_influence_dir(T,To,dec).

net_influence_dir(T,To,std) :-
    influence_dir(T,_,To,_),
    not net_influence_dir(T,To,inc),
    not net_influence_dir(T,To,dec).

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

prop_dir(1,D,D) :- qdir(D).
prop_dir(-1,D,DI) :- qdirNeg(D,DI).

proportionality_target(T,To) :-
    holds_constraint(T,proportionality(_,_,To)).

proportionality_contribution(T,To,D) :-
    holds_constraint(T,proportionality(P,From,To)),
    holds_dir(T,From,DFrom),
    prop_dir(P,DFrom,D),
    D != std.

net_proportionality_dir(T,To,D) :-
    proportionality_contribution(T,To,D).

% Opposing contributions can balance. Their relative strengths are unknown
% because the encoding assigns only qualitative signs to derivatives.
net_proportionality_dir(T,To,std) :-
    proportionality_contribution(T,To,inc),
    proportionality_contribution(T,To,dec).

net_proportionality_dir(T,To,std) :-
    proportionality_target(T,To),
    not proportionality_contribution(T,To,_).

violation(T) :-
    proportionality_target(T,To),
    holds_dir(T,To,D),
    not net_proportionality_dir(T,To,D).

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
