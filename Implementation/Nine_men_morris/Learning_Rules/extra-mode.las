#modeh(extra_place_pawn(var(p), place_pawn(var(c)), var(t))).
#modeh(extra_move(var(p), move(var(c1),var(c2)), var(t))).
#modeh(extra_remove_pawn(var(p), remove_pawn(var(c)), var(t))).

#modeb(holds(cell(var(c),const(color_const)),var(t))).
#modeb(holds(cell(var(c2),const(color_const)),var(t))).
#modeb(holds(cell(var(c1),var(color2)),var(t))).


#modeb(1, opponent_color(var(color),var(color2)), (positive)).
#modeb(1, role(var(p),var(color)), (positive)).
#modeb(1, is_in_mill(var(c),var(t))).

#constant(color_const, red).
#constant(color_const, blue).
#constant(color_const, empty).

#bias(":- constraint.").

#maxv(4).