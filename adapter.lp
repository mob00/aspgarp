timepoint(0). % from
timepoint(1). % to

from_state :- not to_state.
to_state :- not from_state.

obs(holds(VAR,LANDMARK,DIRECTION)) :- holds(0,VAR,LANDMARK,DIRECTION), from_state.
obs(holds(VAR,LANDMARK,DIRECTION)) :- holds(1,VAR,LANDMARK,DIRECTION), to_state.

active(T) :- from_state, timepoint(T), T = 0.
active(T) :- to_state, timepoint(T), T = 1.

holds(STATE,VAR,LANDMARK,DIRECTION) :- value(VAR,STATE,MAG), delta(VAR,STATE,DIR), quantityspace(VAR,MAG,LANDMARK), quantityspace(delta,DIR,DIRECTION).  


