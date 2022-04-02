% Use this editor as a MiniZinc scratch book
%include "alldifferend.mzn";

var 1..9: O;
var 0..9: N;
var 0..9: E;
var 1..9: T;
var 0..9: W;

constraint alldifferend([O,N,E,T,W]);

function var int: number(array[int] of var int: dig)=
let {int: max_i = max(index_set(dig))} in sum(i in index_set(dig)) (pow(10,max_i - i) * dig[i]);

constraint number([O,N,E]) + number([O,N,E]) = number([T,W,O]);

solve minimize sum([O,N,E,T,W]);

