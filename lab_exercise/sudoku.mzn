include "globals.mzn";  

% PARAMETERS
int: S;
int: N=S^2;
set of int: PuzzleRange=1..S^2;
array[PuzzleRange,PuzzleRange] of int: board;

% VARIABLES
array[PuzzleRange,PuzzleRange] of var PuzzleRange: puzzle;



% Constraints 

constraint forall(i in PuzzleRange,j in PuzzleRange)(if (board[i,j]!=0) then puzzle[i,j]==board[i,j] endif);
constraint forall(i in PuzzleRange)(alldifferent(row(puzzle,i)));
constraint forall(i in PuzzleRange)(alldifferent(col(puzzle,i)));
constraint forall(A in 1..S,B in 1..S)(alldifferent(i in 1..S,j in 1..S)(puzzle[i+(A-1)*S,j+(B-1)*S]));

solve satisfy;

% OUTPUT EXAMPLE  


output [ show(puzzle[i,j]) ++ " " ++
  if j mod S == 0 then " " else "" endif ++ if j == N /\ i != N then
  if i mod S == 0 then "\n\n" else "\n" endif else "" endif
    | i,j in PuzzleRange ] ++ ["\n"];