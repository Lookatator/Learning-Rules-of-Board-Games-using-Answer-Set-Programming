% initialize the two players

role(player1, red).
role(player2, blue).

opponent_player(player1, player2).
opponent_player(player2, player1).

% describe the state of the game before any player plays
holds(cell(coord(0,0..4), red),1).
holds(cell(coord(1,0), red),1).
holds(cell(coord(1,4), red),1).
holds(cell(coord(1..3,1..3), empty),1).
holds(cell(coord(2,0), empty),1).
holds(cell(coord(2,4), empty),1).
holds(cell(coord(3,0), blue),1).
holds(cell(coord(3,4), blue),1).
holds(cell(coord(4,0..4), blue),1).

holds(is_at(pawn_p1_1,coord(0,0)),1).
holds(is_at(pawn_p1_2,coord(0,1)),1).
holds(is_at(pawn_p1_3,coord(0,2)),1).
holds(is_at(pawn_p1_4,coord(0,3)),1).
holds(is_at(pawn_p1_5,coord(0,4)),1).
holds(is_at(pawn_p1_6,coord(1,0)),1).
holds(is_at(pawn_p1_7,coord(1,4)),1).

holds(is_at(pawn_p2_1,coord(4,0)),1).
holds(is_at(pawn_p2_2,coord(4,1)),1).
holds(is_at(pawn_p2_3,coord(4,2)),1).
holds(is_at(pawn_p2_4,coord(4,3)),1).
holds(is_at(pawn_p2_5,coord(4,4)),1).
holds(is_at(pawn_p2_6,coord(3,0)),1).
holds(is_at(pawn_p2_7,coord(3,4)),1).

belongs_to(pawn_p1_1, player1).
belongs_to(pawn_p1_2, player1).
belongs_to(pawn_p1_3, player1).
belongs_to(pawn_p1_4, player1).
belongs_to(pawn_p1_5, player1).
belongs_to(pawn_p1_6, player1).
belongs_to(pawn_p1_7, player1).

belongs_to(pawn_p2_1, player2).
belongs_to(pawn_p2_2, player2).
belongs_to(pawn_p2_3, player2).
belongs_to(pawn_p2_4, player2).
belongs_to(pawn_p2_5, player2).
belongs_to(pawn_p2_6, player2).
belongs_to(pawn_p2_7, player2).

range0(0..3).
range1(1..4).

possible_move(coord(X1,X2),coord(Y1,Y2)) :- X1==Y1-1, X2==Y2-1, range0(X1), range0(X2), range1(Y1), range1(Y2).
possible_move(coord(X1,X2),coord(Y1,Y2)) :- X1==Y1-1, X2==Y2+1, range0(X1), range1(X2), range1(Y1), range0(Y2).
possible_move(coord(X1,X2),coord(Y1,Y2)) :- X1==Y1+1, X2==Y2-1, range1(X1), range0(X2), range0(Y1), range1(Y2).
possible_move(coord(X1,X2),coord(Y1,Y2)) :- X1==Y1+1, X2==Y2+1, range1(X1), range1(X2), range0(Y1), range0(Y2).





% describe what actions are legal or not.
%legal(P, move(X,Y), T) :- possible_move(X,Y), holds(cell(X,S), T), holds(cell(Y,empty), T), role(P, S), time(T), can_play(P, move, T).

% can_play(P, move, T) :- can_play(P2, move, T-1), time(T), opponent_player(P, P2).


legal(Player, move_pawn(Pawn, up_right), T) :- legal(Player, move(coord(X,Y),coord(X+1,Y-1)), T), holds(is_at(Pawn, coord(X,Y)), T), belongs_to(Pawn, Player), time(T).
legal(Player, move_pawn(Pawn, up_left), T) :- legal(Player, move(coord(X,Y),coord(X-1,Y-1)), T), holds(is_at(Pawn, coord(X,Y)), T), belongs_to(Pawn, Player), time(T).
legal(Player, move_pawn(Pawn, down_right), T) :- legal(Player, move(coord(X,Y),coord(X+1,Y+1)), T), holds(is_at(Pawn, coord(X,Y)), T), belongs_to(Pawn, Player), time(T).
legal(Player, move_pawn(Pawn, down_left), T) :- legal(Player, move(coord(X,Y),coord(X-1,Y+1)), T), holds(is_at(Pawn, coord(X,Y)), T), belongs_to(Pawn, Player), time(T).

