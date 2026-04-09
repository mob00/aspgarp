% Quantities
entity(tree).

quantity(tree,size).
quantity(tree,shade).
quantity(tree,growth).

% Quantity space
quantityspace(size,   0, small).
quantityspace(size,   1, medium).
quantityspace(size,   2, large).

quantityspace(shade,  0, small).
quantityspace(shade,  1, medium).
quantityspace(shade,  2, large).

% Quantity space
quantityspace(growth,   0, none).
quantityspace(growth,   1, positive).



