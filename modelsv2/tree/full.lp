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
%
% size and shade:
%
%   small  -> land(small) or interval(small,medium)
%   medium -> land(medium) or interval(medium,large)
%   large  -> land(large)
%
% growth:
%
%   none     -> land(zero)
%   positive -> interval(zero,inf)
%

landmark(size, small).
landmark(size, medium).
landmark(size, large).

adjacent_landmark(size, small, medium).
adjacent_landmark(size, medium, large).


landmark(shade, small).
landmark(shade, medium).
landmark(shade, large).

adjacent_landmark(shade, small, medium).
adjacent_landmark(shade, medium, large).


landmark(growth, zero).
landmark(growth, inf).

adjacent_landmark(growth, zero, inf).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reference
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % More growth causes tree size to increase.
influence(1, growth, size).

% Larger/increasing size gives more shade.
proportionality(1, size, shade).

% Size and shade have matching qualitative magnitudes.
correspondence(size, shade).

% Increasing size reduces growth.
proportionality(-1, size, growth).


