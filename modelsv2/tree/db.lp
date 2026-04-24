% Quantities

qvar(size).
qvar(shade).
qvar(growth).

landmark(size,small).
landmark(size,medium).
landmark(size,large).

landmark(shade,small).
landmark(shade,medium).
landmark(shade,large).

landmark(growth,zero).
landmark(growth,inf).

adjacent_landmark(size,small,medium).
adjacent_landmark(size,medium,large).
adjacent_landmark(shade,small,medium).
adjacent_landmark(shade,medium,large).
adjacent_landmark(growth,zero,inf).

% Conversion
#show holds/3.



