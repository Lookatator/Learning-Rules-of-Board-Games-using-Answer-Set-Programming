#modeh(can_play(var(player), const(action), var(time))).
#modeb(1, opponent_player(var(player), var(player2)), (positive)).
#modeb(1,can_play(var(player2), const(action), var(time))).
#modeb(1,can_play(var(player2), const(action), var(time2)),(positive)).
#modeb(1, decrement_time(var(time), var(time2)), (positive)).
#modeb(1, time(var(time)), (positive)).

#constant(action, move).
