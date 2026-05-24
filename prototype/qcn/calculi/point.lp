% POINT CALCULUS
baserelation(point, (eq;lt;gt)).
composition(point, lt, lt, lt). 
composition(point, lt, eq, lt). 
composition(point, lt, gt, lt). 
composition(point, lt, gt, eq). 
composition(point, lt, gt, gt).
composition(point, eq, lt, lt). 
composition(point, eq, eq, eq). 
composition(point, eq, gt, gt).
composition(point, gt, lt, lt). 
composition(point, gt, lt, eq). 
composition(point, gt, lt, gt). 
composition(point, gt, eq, gt). 
composition(point, gt, gt, gt).
converse(point, eq, eq).
converse(point, lt, gt).
converse(point, gt, lt).
cnhs(point,eq,lt). cnhs(point,eq,gt). cnhs(point,lt,eq). cnhs(point,gt,eq).
