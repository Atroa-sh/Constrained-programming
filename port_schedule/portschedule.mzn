include "cumulative.mzn";
include "diffn.mzn";  

int: nr; % number of reclaimers
           % number of rails = nr for stages A,B,C,D,E
           % number of rails = (nr + 1) div 2 for stage F
set of int: RECLAIMER = 1..nr;
bool: stageF; % is this stage F data

int: ns; % number of stockpiles
set of int: STOCKPILE = 1..ns;
array[STOCKPILE] of int: size; % size in 10000 tonnes
array[STOCKPILE] of SHIP: ship; % which ship carries stockpile
 
int: maxtime; % time considered
set of int: TIME = 0..maxtime;

int: nsh; % number of ships
set of int: SHIP = 1..nsh;
array[SHIP] of TIME: arrival; % when ship arrives in port

int: len; % length of pad
set of int: POSITION = 0..len;

int: stack_time;
int: reclaim_time;
int: reclaim_speed;

array[STOCKPILE] of var POSITION: westend;
array[STOCKPILE] of var POSITION: eastend;
array[STOCKPILE] of var TIME: stack;
array[STOCKPILE] of var TIME: endstack;
array[STOCKPILE] of var TIME: reclaim;
array[STOCKPILE] of var TIME: finished;
array[STOCKPILE] of var RECLAIMER: which;


predicate not_overlap(var STOCKPILE: s1, var STOCKPILE: s2) = reclaim[s1]>=finished[s2]
 \/ reclaim[s2]>=finished[s1];

predicate not_overlap_movement(var STOCKPILE: s1, var STOCKPILE: s2) = (reclaim[s1]>=finished[s2] \/ reclaim[s2]>=finished[s1]) /\ abs(westend[s1]-westend[s2])*reclaim_speed<=min(abs(reclaim[s1]-finished[s2]),abs(reclaim[s2]-finished[s1]));
% Go crazy here

% Stage A - Packing Problem
% Two stockpiles can't overlap in "spacetime"

% 1) what's the relation between endstack and stack times
constraint forall(i in STOCKPILE)(stack[i]<endstack[i]);
constraint forall(i in STOCKPILE)(endstack[i]-stack[i]==stack_time*size[i]);

% 2) what's the relation between finished and stack times
constraint forall(i in STOCKPILE)(stack[i]<finished[i]);

% 3) what's the relation between reclaim and endstack times
constraint forall(i in STOCKPILE)(endstack[i]<=reclaim[i]);

% 4) what's the relation between finished and reclam times
constraint forall(i in STOCKPILE)(reclaim[i]<finished[i]);
constraint forall(i in STOCKPILE)(finished[i]-reclaim[i]==reclaim_time*size[i]);

% 5) what's the relation between eastend and westend offsets
constraint forall(i in STOCKPILE)(westend[i]<eastend[i]);
constraint forall(i in STOCKPILE)(eastend[i]-westend[i]==size[i]);




% 6) packing problem
%    a) stockpiles should not overlap in "spacetime", treat them as rectangles

%constraint cumulative(westend,size,[finished[i]-stack[i]|i in STOCKPILE],maxtime);
%constraint cumulative(stack,[finished[i]-stack[i]|i in STOCKPILE],size,len);
constraint diffn(stack,westend,[finished[i]-stack[i]|i in STOCKPILE],size);



%    b) stockpiles can't use more space than there is available
constraint forall(i in STOCKPILE)(eastend[i]<=len);
constraint forall(i in STOCKPILE)(westend[i]>=0);


%    c) we can't go beyond the time limit
constraint forall(i in STOCKPILE)(finished[i]<maxtime);

  

% Stage B 
% Two stockpiles reclaimed by the same reclaimer do not overlap in time
%


%%constraint forall(i in STOCKPILE, j in STOCKPILE where i<j /\ which[i]==which[j])(not_overlap(i,j));
%%included in stage d
% Tip: write your first custom predicate, i.e.
% predicate not_overlap(var STOCKPILE: s1, var STOCKPILE: s2) =
% <something something> ;



% Stage C
% 1) no stockpile can be reclaimed onto a ship before the arrival time of the ship
constraint forall(i in STOCKPILE)(reclaim[i]>=arrival[ship[i]]);



% 2) also no two stockpiles can be reclaimed onto the same ship at the same time. Make sure these reclaims do not overlap in time.
constraint forall(i in STOCKPILE, j in STOCKPILE where i<j /\ ship[i]==ship[j])(not_overlap(i,j));

% TIP: reuse your "not_overlap" predicate



% Stage D
% Add constraints to your model to ensure that if a reclaimer finishes reclaiming a stockpile with westend at x and then has to start reclaiming a stockpile with westend at y there is at least |y − x| ∗ reclaim speed time between these two events.
constraint forall(i in STOCKPILE, j in STOCKPILE where i<j /\ which[i]==which[j])(not_overlap_movement(i,j));
% TIP: just make your "not_overlap" predicate smarter
% TIP: you can introduce local variables in the constraints/predicates
% let {
%  <local variables>
% } in <then something>



% Stage E
% Add a definition of the objective to your model and change the model to minimize this value.
% You may well need to significantly change your search strategy to get good solutions for the objective.

% TIP: definetely change the line below
var int: obj = sum([max([finished[j] | j in STOCKPILE where  ship[j]==i]) - arrival[i] | i in SHIP]);



% Stage F
% Add constraints in your model so that the two reclaimers on rail i numbered 2i − 1 and 2i for i ∈ 1..nr div 2 remain so the western one 2i − 1 is never east of the eastern one 2i. Note they can legitimately be in the same position (this is for simplicity, its not very real). Note that if there are
% an odd number of reclaimers the last reclaimer is on its own rail and has no further constraints.
% TIP: do some "channeling" and model reclaimers' positions explicitely with a new array of variables.

array[RECLAIMER,TIME] of var POSITION: reclaimer_positions;

constraint forall(j in STOCKPILE,i in TIME where i<=finished[j] /\ i>=reclaim[j] /\ stageF=true)
(reclaimer_positions[which[j],i]==westend[j]);

constraint forall(i in RECLAIMER where i mod 2==0,j in TIME where stageF==true /\ reclaimer_positions[i,j]!=0)
(reclaimer_positions[i,j]>=reclaimer_positions[i-1,j]);


%REDUNDANT
constraint forall(i in STOCKPILE)(finished[i]>=reclaim_time*size[i] + stack_time*size[i]);
constraint forall(i in STOCKPILE)(endstack[i]>=stack_time*size[i]);


solve
:: seq_search([
  int_search([reclaim[i] - endstack[i] | i in STOCKPILE], first_fail, indomain_min,complete)
,int_search([obj],first_fail,indomain_min,complete)
])
minimize obj;

% don't change the output
output 
["westend  = ", show(westend), ";\n"] ++
["eastend  = ", show(eastend), ";\n"] ++
["stack    = ", show(stack), ";\n"] ++
["endstack = ", show(endstack), ";\n"] ++
["reclaim  = ", show(reclaim), ";\n"] ++
["finish   = ", show(finished) , ";\n"] ++
["which    = ", show(which), ";\n"] ++
["obj = ",show(obj), ";\n"]
;
