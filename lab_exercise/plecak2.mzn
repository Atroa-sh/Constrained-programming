%Parametry
%n = 6;
%weights = [3,1,2,5,3,7];
%values = [5,4,3,5,10,12];
%capa = 15;

set of int: ind = 1..n;
int: n= 6;
array[ind] of int: weights= [3,1,2,5,3,7];
array[ind] of int: values= [5,4,3,5,10,12];
int: capa= 15;
%Zmienne 
array[ind] of var 0..1: artifacts;

%constrainty
constraint trace("dupa",index_set(weights)== index_set(values)); %dzieki temu blad w tablicy nie wywali programu
%constraint assert(index_set(weights)== index_set(values), "dupa");
constraint sum([artifacts[i]*weights[i] |  i in ind])<=capa;
var int: i = if(weights[1]>1) then 1 else 2 endif;

var int: objective= sum([artifacts[i]*values[i] | i in ind]);
solve maximize objective;

output ["\(artifacts) ++ \(objective)"];