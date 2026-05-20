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
% Reference Model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
precond(all, true).

rule(r1,all,influence(1, growth, size)).

rule(r2,all,proportionality(1, size, shade)).

rule(r3,all,correspondence(size, shade)).

rule(r4,all,proportionality(-1, size, growth)).

rule(r5,all,value_correspondence(growth, land(zero), size, land(large))).
rule(r6,all,value_correspondence(size, land(large), growth, land(zero))).



% Terminal value correspondence for this toy model

% :- time(T),
%    holds_mag(T, growth, land(zero)),
%    not holds_mag(T, size, land(large)).

% :- time(T),
%    holds_mag(T, size, land(large)),
%    not holds_mag(T, growth, land(zero)).