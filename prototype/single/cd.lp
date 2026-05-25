%
% Garp-style QDE Integrity constraints on top of ASPQSIM transitions
%
% This file intentionally uses ASPQSIM's state generation / transition rules,
% but replaces the original QSIM QDE constraint vocabulary with Garp-style:
%
%   correspondence(1,Q1,Q2)
%   correspondence(-1,Q1,Q2)
%   proportionality( 1, From, To)
%   proportionality(-1, From, To)
%   influence( 1, From, To)
%   influence(-1, From, To)
%
% Important:
%   - proportionality constrains directions only
%   - correspondence constrains magnitudes only
%   - influence uses source magnitude relative to zero to constrain target direction
%

#program base.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rule activation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Original ASPQSIM style:
%   rule(Name, Precondition, Constraint).
holds_constraint(T,N,C) :-
    rule(N,P,C),
    holds_precond(T,P),
    time(T).

holds_constraint(T,C) :-
    holds_constraint(T,_,C).

relation(T,A,B,R) :-
    qcn_relation(T,A,B,R).

relation(T,B,A,RI) :-
    qcn_relation(T,A,B,R),
    converse(point,R,RI).

influence_dir(T,From,To,Dir) :-
    holds_constraint(T,influence(P,From,To)),
    mag_sign(T,From,Sign),
    influence_expected_dir(P,Sign,Dir).

suspended_constraint(T,influence(P,From,To)) :-
    holds_constraint(T,influence(P,From,To)),
    influence_dir(T,From,To,Dir),
    influence_dir(T,Other,To,OtherDir),
    From != Other,
    Dir != OtherDir,
    relation(T,qvar(From),qvar(Other),lt).

equal_influence_balance(T,To) :-
    holds_constraint(T,influence(P,From,To)),
    holds_constraint(T,influence(-P,Other,To)),
    Other != From,
    relation(T,qvar(From),qvar(Other),eq).

suspended_constraint(T,influence(P,From,To)) :-
    equal_influence_balance(T,To),
    holds_constraint(T,influence(P,From,To)).

% Convenience: allow unconditional Garp facts directly.
%
% Example:
%   influence(1,growth,size).
%   proportionality(-1,size,growth).
%   correspondence(1,size,shade).
%
% These are automatically treated as unconditional rules.
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

% Accept either "zero" or "none" as the zero landmark.
% Prefer writing landmark(Q,zero), but this makes Garp-style "none" usable too.
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
%
% Produces:
%   mag_sign(T,V,pos)
%   mag_sign(T,V,zero)
%   mag_sign(T,V,neg)
mag_sign(T,V,Sign) :-
    holds_mag(T,V,Mag),
    zero_landmark(V,Z),
    relative_qmag(V,Mag,land(Z),Sign).

% Direction corresponding to a qualitative sign.
sign_dir(pos,  inc).
sign_dir(zero, std).
sign_dir(neg,  dec).

% Direct influence polarity.
%
% I+(From,To):
%   From > 0  -> To inc
%   From = 0  -> To std
%   From < 0  -> To dec
%
% I-(From,To):
%   From > 0  -> To dec
%   From = 0  -> To std
%   From < 0  -> To inc
influence_expected_dir(1,Sign,Dir) :-
    sign_dir(Sign,Dir).

influence_expected_dir(-1,Sign,OppositeDir) :-
    sign_dir(Sign,Dir),
    qdirNeg(Dir,OppositeDir).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Garp correspondence
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% correspondence(1,Q1,Q2)
%
% Corresponding quantities must have the same qualitative magnitude.
%
% This assumes Q1 and Q2 use matching qmag terms.
% For more complex Garp3 models with differently named quantity spaces,
% later add an explicit correspondence map instead of direct equality.

% Correpondence
corresponding_qmag(1,Q1,M1,Q2,M2) :- same_qspace_length(Q1,Q2), qmag_rank(Q1,M1,I), qmag_rank(Q2,M2,I).
% Inverse Correspondence
corresponding_qmag(-1,Q1,M1,Q2,M2) :- same_qspace_length(Q1,Q2), qspace_max_rank(Q1,Max), qmag_rank(Q1,M1,I1), qmag_rank(Q2,M2,I2), I2 = Max - I1.

violation :-
    holds_constraint(T, correspondence(P,Q1,Q2)),
    holds_mag(T,Q1,M1),
    holds_mag(T,Q2,M2),
    not corresponding_qmag(P,Q1,M1,Q2,M2).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Directed value correspondences
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% value_correspondence(Q1,Q2,M1,M2)
%
% Means:
%
%   if Q1 has M1, then Q2 has M2
%
% but not necessarily the other way around.
%


violation :- holds_constraint(T, value_correspondence(Q1,M1,Q2,M2)),
   holds_mag(T,Q1,M1),
   not holds_mag(T,Q2,M2).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Garp proportionalities
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% proportionality(1, From, To)
%
% P+(From,To):
%   To's direction equals From's direction.
%
% Crucially: this does NOT copy magnitude.
violation :- holds_constraint(T, proportionality(1,From,To)),
   holds_dir(T,From,DFrom),
   holds_dir(T,To,DTo),
   DFrom != DTo.

% proportionality(-1, From, To)
%
% P-(From,To):
%   To's direction is the opposite of From's direction.
violation :- holds_constraint(T, proportionality(-1,From,To)),
   holds_dir(T,From,DFrom),
   holds_dir(T,To,DTo),
   not qdirNeg(DFrom,DTo).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Garp direct influences
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% influence(Polarity, From, To)
%
% Direct influence uses the source MAGNITUDE, not the source direction.
%
% Example:
%   influence(1,growth,size)
%
% means:
%   growth positive -> size inc
%   growth zero     -> size std
%   growth negative -> size dec
%
% This version assumes one unopposed active influence per target.
% Later, for full Garp3, replace this with contribution summation / ambiguity
% handling when multiple influences affect the same target.

violation :- holds_constraint(T, influence(P,From,To)),
   not suspended_constraint(T,influence(P,From,To)),
   mag_sign(T,From,Sign),
   influence_expected_dir(P,Sign,ExpectedDir),
   holds_dir(T,To,ActualDir),
   ExpectedDir != ActualDir,
   not influence_saturated(T,To,ExpectedDir).

violation :-
    equal_influence_balance(T,To),
    holds_dir(T,To,D),
    D != std.

% Positive influence is saturated at the upper terminal landmark.
influence_saturated(T,V,inc) :-
    last_landmark(V,L),
    holds(T,V,land(L),std).

% Negative influence is saturated at the lower terminal landmark.
influence_saturated(T,V,dec) :-
    first_landmark(V,L),
    holds(T,V,land(L),std).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Garp Point Constraints
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

