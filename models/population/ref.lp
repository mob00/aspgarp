% File AI-Generated (GPT-5) from Reference Paper see below:
%
% Population Model 2: Competing Processes
%
% Salles & Bredeweg (2006), "Modelling population and community
% dynamics with qualitative reasoning", Ecological Modelling 195,
% 114-128. DOI: 10.1016/j.ecolmodel.2005.11.014
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reference model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

precond(all, true).


% Population: biomass follows the number of individuals.
rule(population_biomass_direction,
     all,
     proportionality(1, number_of, biomass)).

rule(population_biomass_magnitude,
     all,
     correspondence(1, number_of, biomass)).


% Birth: births add individuals to the population.
rule(birth_process,
     all,
     influence(1, birth, number_of)).


% Death: deaths remove individuals from the population.
rule(death_process,
     all,
     influence(-1, death, number_of)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Process-rate assignments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% In Garp3 model 2 both active process rates are plus and stable. Their
% ordinal relation is deliberately unspecified.

holds(T, birth, interval(zero,inf), std) :- time(T).
holds(T, death, interval(zero,inf), std) :- time(T).

