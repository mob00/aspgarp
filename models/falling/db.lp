%
% Falling object with air resistance
%
% Translation of the qualitative model in Figure 18 of:
% Kragten & Bredeweg (2024), "Qualitative and quantitative modelling of
% dynamic systems: how do they relate?" 
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Quantities
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

qvar(gravitational_force).
qvar(air_resistance).
qvar(net_force).
qvar(acceleration).
qvar(velocity).
qvar(distance).

observable(V) :- qvar(V).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Quantity spaces
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Every quantity in the source model has the quantity space {zero, plus}.

landmark(V,zero) :- qvar(V).
landmark(V,inf) :- qvar(V).
adjacent_landmark(V,zero,inf) :- qvar(V).
