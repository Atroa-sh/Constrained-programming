include "alldifferent.mzn";

int: N;
set of int: indexes = 1..N;

array[indexes] of var indexes: rows;

constraint alldifferent(rows);
constraint alldifferent([rows[i] + i | i in indexes]);
constraint alldifferent([rows[i] - i | i in indexes]);
annotation int_search(array[indexes] of var indexes: rows,ann: dom_w_deg,ann: indomain_min,ann: complete);

solve satisfy; 
  
output [ if fix(rows[j]) == i then "|Q" else "|_" endif ++
  if j == N then "\n" else "" endif | i,j in 1..N];

