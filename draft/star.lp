timepoint(0).

entity(stars).
entity(core).
entity(surface).
entity(surface,stars).
entity(core,stars).

% STAR
quantity(stars,mass).
quantityspace(mass, 0,  "red dwarfs").
quantityspace(mass, 1, "0.5Msun").
quantityspace(mass, 2, "suns").
quantityspace(mass, 3, "2Msun").
quantityspace(mass, 4, "heavy stars").

quantity(stars,gravity).
quantityspace(gravity, 1, "?").


quantity(stars,lifespan).
quantityspace(lifespan, 0, "<10^9 yeas").
quantityspace(lifespan, 1, "10^9 years").
quantityspace(lifespan, 2, "~10^10 years").
quantityspace(lifespan, 3, "10^11 years").
quantityspace(lifespan, 4, ">10^11 years").

quantity(stars,radius).
quantityspace(radius, 0, "<0.6Rsun").
quantityspace(radius, 1, "0.6Rsun").
quantityspace(radius, 2, "~1Rsun").
quantityspace(radius, 3, "1.75Rsun").
quantityspace(radius, 4, ">1.75Rsun").

quantity(stars,gas_pressure).
quantityspace(gas_pressure, 0, "?").

% CORE
quantity(core,pressure).
quantityspace(pressure, 1, "?").
quantity(core,core_temp).
quantityspace(core_temp, 1, "?").
quantity(core,fusion_e).
quantityspace(fusion_e, 1, "?").

% SURFACE
quantity(surface,surface_temp).
quantityspace(surface_temp, 0, "<4000K").
quantityspace(surface_temp, 1, "4000K").
quantityspace(surface_temp, 2, "~5800K").
quantityspace(surface_temp, 3, "8000K").
quantityspace(surface_temp, 4, ">8000K").

quantity(surface,luminosity).
quantityspace(luminosity, 0, "<0.1Lsun").
quantityspace(luminosity, 1, "0.1Lsun").
quantityspace(luminosity, 2, "~1Lsun").
quantityspace(luminosity, 3, "10Lsun").
quantityspace(luminosity, 4, ">10Lsun").


quantity(surface,peak_c).
quantityspace(peak_c, 0, "ultraviolet").
quantityspace(peak_c, 1, "blue").
quantityspace(peak_c, 2, "green").
quantityspace(peak_c, 3, "red").
quantityspace(peak_c, 4, "infra-red").


quantity(surface,peak_wl).

quantityspace(peak_wl, 0, "<360nm").
quantityspace(peak_wl, 1, "360nm").
quantityspace(peak_wl, 2, "~500nm").
quantityspace(peak_wl, 3, "720nm").
quantityspace(peak_wl, 4, ">720nm").

% Causal Dependencies

rule(proportionality(1, mass, gravity)).
proportionality(1, mass, gravity) :- not ignore(proportionality(1, mass, gravity)).

rule(proportionality(1, gravity, pressure)).
proportionality(1, gravity,pressure):- not ignore(proportionality(1, gravity, pressure)).

rule(proportionality(1, pressure, core_temp)).
proportionality(1,pressure,core_temp):- not ignore(proportionality(1, pressure, core_temp)).

rule(proportionality(1, core_temp, fusion_e)).
proportionality(1,core_temp, fusion_e):- not ignore(proportionality(1, core_temp, fusion_e)).

rule(proportionality(-1, fusion_e, lifespan)).
proportionality(-1,fusion_e,lifespan):- not ignore(proportionality(-1, fusion_e, lifespan)).

rule(proportionality(1, gas_pressure, radius)).
proportionality(1,gas_pressure,radius):- not ignore(proportionality(1, gas_pressure, radius)).

rule(proportionality(1,fusion_e,gas_pressure)).
proportionality(1,fusion_e,gas_pressure) :- not ignore(proportionality(1,fusion_e,gas_pressure)).

rule(proportionality(1,fusion_e,surface_temp)).
proportionality(1,fusion_e,surface_temp) :- not ignore(proportionality(1,fusion_e,surface_temp)).

rule(proportionality(1,surface_temp,peak_wl)).
proportionality(-1,surface_temp,peak_wl) :- not ignore(proportionality(-1,surface_temp,peak_wl)).

rule(proportionality(1,surface_temp,luminosity)).
proportionality(1,surface_temp,luminosity) :- not ignore(proportionality(1,surface_temp,luminosity)).

rule(proportionality(1,peak_wl,peak_c)).
proportionality(1,peak_wl,peak_c) :- not ignore(proportionality(1,peak_wl,peak_c)).

rule(correspondence_inverse(mass, lifespan)).
correspondence_inverse(mass, lifespan) :- not ignore(correspondence_inverse(mass, lifespan)).

rule(correspondence(mass, surface_temp)).
correspondence(mass, surface_temp) :- not ignore(correspondence(mass, surface_temp)).

rule(correspondence(radius, surface_temp)).
correspondence(radius, surface_temp) :- not ignore(correspondence(radius, surface_temp)).

rule(correspondence(surface_temp, luminosity)).
correspondence(surface_temp, luminosity) :- not ignore(correspondence(surface_temp, luminosity)).

rule(correspondence_inverse(surface_temp, peak_wl)).
correspondence_inverse(surface_temp, peak_wl) :- not ignore(correspondence_inverse(surface_temp, peak_wl)).

rule(correspondence(peak_wl, peak_c)).
correspondence(peak_wl, peak_c) :- not ignore(correspondence(peak_wl, peak_c)).




% Optional fdp Formatting
% -------------------
position(stars, 35,80).
position(mass, 14,70).
position(gravity, 33,61).
position(pressure, 52,61).
position(core_temp,68,55).
position(fusion_e,91,62).
position(core,64,70).
position(surface,96,74).
position(lifespan, 24, 42).
position(radius, 49, 36).
position(gas_pressure, 79, 40).
position(surface_temp, 99, 40).
position(peak_wl, 114, 65).
position(peak_c, 136, 65).    
position(luminosity, 127, 40).


% State
% -------------------

% value(mass, 0, 0).
% delta(mass, 0, 1).

% observation(mass,4,4).








