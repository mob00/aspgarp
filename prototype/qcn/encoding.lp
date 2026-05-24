% CONSTRUCT QCN FROM TYPED QUANTITIES
qcn_edge(FROM,TO) :- qvar(FROM,ID1), qvar(TO,ID2), ID1 < ID2.

% CONSTRAINS ON QCN RELATIONS
qcn_constraint(T, Var1, Var2, Rel) :- holds_constraint(T, algebraic(Var1, Rel, Var2)), qvar_id(Var1, ID1), qvar_id(Var2, ID2), ID1 <= ID2.
qcn_constraint(T, Var2, Var1, RelInv) :- holds_constraint(T, algebraic(Var1, Rel, Var2)), qvar_id(Var1, ID1), qvar_id(Var2, ID2), ID1 > ID2, converse(point, Rel, RelInv).

% LABEL BASE RELATIONS
1 {qcn_relation(T,FROM,TO,RELATION): baserelation(point,RELATION)} 1:- qcn_edge(FROM,TO), time(T).

% ALGEBRAIC CLOSURE
:- qcn_relation(T,FROM,OVER,R1), qcn_relation(T,OVER,TO,R2), qcn_relation(T,FROM,TO,R3), not composition(point,R1,R2,R3), time(T), qcn_edge(FROM,TO).

% STATIC CONSTRAINTS
:- qcn_relation(T,FROM,TO,REL), not qcn_constraint(T,FROM,TO,REL), qcn_constraint(T,FROM,TO,OTHER).