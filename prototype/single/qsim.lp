%
% ASP implementation of QSIM
% Author: Timothy Wiley, UNSW Australia
%
% QSIM state transition rules
% Preconditions for QDEs
% Initial/Goal states
%
% VERSION FOR SINGLE INSTANCE SOLVING WITH MANUAL ENTERED CONSTANT t
%

% Enable/disable quantiative constraints
%mode_quant.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% State transition rules
% Use the generate-and-test paradigm, by generating all possible states and ruling out states by integrity constraints
% Kuipers, B. J. (1986). Qualitative Simulation. Artificial Intelligence, 29(3), 289–338

% holds(Time, QVar, Mag, Dir)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i'm sure that this can be optimized splitting Dir vom Mag,
% but i would need the general rules to get an overview


%%%
% Point to Interval
%   time(T1) is required to ensure stopping at max time
1 { holds(i(T, T1), QVar, interval(L1, L2), QDir) : qdir(QDir) } 1
    :- qstep(p(T), i(T,T1)),
       time(i(T,T1)),
       not discrete(QVar),
       holds(p(T), QVar, interval(L1, L2), std).
1 {
    holds(i(T, T1), QVar, interval(L1, L2), inc);
    holds(i(T, T1), QVar, interval(L1, L2), std)
} 1
    :- qstep(p(T), i(T,T1)),
       time(i(T,T1)),
       not discrete(QVar),
       holds(p(T), QVar, interval(L1, L2), inc).
1 {
    holds(i(T, T1), QVar, interval(L1, L2), dec);
    holds(i(T, T1), QVar, interval(L1, L2), std)
} 1
    :- qstep(p(T), i(T,T1)),
       time(i(T,T1)),
       not discrete(QVar),
       holds(p(T), QVar, interval(L1, L2), dec).
1 { holds(i(T, T1), QVar, land(L1), QDir) : qdir(QDir);
    holds(i(T, T1), QVar, interval(L1, L2), inc) : qmag(QVar, interval(L1, L2));
    holds(i(T, T1), QVar, interval(L0, L1), dec) : qmag(QVar, interval(L0, L1)) } 1
    :- qstep(p(T), i(T,T1)),
       time(i(T,T1)),
       not discrete(QVar),
       holds(p(T), QVar, land(L1), std).
1 {
    holds(i(T, T1), QVar, interval(L1, L2), inc) :
        qmag(QVar, interval(L1, L2));
    holds(i(T, T1), QVar, interval(L1, L2), std) :
        qmag(QVar, interval(L1, L2))
} 1
    :- qstep(p(T), i(T,T1)),
       time(i(T,T1)),
       not discrete(QVar),
       holds(p(T), QVar, land(L1), inc).
1 {
    holds(i(T, T1), QVar, interval(L0, L1), dec) :
        qmag(QVar, interval(L0, L1));
    holds(i(T, T1), QVar, interval(L0, L1), std) :
        qmag(QVar, interval(L0, L1))
} 1
    :- qstep(p(T), i(T,T1)),
       time(i(T,T1)),
       not discrete(QVar),
       holds(p(T), QVar, land(L1), dec).

% Interval to Point
1 { holds(p(T1), QVar, interval(L1, L2), QDir) : qdir(QDir) } 1
    :- qstep(i(T,T1), p(T1)),
       time(p(T1)),
       not discrete(QVar),
       holds(i(T, T1), QVar, interval(L1, L2), std).

1 { holds(p(T1), QVar, interval(L1, L2), inc);
    holds(p(T1), QVar, interval(L1, L2), std);
    holds(p(T1), QVar, land(L2), inc) : qmag(QVar, land(L2));
    holds(p(T1), QVar, land(L2), std) : qmag(QVar, land(L2)) } 1
    :- qstep(i(T,T1), p(T1)),
       time(p(T1)),
       not discrete(QVar),
       holds(i(T, T1), QVar, interval(L1, L2), inc).

