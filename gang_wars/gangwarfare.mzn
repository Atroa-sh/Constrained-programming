include "globals.mzn";

int: n; % number of gangs
set of int: Gang = 1..n; 
array[Gang] of int: m;  % size of each gang
int: r; % number of rivalries
set of int: Rival = 1..r;
array[Rival] of Gang: g1;
array[Rival] of Gang: g2;

int: t = sum(m);
set of int: student = 1..t;
set of int: time= 1..t;
array[time] of var student: order;
array[student] of var time: times_of_interview;

bool: stageB = if r==0 then false else true endif;

array[Gang] of student: gang_leader = [if i!=1 then sum([m[j] | j in 1..i-1]) + 1 else 1 endif| i in 1..n];

array[student] of Gang: member_of = [i | i in Gang , j in 1..m[i]];%%%%???

%predicate gang_of_student(var student: s) = forall(i in Gang)(if s>gang_leader[i] /\ s < gang_leader[i+1] then %i endif);

%predicate not_same_gang_members(var student: s1 , var student: s2) = if gang_of_student(s1) != gang_of_student(s2) then true else false endif;

predicate is_leader(var student: i) = if sum([if i==j then 1 else 0 endif | j in gang_leader])>0 then true else false endif; 

predicate is_morning(var time: ti) =if ti<t div 2 then true else false endif;

predicate not_same_gang_members(var student: s1 , var student: s2) = member_of[s1] != member_of[s2];

predicate are_rivals(var Gang: gang1 , var Gang: gang2) = sum([if g1[i]==gang1 /\ g2[i]==gang2 then 1 elseif g2[i]==gang1 /\ g1[i]==gang2 then 1 else 0 endif | i in 1..r]) > 0;


predicate all_members_interviewed(var Gang: g , var time: ti) = forall(i in 
student where member_of[i]==g
)(times_of_interview[i]<ti);

predicate any_rival_interviewed(var student: s , var time: ti) = sum([if all_members_interviewed(j , ti) then 1 else 0 endif | j in [if g1[i]==member_of[s] then g2[i] else -1 endif| i in 1..r] ++ [if g2[i]==member_of[s] then g1[i] else -1 endif| i in 1..r] where j!=-1]) > 0;

function var int: nr_of_points(var int: s,int: ti) = if is_leader(s) then if is_morning(ti) then 3 else 0 endif elseif times_of_interview[gang_leader[member_of[s]]] < times_of_interview[s] then 0 else 1 endif;

function var int: nr_of_members_not_interviewed_yet(var int: g ,var int: time) = sum([if times_of_interview[i] > time then 1 else 0 endif | i in student where member_of[i]==g ]);

%[if g1[i]==member_of[s] then g2[i] endif| i in 1..r] ++ [if g2[i]==member_of[s] then g2[i] endif| i in 1..r]
%sum([if all_members_interviewed(j , order[s]) then 1 else 0 endif | j in [if g1[i]==member_of[s] then g2[i] endif| i in 1..r] ++ [if g2[i]==member_of[s] then g2[i] endif| i in 1..r]])

function var int: nr_of_points_stageB(var int: s, var int: ti) = 
if is_leader(s) then 
if any_rival_interviewed(s, ti) then 3+2*nr_of_members_not_interviewed_yet(member_of[s] , ti) 
elseif is_morning(times_of_interview[s]) then 3 else 0 endif 
elseif times_of_interview[gang_leader[member_of[s]]] < times_of_interview[s] then 0 else 1 endif;

%%%%%%% Go crazy here
%Stage A
%members of the same gang cant be interviewed one after another
constraint forall(i in 1..t-1)(not_same_gang_members(order[i] , order[i+1]));
constraint alldifferent(order);
constraint forall(i in time)(times_of_interview[order[i]]==i);

%Stage B
%constraint if stageB==true then forall(i in 1..t-1)(not are_rivals(gang_of_student(order[i]), gang_of_student(order[i + 1]))) endif;

constraint if stageB==true then forall(i in 1..t-1)(not are_rivals(member_of[order[i]], member_of[order[i+1]])) endif;



%var int: obj = sum([if is_leader(order[s]) then if is_morning(s) then 3 else 2 endif elseif order[gang_leader[member_of[s]]] < order[s] then 0 else 1 endif | s in time]);

array[student] of var int: points =  if stageB==false then [nr_of_points(order[s] , s)| s in time] else [nr_of_points_stageB(order[s] , s)| s in time] endif;
var int: obj = sum(points);
array[student] of var int: of_gang = [member_of[i]|i in order];


solve

%::int_search([sum([1| i in time where points[i]==3])], first_fail, indomain_max,complete) 
%::seq_search([
%int_search()
%::int_search([sum([1| i in time where points[i]>3])], first_fail, indomain_max,complete)
%])

maximize obj;

output
["obj = ",show(obj), ";\n"] ++
[show(order), ";\n"] ++
[show(points) , ";\n"] ++
[show(of_gang), ";\n"] ++
[show(gang_leader)]
;

