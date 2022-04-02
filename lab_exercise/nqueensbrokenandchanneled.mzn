%%%%%%%%%%%%%
include "globals.mzn";    
include "lex_lesseq.mzn";
  
int: N=16;               
array[1..N] of var 1..N: rows; %declares a variable with domain 1..N 

set of int: indexes = 1..N;
array[indexes,indexes] of var bool: chess;

% CONSTRAINTS 
constraint alldifferent(rows);
constraint alldifferent(o in 1..N)(rows[o] + o);
constraint alldifferent(o in 1..N)(rows[o]-o);

constraint forall(i in indexes)(exactly(1,row(chess,i),true));
constraint forall(i in indexes)(exactly(1,col(chess,i),true));
constraint forall(x in indexes)(at_most(1,[chess[i,x+i-1]| i in 1..(N-x+1)],true));
constraint forall(x in indexes)(at_most(1,[chess[x+i-1,i]| i in 1..(N-x+1)],true));
constraint forall(x in indexes)(at_most(1,[chess[N+2-x-i,i]| i in 1..(N-x+1)],true));
constraint forall(x in indexes)(at_most(1,[chess[N-i+1,i+x-1]| i in 1..(N-x+1)],true));

constraint forall(x in indexes)(chess[x,rows[x]]==true);

constraint lex_lesseq([chess[i,j] | i,j in indexes],[chess[j,i] | i,j in indexes]);
constraint lex_lesseq([chess[i,j] | i,j in indexes],[ chess[i,j] | i in reverse(indexes), j in indexes ]);
constraint lex_lesseq([chess[i,j] | i,j in indexes],[ chess[j,i] | i in indexes, j in reverse(indexes) ]);
constraint lex_lesseq([chess[i,j] | i,j in indexes],[ chess[i,j] | i in indexes, j in reverse(indexes) ]);
constraint lex_lesseq([chess[i,j] | i,j in indexes],[ chess[j,i] | i in reverse(indexes), j in indexes ]);
constraint lex_lesseq([chess[i,j] | i,j in indexes],[ chess[i,j] | i,j in reverse(indexes) ]);
constraint lex_lesseq([chess[i,j] | i,j in indexes],[ chess[j,i] | i,j in reverse(indexes) ]);




solve satisfy; 
  
%%%%%%%%%%%%%%%%%%%
% OUTPUT EXAMPLE  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
output [ if fix(rows[j]) == i then "|Q" else "|_" endif ++
  if j == N then "\n" else "" endif | i,j in 1..N];