does(Player, move(coord(X,Y),coord(X+1,Y-1)), T) :- does(Player, move_pawn(Pawn, up_right), T), holds(is_at(Pawn, coord(X,Y)), T), time(T), range0(X), range1(Y).
does(Player, move(coord(X,Y),coord(X-1,Y-1)), T) :- does(Player, move_pawn(Pawn, up_left), T), holds(is_at(Pawn, coord(X,Y)), T), time(T), range1(X), range1(Y).
does(Player, move(coord(X,Y),coord(X+1,Y+1)), T) :- does(Player, move_pawn(Pawn, down_right), T), holds(is_at(Pawn, coord(X,Y)), T), time(T), range0(X), range0(Y).
does(Player, move(coord(X,Y),coord(X-1,Y+1)), T) :- does(Player, move_pawn(Pawn, down_left), T), holds(is_at(Pawn, coord(X,Y)), T), time(T), range1(X), range0(Y).

does(Player, move_pawn(Pawn, up_right), T)   :- does(Player, move(coord(X,Y),coord(X+1,Y-1)), T), holds(is_at(Pawn, coord(X,Y)), T), time(T), range0(X), range1(Y).
does(Player, move_pawn(Pawn, up_left), T)    :- does(Player, move(coord(X,Y),coord(X-1,Y-1)), T), holds(is_at(Pawn, coord(X,Y)), T), time(T), range1(X), range1(Y).
does(Player, move_pawn(Pawn, down_right), T) :- does(Player, move(coord(X,Y),coord(X+1,Y+1)), T), holds(is_at(Pawn, coord(X,Y)), T), time(T), range0(X), range0(Y).
does(Player, move_pawn(Pawn, down_left), T)  :- does(Player, move(coord(X,Y),coord(X-1,Y+1)), T), holds(is_at(Pawn, coord(X,Y)), T), time(T), range1(X), range0(Y). 

%:- does(Player, move(Pawn, up_right), T), role(Player, S), time(T), is_at(Pawn, coord(X,Y)), legal(Player, move(coord(X,Y),coord(X+1,Y+1)), T).

% explain how an action by a player influences the state of the game
holds(cell(Y,S),T+1) :- does(P,move(X,Y),T), role(P,S).
holds(cell(X,empty),T+1) :- does(P,move(X,Y),T), role(P,S).
holds(cell(coord(X,Y),A),T+1) :- holds(cell(coord(X,Y),A),T), time(T),
		not does(player1,move(coord(X,Y),coord(X+1,Y+1)),T),
		not does(player1,move(coord(X,Y),coord(X+1,Y-1)),T),
		not does(player1,move(coord(X,Y),coord(X-1,Y+1)),T),
		not does(player1,move(coord(X,Y),coord(X-1,Y-1)),T),
		not does(player2,move(coord(X,Y),coord(X+1,Y+1)),T),
		not does(player2,move(coord(X,Y),coord(X+1,Y-1)),T),
		not does(player2,move(coord(X,Y),coord(X-1,Y+1)),T),
		not does(player2,move(coord(X,Y),coord(X-1,Y-1)),T),
		not does(player1,move(coord(X+1,Y+1),coord(X,Y)),T),
		not does(player1,move(coord(X+1,Y-1),coord(X,Y)),T),
		not does(player1,move(coord(X-1,Y+1),coord(X,Y)),T),
		not does(player1,move(coord(X-1,Y-1),coord(X,Y)),T),
		not does(player2,move(coord(X+1,Y+1),coord(X,Y)),T),
		not does(player2,move(coord(X+1,Y-1),coord(X,Y)),T),
		not does(player2,move(coord(X-1,Y+1),coord(X,Y)),T),
		not does(player2,move(coord(X-1,Y-1),coord(X,Y)),T).


holds(is_at(Pawn,coord(X2,Y2)),T+1) :- does(Player, move(coord(X1,Y1),coord(X2,Y2)), T), holds(is_at(Pawn, coord(X1,Y1)),T), belongs_to(Pawn, Player), time(T).
holds(is_at(Pawn,coord(X,Y)),T+1) :- holds(is_at(Pawn, coord(X,Y)),T), belongs_to(Pawn, Player),  time(T), 
	not does(Player, move_pawn(Pawn,up_right), T), not does(Player, move_pawn(Pawn,up_left), T),
	not does(Player, move_pawn(Pawn,down_right), T), not does(Player, move_pawn(Pawn,down_left), T).


