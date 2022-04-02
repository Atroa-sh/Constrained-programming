include "globals.mzn";  

% PARAMETERS
% N elementowa tablica
int: N=5;        
set of int: range=0..N-1;
% VARIABLES        
array[range] of var range: magic;
  
% Constraints 
constraint sum(magic)==N;
constraint forall(o in range)(count(magic,o)==magic[o]);

solve satisfy;
  
% EXAMPLE OUTPUT  
output [ "magic sequence = ", show(magic),";\n"];