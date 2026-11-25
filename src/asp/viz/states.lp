% States
node(A) :- statelabel(A, _).

attr(node, A, label, LABEL)  :- statelabel(A, LABEL).
attr(node, A, xlabel, A)     :- statelabel(A, _).
attr(node, A, shape, box) :- statelabel(A, _).

attr(edge, (A,B), dir, forward) :- edge((A,B)).

attr(graph, default, forcelabels, true).