% conditions to stop the game
terminal(T) :- wins(P,T), role(P,S).

wins(player1,T) :- holds(cell(coord(3,0), red),T), holds(cell(coord(3,4), red),T), time(T), not terminated(T-1), 
		holds(cell(coord(4,0), red),T), holds(cell(coord(4,1), red),T), holds(cell(coord(4,2), red),T), holds(cell(coord(4,3), red),T), holds(cell(coord(4,4), red),T).
wins(player2,T) :- holds(cell(coord(1,0), blue),T), holds(cell(coord(1,4), blue),T), time(T), not terminated(T-1), 
		holds(cell(coord(0,0), blue),T), holds(cell(coord(0,1), blue),T), holds(cell(coord(0,2), blue),T), holds(cell(coord(0,3), blue),T), holds(cell(coord(0,4), blue),T).

% describe the different goals that a player may fulfill
goal(P, 100, T) :- wins(P,T).
goal(P, 50, T) :- role(P,S), time(T), terminal(T), not wins(P,T), not goal(P, 0, T).
goal(P, 0, T) :- role(P,S), not wins(P,T), wins(P2,T), P2 != P.

% defining the move domain
move_domain(move(X,Y)) :- possible_move(X,Y).

direction_domain(up_right).
direction_domain(up_left).
direction_domain(down_right).
direction_domain(down_left).


% only one action is performed at every step
1{does(player1,move_pawn(pawn_p1_1,up_right),T);
does(player1,move_pawn(pawn_p1_2,up_right),T);
does(player1,move_pawn(pawn_p1_3,up_right),T);
does(player1,move_pawn(pawn_p1_4,up_right),T);
does(player1,move_pawn(pawn_p1_5,up_right),T);
does(player1,move_pawn(pawn_p1_6,up_right),T);
does(player1,move_pawn(pawn_p1_7,up_right),T);
does(player2,move_pawn(pawn_p2_1,up_right),T);
does(player2,move_pawn(pawn_p2_2,up_right),T);
does(player2,move_pawn(pawn_p2_3,up_right),T);
does(player2,move_pawn(pawn_p2_4,up_right),T);
does(player2,move_pawn(pawn_p2_5,up_right),T);
does(player2,move_pawn(pawn_p2_6,up_right),T);
does(player2,move_pawn(pawn_p2_7,up_right),T);
does(player1,move_pawn(pawn_p1_1,up_left),T);
does(player1,move_pawn(pawn_p1_2,up_left),T);
does(player1,move_pawn(pawn_p1_3,up_left),T);
does(player1,move_pawn(pawn_p1_4,up_left),T);
does(player1,move_pawn(pawn_p1_5,up_left),T);
does(player1,move_pawn(pawn_p1_6,up_left),T);
does(player1,move_pawn(pawn_p1_7,up_left),T);
does(player2,move_pawn(pawn_p2_1,up_left),T);
does(player2,move_pawn(pawn_p2_2,up_left),T);
does(player2,move_pawn(pawn_p2_3,up_left),T);
does(player2,move_pawn(pawn_p2_4,up_left),T);
does(player2,move_pawn(pawn_p2_5,up_left),T);
does(player2,move_pawn(pawn_p2_6,up_left),T);
does(player2,move_pawn(pawn_p2_7,up_left),T);
does(player1,move_pawn(pawn_p1_1,down_right),T);
does(player1,move_pawn(pawn_p1_2,down_right),T);
does(player1,move_pawn(pawn_p1_3,down_right),T);
does(player1,move_pawn(pawn_p1_4,down_right),T);
does(player1,move_pawn(pawn_p1_5,down_right),T);
does(player1,move_pawn(pawn_p1_6,down_right),T);
does(player1,move_pawn(pawn_p1_7,down_right),T);
does(player2,move_pawn(pawn_p2_1,down_right),T);
does(player2,move_pawn(pawn_p2_2,down_right),T);
does(player2,move_pawn(pawn_p2_3,down_right),T);
does(player2,move_pawn(pawn_p2_4,down_right),T);
does(player2,move_pawn(pawn_p2_5,down_right),T);
does(player2,move_pawn(pawn_p2_6,down_right),T);
does(player2,move_pawn(pawn_p2_7,down_right),T);
does(player1,move_pawn(pawn_p1_1,down_left),T);
does(player1,move_pawn(pawn_p1_2,down_left),T);
does(player1,move_pawn(pawn_p1_3,down_left),T);
does(player1,move_pawn(pawn_p1_4,down_left),T);
does(player1,move_pawn(pawn_p1_5,down_left),T);
does(player1,move_pawn(pawn_p1_6,down_left),T);
does(player1,move_pawn(pawn_p1_7,down_left),T);
does(player2,move_pawn(pawn_p2_1,down_left),T);
does(player2,move_pawn(pawn_p2_2,down_left),T);
does(player2,move_pawn(pawn_p2_3,down_left),T);
does(player2,move_pawn(pawn_p2_4,down_left),T);
does(player2,move_pawn(pawn_p2_5,down_left),T);
does(player2,move_pawn(pawn_p2_6,down_left),T);
does(player2,move_pawn(pawn_p2_7,down_left),T)}1 :- time(T), not terminated(T).
terminated(T) :- terminal(T).
terminated(T+1) :- terminated(T), time(T).


