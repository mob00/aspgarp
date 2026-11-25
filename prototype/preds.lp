%
% ASP implementation of QSIM
% Author: Timothy Wiley, UNSW Australia
%
% Collection of various predicates/facts
%

#program base.

% Qualitative directions
qdir(std).
qdir(inc).
qdir(dec).

% Inverts the qualitative direction
qinvert(pos, neg).
qinvert(zero, zero).
qinvert(neg, pos).

% Qdir is qualitative direction of change with sign Sign
% qdir(Qdir, Sign):
qdir(dec, neg).
qdir(std, zero).
qdir(inc, pos).

% Qualitative direction negations
% qdirNeg(?QDir1, ?QDir2)
qdirNeg(dec, inc).
qdirNeg(std, std).
qdirNeg(inc, dec).

% Laws of qualitative summation
%  qsum(Q1, Q2, Q3):
%    Q3 = Q1 + Q2, qualitative sum over domain [pos,zero,neg]
qsum(pos, pos, pos).
qsum(pos, zero, pos).
qsum(pos, neg, pos).
qsum(pos, neg, zero).
qsum(pos, neg, neg).
qsum(zero, pos, pos).
qsum(zero, zero, zero).
qsum(zero, neg, neg).
qsum(neg, pos, pos).
qsum(neg, pos, zero).
qsum(neg, pos, neg). 
qsum(neg, zero, neg).
qsum(neg, neg, neg).

%  qdirsum(D1, D2, D3):
%    qualitative sum over directions of change
qdirsum(D1, D2, D3)  :-
   qdir(D1, Q1),
   qdir(D2, Q2),
   qdir(D3, Q3),
   qsum(Q1, Q2, Q3).

% Precondition bound checking
precond_bound_lower(e, pos).
precond_bound_lower(i, pos).
precond_bound_lower(i, zero).
precond_bound_upper(e, neg).
precond_bound_upper(i, neg).
precond_bound_upper(i, zero).

