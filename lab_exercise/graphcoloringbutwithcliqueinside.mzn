include "globals.mzn";      

% PARAMETERS

int: minColorsNumber;
set of int: cliquecolors=1..minColorsNumber;
array[cliquecolors] of int: maxClique;
set of int: numofver=1..nodesNumber;
int: nodesNumber;
var int: colorsNumber;
array[numofver,numofver] of int: edges;
% VARIABLES             
array[numofver] of var numofver: nodes;     

% CONSTRAINTS
constraint forall (i in cliquecolors)(nodes[maxClique[i]]==i);
constraint forall (o,i in numofver where edges[o,i]==true /\ o < i)(nodes[i]!=nodes[o]);

colorsNumber = max(nodes);


solve minimize colorsNumber;

% OUTPUT EXAMPLE
output [show(colorsNumber), " colors\n",] ++
       [show(nodes[i]) ++ " " | i in 1..nodesNumber]