% everything that is done must be legal
%:- does(P,M,T), not legal(P,M,T).

% :- 0{terminated(T) : time(T)}0.

%% turn-based game
% a player cannot play twice
%:- does(P,M1,T), does(P,M2,T+1).

% the first player starts
%1{does(player1,move_pawn(Pawn,Direction),1) : direction_domain(Direction), belongs_to(Pawn, player1)}1.

legal(P,move(X,Y),T) :- can_play(P, move, T), extra(P,X,Y,T).
can_play(player1,move,1).
decrement_time(T, T-1) :- time(T).



#bias(":- head(extra(P,X,Y,T)), body(can_play(P2,M,T2)).").
#bias(":- head(extra(P,X,Y,T)), body(decrement_time(T1,T2)).").
#bias(":- head(extra(P,X,Y,T)), body(opponent_player(P1,P2)).").
#bias(":- head(can_play(P,move,T)), body(can_play(P,move,T)).").
#bias(":- head(can_play(P,move,T)), body(holds(C,T)).").
#bias(":- head(can_play(P,move,T)), possible_move(X,Y).").
#bias(":- constraint.").





#maxv(5).
#max_penalty(10).
%#disallow_multiple_head_variables.



%does(player1,move(coord(1,0),coord(2,1)),1).
%time(1..2).

#modeh(can_play(var(player), const(action), var(time))).
#modeb(1, opponent_player(var(player), var(player2)), (positive)).
#modeb(1,can_play(var(player2), const(action), var(time))).
#modeb(1,can_play(var(player2), const(action), var(time2)),(positive)).
#modeb(1, decrement_time(var(time), var(time2)), (positive)).
#modeb(1, time(var(time)), (positive)).

#constant(action, move).
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
#pos({legal(player1,move(coord(1,0),coord(2,1)),1)},{},{ time(1..1).}).
#neg({legal(player1,move(coord(2,1),coord(3,0)),2)},{},{does(player1,move(coord(1,0),coord(2,1)),1).
 time(1..2).}).
#pos({legal(player2,move(coord(4,0),coord(3,1)),2)},{},{does(player1,move(coord(1,0),coord(2,1)),1).
 time(1..2).}).
#neg({legal(player2,move(coord(4,1),coord(3,2)),3)},{},{does(player1,move(coord(1,0),coord(2,1)),1).
does(player2,move(coord(4,0),coord(3,1)),2).
 time(1..3).}).
#pos({legal(player1,move(coord(1,4),coord(2,3)),3)},{},{does(player1,move(coord(1,0),coord(2,1)),1).
does(player2,move(coord(4,0),coord(3,1)),2).
 time(1..3).}).
#neg({legal(player2,move(coord(1,3),coord(2,2)),4)},{},{does(player1,move(coord(1,0),coord(2,1)),1).
does(player2,move(coord(4,0),coord(3,1)),2).
does(player1,move(coord(1,4),coord(2,3)),3).
 time(1..4).}).
