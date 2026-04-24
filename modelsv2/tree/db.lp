%
% Tree and Shade test model for Garp-style constraints over ASPQSIM
%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Quantities
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

qvar(size).
qvar(shade).
qvar(growth).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Quantity spaces
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% size and shade:
%
%   small  -> land(small) or interval(small,medium)
%   medium -> land(medium) or interval(medium,large)
%   large  -> land(large)
%
% growth:
%
%   none     -> land(zero)
%   positive -> interval(zero,inf)
%

landmark(size, small).
landmark(size, medium).
landmark(size, large).

adjacent_landmark(size, small, medium).
adjacent_landmark(size, medium, large).


landmark(shade, small).
landmark(shade, medium).
landmark(shade, large).

adjacent_landmark(shade, small, medium).
adjacent_landmark(shade, medium, large).


landmark(growth, zero).
landmark(growth, inf).

adjacent_landmark(growth, zero, inf).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Garp causal structure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Terminal value correspondence for this toy model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This is model-specific.
%
% Without this, the causal structure also allows static equilibria such as:
%   size small, growth none, neutral
% because I+(growth,size) says growth none -> size std.
%
% This correspondence says:
%   growth none iff size large.
%
% That is what gives the textbook three-state behaviour.
%

:- time(T),
   holds_mag(T, growth, land(zero)),
   not holds_mag(T, size, land(large)).

:- time(T),
   holds_mag(T, size, land(large)),
   not holds_mag(T, growth, land(zero)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initial scenario
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Start with a small tree, small shade, and positive-but-decreasing growth.
%
% To test another transition, replace these init/3 facts with the state you
% want as the new origin.
%

% time(p(from)).

% init(size,   land(small),         inc).
% init(shade,  land(small),         inc).
% init(growth, interval(zero,inf),  dec).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Display helpers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dir_label(inc, increase).
dir_label(std, neutral).
dir_label(dec, decrease).

% Collapse QSIM magnitudes back to Garp-like labels.
mag_label(size,  land(small),              small).
mag_label(size,  interval(small,medium),   small).
mag_label(size,  land(medium),             medium).
mag_label(size,  interval(medium,large),   medium).
mag_label(size,  land(large),              large).

mag_label(shade, land(small),              small).
mag_label(shade, interval(small,medium),   small).
mag_label(shade, land(medium),             medium).
mag_label(shade, interval(medium,large),   medium).
mag_label(shade, land(large),              large).

mag_label(growth, land(zero),              none).
mag_label(growth, interval(zero,inf),      positive).

display_state(T,Q,Label,DirLabel) :-
    time(T),
    holds(T,Q,Mag,Dir),
    mag_label(Q,Mag,Label),
    dir_label(Dir,DirLabel).

% #show display_state/4.

% #show holds/4.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% State well-formedness
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

% In QSIM, a non-discrete variable cannot remain at a landmark during
% an interval while changing. If it is exactly at a landmark for an
% interval, its direction must be std.
:- time(i(T,T1)),
   not discrete(V),
   holds(i(T,T1),V,land(_),D),
   D != std.

% No states may hold at inactive point times.
:- holds(p(T),_,_,_),
   not time(p(T)).