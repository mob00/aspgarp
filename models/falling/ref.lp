%
% Falling object with air resistance
%
% Source: Kragten & Bredeweg (2024), Figure 18, pp. 20-21.
%

precond(all,true).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Force balance
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Fnet = Fg - Fair.
rule(force_balance,
     all,
     minus(gravitational_force,air_resistance,net_force)).

% In the source diagram Fg has P+ and Fair has P- to Fnet. Fg is fixed, so
% its zero derivative contributes no change. The changing part of the force
% balance is therefore represented explicitly by P-(Fair,Fnet).
rule(drag_reduces_net_force,
     all,
     proportionality(-1,air_resistance,net_force)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Causal chain
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rule(net_force_changes_acceleration,
     all,
     proportionality(1,net_force,acceleration)).

rule(acceleration_changes_velocity,
     all,
     influence(1,acceleration,velocity)).

rule(velocity_changes_distance,
     all,
     influence(1,velocity,distance)).

rule(velocity_changes_drag,
     all,
     proportionality(1,velocity,air_resistance)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Directed correspondences
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Fnet determines acceleration magnitude.
rule(net_zero_acceleration_zero,
     all,
     value_correspondence(
         net_force,land(zero),
         acceleration,land(zero)
     )).

rule(net_plus_acceleration_plus,
     all,
     value_correspondence(
         net_force,interval(zero,inf),
         acceleration,interval(zero,inf)
     )).

% Velocity determines air-resistance magnitude.
rule(velocity_zero_drag_zero,
     all,
     value_correspondence(
         velocity,land(zero),
         air_resistance,land(zero)
     )).

rule(velocity_plus_drag_plus,
     all,
     value_correspondence(
         velocity,interval(zero,inf),
         air_resistance,interval(zero,inf)
     )).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Constant gravity and source scenario
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

holds(T,gravitational_force,interval(zero,inf),std) :-
    time(T).

% Figure 18 starts with:
%   gravitational_force = plus, stable
%   velocity            = zero
%   distance            = zero
% Acceleration, drag, and net force are derived by the model.
