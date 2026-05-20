%
% Tree and Shade test model for Garp-style constraints over ASPQSIM
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Quantities
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

qvar(size).
qvar(shade).
qvar(growth).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Quantity spaces
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

landmark(size, small).
landmark(size, large).

adjacent_landmark(size, small, large).

landmark(shade, small).
landmark(shade, large).

adjacent_landmark(shade, small, large).

landmark(growth, zero).
landmark(growth, inf).

adjacent_landmark(growth, zero, inf).