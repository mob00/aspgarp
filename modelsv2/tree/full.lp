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
% Reference Model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

influence(1, growth, size).

% proportionality(1, size, shade).

% correspondence(size, shade).

% proportionality(-1, size, growth).


% Terminal value correspondence for this toy model

% :- time(T),
%    holds_mag(T, growth, land(zero)),
%    not holds_mag(T, size, land(large)).

% :- time(T),
%    holds_mag(T, size, land(large)),
%    not holds_mag(T, growth, land(zero)).