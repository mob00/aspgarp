%
% ASP implementation of QSIM
% Author: Timothy Wiley, UNSW Australia
%
% Generate Lanmdarks and intervals from the instance specification
% 


%input specification
%qvar/1
%discrete/1
%landmark/2
%adjacent_landmark/3

#program base.

first_landmark(V,Y) :- adjacent_landmark(V,Y,Z), not adjacent_landmark(V,X,Y) : landmark(V,X).
last_landmark(V,Y)  :- adjacent_landmark(V,X,Y), not adjacent_landmark(V,Y,Z) : landmark(V,Z).
%only one landmark case
first_landmark(V,X) :- landmark(V,X), 1 #sum { 1,V,Y : landmark(V,Y) } 1.
last_landmark(V,X)  :- landmark(V,X), 1 #sum { 1,V,Y : landmark(V,Y) } 1.

invalid_landmark(inf;minf).
%there is a problem, inf and minf are not landmarks in the original database, what is correct?
% we also get relative_qmag's for this
qmag(V,land(X))         :- landmark(V,X), not invalid_landmark(X).
qmag(V,interval(X,Y))   :- adjacent_landmark(V,X,Y), not discrete(V).

relative_qmag(V,land(X),land(Y),neg)  :- adjacent_landmark(V,X,Y).
relative_qmag(V,land(X),land(Z),neg)  :- adjacent_landmark(V,X,Y), relative_qmag(V,land(Y),land(Z),neg).
relative_qmag(V,land(X),land(X),zero) :- landmark(V,X), not invalid_landmark(X).
relative_qmag(V,land(Y),land(X),pos)  :- relative_qmag(V,land(X),land(Y),neg).

relative_qmag(V,interval(X,T),land(Y),neg) :- qmag(V,interval(X,T)), relative_qmag(V,land(X),land(Y),neg).
relative_qmag(V,interval(X,T),land(X),pos)  :- qmag(V,interval(X,T)).
relative_qmag(V,interval(X,T),land(Y),pos)  :- qmag(V,interval(X,T)), relative_qmag(V,land(X),land(Y),pos).

relative_qmag(V,interval(X,Y),interval(U,W),neg)  :- qmag(V,interval(X,Y)), qmag(V,interval(U,W)).



%%% ADDED:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Quantity-space mirror
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

land_before(Q,L1,L2) :- adjacent_landmark(Q,L1,L2).
land_before(Q,L1,L3) :- adjacent_landmark(Q,L1,L2), land_before(Q,L2,L3).

land_rank(Q,L,N) :-
    landmark(Q,L),
    not invalid_landmark(L),
    N = #count {
        P : land_before(Q,P,L),
            landmark(Q,P),
            not invalid_landmark(P)
    }.

qmag_rank(Q,land(L),I) :- qmag(Q,land(L)), land_rank(Q,L,N), I = 2 * N.
qmag_rank(Q,interval(L1,L2),I) :- qmag(Q,interval(L1,L2)), land_rank(Q,L1,N), I = 2 * N + 1.

qspace_max_rank(Q,Max) :-
    qvar(Q),
    Max = #max { I : qmag_rank(Q,_,I) }.


same_qspace_length(Q1,Q2) :-
    qspace_max_rank(Q1,Max),
    qspace_max_rank(Q2,Max).
