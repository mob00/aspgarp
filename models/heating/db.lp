%
% Heating & Boiling (Version 1)
%
% Translation of the Garp3 example described in section 4.5 of:
% Bredeweg, Liem, Bouwer & Salles (2006),
% "Curriculum for learning about QR modelling", NaturNet-Redime D6.9.1.
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Quantities
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

qvar(amount_gas).
qvar(amount_liquid).
qvar(flow).
qvar(heat).
qvar(temperature).

observable(V) :- qvar(V).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Quantity spaces
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Amount of gas/liquid: {zero, plus, max}

landmark(amount_gas, zero).
landmark(amount_gas, max).
adjacent_landmark(amount_gas, zero, max).

landmark(amount_liquid, zero).
landmark(amount_liquid, max).
adjacent_landmark(amount_liquid, zero, max).


% Heat flow: {min, zero, plus}

landmark(flow, minf).
landmark(flow, zero).
landmark(flow, inf).

adjacent_landmark(flow, minf, zero).
adjacent_landmark(flow, zero, inf).


% Heat: {zero, plus}

landmark(heat, zero).
landmark(heat, inf).
adjacent_landmark(heat, zero, inf).


% Temperature:
% {absnil, solid phase, freeze melt, liquid phase,
%  condense boil, gas phase}

landmark(temperature, absnil).
landmark(temperature, freeze_melt).
landmark(temperature, condense_boil).
landmark(temperature, inf).

adjacent_landmark(temperature, absnil, freeze_melt).
adjacent_landmark(temperature, freeze_melt, condense_boil).
adjacent_landmark(temperature, condense_boil, inf).
