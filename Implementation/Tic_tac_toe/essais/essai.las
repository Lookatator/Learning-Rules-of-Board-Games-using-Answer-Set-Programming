coin(1..2). 
1{val(C,h),val(C,t)}1:- coin(C).

#pos(pos1,{},{},{val(1,V) :- val(2,V).}).
#pos(pos2,{},{},{:- val(1,V), val(2,V).}).

#brave_ordering(coucou,pos1,pos2).

#modeo(val(var(c),const(t)),(positive)).

#constant(t,t).
#constant(t,h).
#weight(1).
#maxv(2).
#maxp(1).
