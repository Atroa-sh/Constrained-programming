include "globals.mzn";  


int: N;
set of int: numbers=1..N;
set of int: variables=1..N^2;

array[numbers,numbers] of var variables: square;

var int: suma;
constraint alldifferent(square);
constraint forall(i in 1..N)(sum(row(square,i))==suma);
constraint forall(i in 1..N)(sum(col(square,i))==suma);
constraint sum([square[i,i]| i in numbers])==suma;
constraint sum([square[i,N-i+1]| i in numbers])==suma;

constraint lex_lesseq(col(square,1),reverse(col(square,1)));

solve satisfy;

output [ show(row(square,i)) ++ "\n" | i in 1..N];