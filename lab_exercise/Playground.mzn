%Parametry
int: n;
array[1..n] of int: weights;
array[1..n] of int: values;
int: capa;
%Zmienne 
array[1..n] of var 0..1: artifacts;

%constrainty
constraint sum([artifacts[i]*weights[i] |  i in 1..n])<=capa;

var int: objective= sum([artifacts[i]*values[i] | i in 1..n]);
solve maximize objective;

output ["\(artifacts) ++ \(objective)"];
