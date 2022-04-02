include "diffn.mzn";  
include "cumulative.mzn";

% Parameters
%%%%%%%%%%%
int: n;                      % How many squares do we have?
set of int: SQUARES = 1..n;  % Set of the available squares

% Variables
%%%%%%%%%%%
var n..(sum([i |i in SQUARES])): height;    % height of the container
var n..(sum([i |i in SQUARES])): width;     % width of the conainer
%var n^2..(sum([i |i in SQUARES]))^2: area = height * width; % container's area
array[SQUARES] of var 0..(sum([i |i in SQUARES])-1): x; % squares' coordinates in the container
array[SQUARES] of var 0..(sum([i |i in SQUARES])-1): y; % squares' coordinated in the container
  
% Constraints 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%redundant
constraint width>height;
% Constraint 1: Squares should fit inside the container
constraint forall(i in SQUARES)((x[i]+i)<=width); 
constraint forall(i in SQUARES)((y[i]+i)<=height);  
  
  
% Constraint 2: Squares should not overlap
constraint forall(i in SQUARES, j in SQUARES where i<j)
(x[i]+i<=x[j] \/ x[i]>=x[j] + j \/ y[i] >= y[j] + j \/ y[i] + i <= y[j]);

constraint diffn(x,y,[i |i in SQUARES],[i |i in SQUARES]);



constraint cumulative(x,[i |i in SQUARES],[i |i in SQUARES],height);
constraint cumulative(y,[i |i in SQUARES],[i |i in SQUARES],width);


% Goal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
solve
 :: seq_search([int_search([width,height],input_order,indomain_min,complete),
 int_search([if j mod 2==1 then x[i] else y[i] endif | i in n..1 , j in 1..2],input_order,indomain_min,complete)])

minimize width*height; 
  

% Boring output  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
output [ show(i) ++ " > (" ++ show(x[i]) ++ "," ++ show(y[i]) ++ ")\n" | i in 1..n] ++
  ["area = " ++ show(width) ++ " * " ++ show(height) ++ " = " ++ show(width*height)];
