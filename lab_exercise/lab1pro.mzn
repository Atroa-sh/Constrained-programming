set of int: przedzial = 1..menu_length;
int: jakis = trace("testing\n" , menu_length*2);
int: menu_length;
int: money_limit;
array[przedzial] of int: menu_prices;
array[przedzial] of string: menu_names;
array[przedzial] of var int: order;
array[przedzial] of int: yumyum_factors;
%constraint forall([order[i] >= 0 | i in 1..menu_length]); zamiast tego abs() na kazdy order[i], ani troche eleganckie ale krotsze
%constraint abort("costam");

constraint assert(trace("tu trace w assercie",money_limit>=0),"money_limit is negative");
constraint sum([abs(order[i]) * menu_prices[i] | i in przedzial]) <= money_limit;
constraint trace("\n\n\n\n\n");
var int: smacznosc = sum([abs(order[i])*yumyum_factors[i] | i in przedzial]);


solve maximize(smacznosc);

output [menu_names[i] ++ ": " ++ show(abs(order[i])) ++" "++ show(smacznosc) ++ "\n" | i in przedzial];