1 { holds(p(T1), QVar, interval(L1, L2), dec);
    holds(p(T1), QVar, interval(L1, L2), std);
    holds(p(T1), QVar, land(L1), dec) : qmag(QVar, land(L1));
    holds(p(T1), QVar, land(L1), std) : qmag(QVar, land(L1)) } 1
    :- qstep(i(T,T1), p(T1)),
       time(p(T1)),
       not discrete(QVar),
       holds(i(T, T1), QVar, interval(L1, L2), dec).

1 { holds(p(T1), QVar, land(L1), QDir) : qdir(QDir) } 1
    :- qstep(i(T,T1), p(T1)),
       time(p(T1)),
       not discrete(QVar),
       holds(i(T, T1), QVar, land(L1), std).

% Discrete versions of state transitions
1 { holds(i(T, T1), QVar, land(L1), std);
    holds(i(T, T1), QVar, land(L0), std) :
        adjacent_landmark(QVar, L0, L1),
        not invalid_landmark(L0);
    holds(i(T, T1), QVar, land(L2), std) :
        adjacent_landmark(QVar, L1, L2),
        not invalid_landmark(L2) } 1
    :- qstep(p(T), i(T,T1)),
       time(i(T,T1)),
       discrete(QVar),
       holds(p(T), QVar, land(L1), std).

1 { holds(p(T1), QVar, land(L1), std);
    holds(p(T1), QVar, land(L0), std) :
        adjacent_landmark(QVar, L0, L1),
        not invalid_landmark(L0);
    holds(p(T1), QVar, land(L2), std) :
        adjacent_landmark(QVar, L1, L2),
        not invalid_landmark(L2) } 1
    :- qstep(i(T,T1), p(T1)),
       time(p(T1)),
       discrete(QVar),
       holds(i(T,T1), QVar, land(L1), std).


% Holds preconds
precond(X,OP) :- precond(X,OP,_).
holds_precond(T,X) :- holds_precond(T,Y) : precond(X,and,Y); precond(X,and), time(T).
holds_precond(T,X) :- holds_precond(T,Y),  precond(X,or,Y).
holds_precond(T,X) :- not holds_precond(T,Y),  precond(X,neg,Y), time(T).

% Split holds mag/dir to speed up solving
holds_mag(T,Var,Mag) :- holds(T,Var,Mag,_).
holds_dir(T,Var,Dir) :- holds(T,Var,_,Dir).

% dir constraint for discrete vars
:- time(T), discrete(QVar), holds_dir(T, QVar, inc).
:- time(T), discrete(QVar), holds_dir(T, QVar, dec).

% Bound helper methods
holds_precond(T,X) :- precond(X, bound, Var, Lower, Min, Upper, Max), time(T),
                      holds_mag(T,Var,Mag),
                      relative_qmag(Var, Mag, land(Min), Sign1),
                      relative_qmag(Var, Mag, land(Max), Sign2),
                      precond_bound_lower(Lower, Sign1),
                      precond_bound_upper(Upper, Sign2).
		 
holds_precond(T,X) :- precond(X, equal, Var, Mag), time(T),
                      holds_mag(T,Var,Mag).

holds_precond(T,X) :- precond(X, less_than, Var, Landmark), time(T),
                      holds_mag(T,Var,Mag),
                      relative_qmag(Var, Mag, land(Landmark), neg).

holds_precond(T,X) :- precond(X, greater_than, Var, Landmark), time(T),
                      holds_mag(T,Var,Mag),
                      relative_qmag(Var, Mag, land(Landmark), pos).

% True/false precondition
% precond(true,neg,false).
holds_precond(T,X) :- precond(X, true), time(T).


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % State well-formedness
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Every active time must assign exactly one magnitude and one direction
% to every variable.
:- time(T),
   qvar(V),
   not holds(T,V,_,_).

:- time(T),
   qvar(V),
   holds(T,V,M1,_),
   holds(T,V,M2,_),
   M1 != M2.

:- time(T),
   qvar(V),
   holds(T,V,_,D1),
   holds(T,V,_,D2),
   D1 != D2.


:- time(T),
    first_landmark(V,L),
    holds(T,V,land(L),dec).

:-  time(T),
    last_landmark(V,L),
    holds(T,V,land(L),inc).
