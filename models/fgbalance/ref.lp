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
