%
% Population Model 2: Competing Processes
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Quantities
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

qvar(number_of).
qvar(biomass).
qvar(birth).
qvar(death).

observable(V) :- qvar(V).

% % The unresolved balance between the two process rates is part of the
% % qualitative state and is therefore useful in state labels/visualisations.
% observable(relation(birth, death)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Quantity spaces
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Garp3: {zero, small, medium, large}
%
% zero   = land(zero)
% small  = interval(zero,medium)
% medium = land(medium)
% large  = interval(medium,inf)

landmark(number_of, zero).
landmark(number_of, medium).
landmark(number_of, inf).

adjacent_landmark(number_of, zero, medium).
adjacent_landmark(number_of, medium, inf).

landmark(biomass, zero).
landmark(biomass, medium).
landmark(biomass, inf).

adjacent_landmark(biomass, zero, medium).
adjacent_landmark(biomass, medium, inf).


% Garp3: {zero, plus}
%
% zero = land(zero)
% plus = interval(zero,inf)

landmark(birth, zero).
landmark(birth, inf).
adjacent_landmark(birth, zero, inf).

landmark(death, zero).
landmark(death, inf).
adjacent_landmark(death, zero, inf).
