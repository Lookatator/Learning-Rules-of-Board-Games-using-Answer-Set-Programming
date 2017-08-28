#modeh(can_play_t(var(player), const(action), var(time)+1)).

#modeb(1, opponent_player(var(player), var(player2)), (positive)).
#modeb(1, can_play(var(player2), var(action), var(time)),(positive)).
%#modeb(1, can_play(var(player1), var(action), var(time))).
#modeb(1, can_play(var(player2), remove_pawn, var(time)+1)).


#modeb(1, phase(phase(1), var(time)+1),(positive)).
#modeb(1, phase(phase(2), var(time)+1),(positive)).
#modeb(1, has_mill(var(player),var(mill),var(time))).
#modeb(1, has_mill(var(player),var(mill),var(time)+1)).

#maxv(4).

#constant(action, place_pawn).
#constant(action, move).
#constant(action, remove_pawn).

#bias(":- constraint.").
%#bias(":- head(can_play_extra(P, T)), body(phase(phase(1),T)).").
%#bias(":- head(can_play_extra(P, T)), body(phase(phase(2),T)).").
#bias(":- head(can_play(P, A, T)), body(has_mill(P,M,T)).").
#bias(":- body(phase(phase(1),T)), body(phase(phase(2),T)).").
#bias(":- head(can_play_t(P1,A,T)),body(opponent_player(P1,P2)), body(naf(can_play(P2,A,T))).").
