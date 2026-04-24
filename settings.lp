:- violation.
#show obs/1.
% #show holds/4.

% #show state/2.

state(SID,1) :- holds(SID,growth,positive,decrease), holds(SID,shade,small,increase), holds(SID,size,small,increase).
state(SID,2) :- holds(SID,growth,positive,decrease), holds(SID,shade,medium,increase), holds(SID,size,medium,increase).
state(SID,3) :- holds(SID,shade,large,neutral), holds(SID,size,large,neutral), holds(SID,growth,none,neutral).