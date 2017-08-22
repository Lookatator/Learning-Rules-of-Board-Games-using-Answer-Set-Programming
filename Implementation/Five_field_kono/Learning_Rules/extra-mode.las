#modeh(extra(var(player), var(x), var(y), var(time))).
#modeb(1,possible_move(var(x), var(y)), (positive)).
#modeb(holds(cell(var(x),const(color)), var(time))).
#modeb(holds(cell(var(x),var(color)), var(time))).
#modeb(holds(cell(var(y),const(color)), var(time))).
#modeb(holds(cell(var(y),var(color)), var(time))).
#modeb(1,role(var(player),var(color)), (positive)).
#modeb(1, time(var(time)), (positive)).

#constant(color, red).
#constant(color, empty).
#constant(color, blue).
