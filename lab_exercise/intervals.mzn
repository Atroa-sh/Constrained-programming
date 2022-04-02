include "globals.mzn";  

% PARAMETERS
% N elementowa tablica
int: N=6;        
set of int: range=0..N-1;
set of int: diffrence=1..N-1;
% VARIABLES        
array[range] of var range: intervals;
array[diffrence] of var diffrence: diffs;
  
% Constraints 
constraint alldifferent(intervals);
constraint forall(i in diffrence)(diffs[i]==abs(intervals[i-1]-intervals[i]));

solve satisfy;
  
% EXAMPLE OUTPUT  
output [ "intervals = ", show(intervals), ";\n"];