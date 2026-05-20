%
% Communicating Vessels for Garp-style constraints over ASPQSIM
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Quantities
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

qvar(ramount).
qvar(rhight).
qvar(rlevel).
qvar(rpressure).

qvar(lamount).
qvar(lhight).
qvar(llevel).
qvar(lpressure).

qvar(flow).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Quantity spaces
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
landmark(ramount, zero).
landmark(ramount, max).
adjacent_landmark(ramount, zero, max).

landmark(rhight, point).

landmark(rlevel, zero).
landmark(rlevel, max).
adjacent_landmark(rlevel, zero, max).

landmark(rpressure, zero).
landmark(rpressure, max).
adjacent_landmark(rpressure, zero, max).

landmark(lamount, zero).
landmark(lamount, max).
adjacent_landmark(lamount, zero, max).

landmark(lhight, point).

landmark(llevel, zero).
landmark(llevel, max).
adjacent_landmark(llevel, zero, max).

landmark(lpressure, zero).
landmark(lpressure, max).
adjacent_landmark(lpressure, zero, max).

landmark(flow, minf).
landmark(flow, zero).
landmark(flow, inf).
adjacent_landmark(flow, minf, zero).
adjacent_landmark(flow, zero, inf).

