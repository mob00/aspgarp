entity(protoplanetary_disk).
entity(star).
entity(nebula).

% STAR
quantity(nebula, nebula_mass).
quantityspace(nebula_mass, 0, none).
quantityspace(nebula_mass, 1, positive).

quantity(nebula, accretion).
quantityspace(accretion, 0, none).
quantityspace(accretion, 1, positive).

quantity(protoplanetary_disk, disk_mass).
quantityspace(disk_mass, 0, none).
quantityspace(disk_mass, 1, positive).

quantity(star, star_mass).
quantityspace(star_mass, 0, none).
quantityspace(star_mass, 1, positive).

quantity(star, gravity).
quantityspace(gravity, 0, none).
quantityspace(gravity, 1, positive).

quantity(star, density).
quantityspace(density, 0, none).
quantityspace(density, 1, positive).

quantity(star, fusion).
quantityspace(fusion, 0, none).
quantityspace(fusion, 1, positive).



