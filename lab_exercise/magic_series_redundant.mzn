int: n = 120;
set of int: range = 0..n-1;
array[range] of var range: magic;
  
constraint forall(i in range)(
  magic[i] = sum([bool2int(i == magic[j]) | j in range])
);

constraint sum(magic)==n; 
constraint sum([magic[j]*j | j in range])==n;


% you should put here all your redundant constraints 

solve satisfy;
  
output [ "magiczny ciag = ", show(magic),";\n"];