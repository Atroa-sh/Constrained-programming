include "alldifferent.mzn";
include "globals.mzn";
%%include "globals_counting.mzn";

 

int: N = 16;
set of int: indexes = 1..N;
array[indexes,indexes] of var 0..1: chess;

constraint forall(i in indexes)(exactly(1,row(chess,i),true));
constraint forall(i in indexes)(exactly(1,col(chess,i),true));

%%constraint forall(x in indexes)(exactly(1,[chess[i,j]| i in 1..(N-x+1), j in x..N],true));
%%constraint forall(x in indexes)(exactly(1,[chess[i,j]| i in x..N, j in 1..(N-x+1)],true));
%%constraint forall(x in indexes)(exactly(1,[chess[i,j]| i in reverse(x..N), j in x..N],true));
%%constraint forall(x in indexes)(exactly(1,[chess[i,j]| i in reverse(1..(N-x+1)), j in 1..(N-x+1)],true));
constraint forall(x in indexes)(at_most(1,[chess[i,x+i-1]| i in 1..(N-x+1)],true));
constraint forall(x in indexes)(at_most(1,[chess[x+i-1,i]| i in 1..(N-x+1)],true));
constraint forall(x in indexes)(at_most(1,[chess[N+2-x-i,i]| i in 1..(N-x+1)],true));
constraint forall(x in indexes)(at_most(1,[chess[N-i+1,i+x-1]| i in 1..(N-x+1)],true));





solve satisfy;

output [if fix(chess[i,j])==true then "|Q" else "|_" endif ++ if j==N then "\n" else "" endif | i,j in 1..N]

