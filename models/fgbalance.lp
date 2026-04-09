entity(protoplanetary_disk).
entity(star).
entity(nebula).


% STAR
quantity(nebula, nebula_mass).
quantityspace(nebula_mass, 0, "none").
quantityspace(nebula_mass, 1, "positive").

quantity(nebula, accretion).
quantityspace(accretion, 0, "none").
quantityspace(accretion, 1, "positive").

quantity(protoplanetary_disk, disk_mass).
quantityspace(disk_mass, 0, "none").
quantityspace(disk_mass, 1, "positive").

quantity(star, star_mass).
quantityspace(star_mass, 0, "none").
quantityspace(star_mass, 1, "positive").

quantity(star, gravity).
quantityspace(gravity, 0, "none").
quantityspace(gravity, 1, "positive").

quantity(star, density).
quantityspace(density, 0, "none").
quantityspace(density, 1, "positive").

quantity(star, fusion).
quantityspace(fusion, 0, "none").
quantityspace(fusion, 1, "positive").


% Causal Dependencies

influence(-1, accretion, nebula_mass).
proportionality(1,nebula_mass,accretion).

influence(1, accretion, disk_mass).
influence(1, accretion, star_mass).
proportionality(1,star_mass,gravity).
influence(1, gravity, density).
proportionality(1,density,fusion).
influence(-1, fusion, density).

correspondence(nebula_mass,accretion).
correspondence(star_mass,gravity).

% Optional fdp Formatting
% -------------------

position(protoplanetary_disk,38,65).
position(star,87,53).
position(nebula,20,43).
position(disk_mass,40,56).

position(nebula_mass,13,29).
position(accretion,36,29).
position(star_mass,60,29).
position(gravity,79,29).
position(density,100,29).
position(fusion,124,29).


timepoint(0).
% timepoint(1).
% timepoint(2).
% timepoint(3).
% timepoint(4).   

% State
% -------------------
% value(nebula_mass,0,1).
% delta(nebula_mass,0,-1).

% value(accretion,0,1).
% delta(accretion,0,-1).

% value(disk_mass,0,0).
% delta(disk_mass,0,1).

% value(star_mass,0,0).
% delta(star_mass,0,1).

% value(gravity,0,0).
% delta(gravity,0,1).

% delta(density,0,0).

% value(fusion,0,0).
% delta(fusion,0,0).


