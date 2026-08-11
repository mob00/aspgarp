%
% Heating & Boiling (Version 1)
%
% Bredeweg, Liem, Bouwer & Salles (2006), "Curriculum for learning
% about QR modelling", NaturNet-Redime D6.9.1, section 4.5.
%
% The Garp3 entity hierarchy, open-container attribute, stove agent, and
% Contains/On-top-of configurations are represented here by their behavioural
% consequences: a steady positive heat flow into a contained substance.
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Preconditions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

precond(all, true).

precond(liquid_present,
        greater_than,
        amount_liquid,
        zero).

precond(at_boiling_point,
        equal,
        temperature,
        land(condense_boil)).

precond(boiling, and).
precond(boiling, and, liquid_present).
precond(boiling, and, at_boiling_point).

precond(not_boiling, neg, boiling).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Substance and phase constraints
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Heat normally determines temperature. During boiling, latent heat changes
% the phase amounts while temperature is held at the boiling point.
rule(heat_temperature,
     not_boiling,
     proportionality(1, heat, temperature)).

% The two phase amounts are complementary:
% liquid=max <-> gas=zero, both plus in a mixture, and vice versa.
rule(conserved_substance,
     all,
     correspondence(-1, amount_liquid, amount_gas)).

positive_amount(T,V) :-
    time(T),
    holds_mag(T,V,M),
    M != land(zero).

% A present substance has positive heat.
:- time(T),
   positive_amount(T,amount_liquid),
   not holds_mag(T,heat,interval(zero,inf)).

:- time(T),
   positive_amount(T,amount_gas),
   not holds_mag(T,heat,interval(zero,inf)).

% Liquid can only occur from the melting point through the boiling point.
:- time(T),
   positive_amount(T,amount_liquid),
   holds_mag(T,temperature,M),
   relative_qmag(temperature,M,land(freeze_melt),neg).

:- time(T),
   positive_amount(T,amount_liquid),
   holds_mag(T,temperature,M),
   relative_qmag(temperature,M,land(condense_boil),pos).

% Gas can only occur at or above the boiling point.
:- time(T),
   positive_amount(T,amount_gas),
   holds_mag(T,temperature,M),
   relative_qmag(temperature,M,land(condense_boil),neg).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Steady heater agent
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rule(steady_heater,
     all,
     influence(1, flow, heat)).

holds(T,flow,interval(zero,inf),std) :-
    time(T).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Boiling process
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rule(evaporation_creates_gas,
     boiling,
     proportionality(1, heat, amount_gas)).

rule(evaporation_removes_liquid,
     boiling,
     proportionality(-1, heat, amount_liquid)).

% The source model also contains amount-to-temperature proportionalities.
% In this strict derivative encoding their resolved effect is represented by
% the explicit stable-temperature consequence below.
holds(T,temperature,land(condense_boil),std) :-
    holds_precond(T,boiling).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Source scenario (documentation)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Boiling water starts with:
%   amount_gas    = land(zero)
%   amount_liquid = land(max)
%   temperature   = interval(freeze_melt,condense_boil)
