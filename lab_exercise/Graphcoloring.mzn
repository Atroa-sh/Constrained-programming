include "globals.mzn";      

% PARAMETERS
set of int: numofver=1..nodesNumber;
int: nodesNumber;
var int: colorsNumber;
array[numofver,numofver] of int: graph;
% VARIABLES             
array[numofver] of var numofver: nodes;     

% CONSTRAINTS
constraint forall(o in numofver)(
forall(i in numofver)(if (graph[o,i]!=false) then nodes[graph[o,i]]!=nodes[o] endif)
);

%tablica stworzona bym mogl podliczyc ile roznych kolorow uzylem
array[numofver] of var  0..1: temp = [if (has_element(i,nodes)) then 1 else 0 endif|i in numofver];
colorsNumber = sum(temp);


solve minimize colorsNumber;

% OUTPUT EXAMPLE
output [show(colorsNumber), " colors\n",] ++
       [show(nodes[i]) ++ " " | i in 1..nodesNumber]