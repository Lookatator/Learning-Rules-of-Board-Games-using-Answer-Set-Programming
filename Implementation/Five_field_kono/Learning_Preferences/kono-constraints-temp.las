% initialize the two players

role(player1, red).
role(player2, blue).

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
legal(P, move(X,Y), T) :- possible_move(X,Y), holds(cell(X,S), T), holds(cell(Y,empty), T), role(P, S), time(T).

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
:- does(P,M,T), not legal(P,M,T).

% :- 0{terminated(T) : time(T)}0.

%% turn-based game
% a player cannot play twice
:- does(P,M1,T), does(P,M2,T+1).

% the first player starts
%1{does(player1,move_pawn(Pawn,Direction),1) : direction_domain(Direction), belongs_to(Pawn, player1)}1.



diagonal_collision(up_right, State_2, cell(coord(X,Y),red), cell(coord(X1,Y1),State_2), T) :- holds(cell(coord(X,Y),red),T), holds(cell(coord(X1,Y1),State_2), T), possible_move(coord(X,Y),coord(X1,Y1)), X1==X+1, Y1==Y-1.
diagonal_collision(down_right, State_2, cell(coord(X,Y),red), cell(coord(X1,Y1),State_2), T) :- holds(cell(coord(X,Y),red),T), holds(cell(coord(X1,Y1),State_2), T), possible_move(coord(X,Y),coord(X1,Y1)), X1==X+1, Y1==Y+1.

diagonal_collision(State_2, cell(coord(X,Y),red), cell(coord(X1,Y1),State_2), T) :- diagonal_collision(down_right, State_2, cell(coord(X,Y),red), cell(coord(X1,Y1),State_2), T).
diagonal_collision(State_2, cell(coord(X,Y),red), cell(coord(X1,Y1),State_2), T) :- diagonal_collision(up_right, State_2, cell(coord(X,Y),red), cell(coord(X1,Y1),State_2), T).

adjacent(bottom, red, cell(coord(X,Y),red), cell(coord(X1,Y1),red), T) :- holds(cell(coord(X,Y),red),T), holds(cell(coord(X1,Y1),red),T), X==X1, Y==Y1+1.

has_state(Coord,State,T) :- holds(cell(Coord,State),T).

#pos(pos18,{does(player1,move(coord(2,3),coord(3,2)),3)},{},{
does(player1, move(coord(1,4),coord(2,3)),1).
does(player2, move(coord(4,4),coord(3,3)),2).
time(1..3).
}).
#pos(pos19,{does(player1,move(coord(2,3),coord(1,2)),3)},{},{
does(player1, move(coord(1,4),coord(2,3)),1).
does(player2, move(coord(4,4),coord(3,3)),2).
time(1..3).
}).
#pos(pos20,{does(player1,move(coord(2,3),coord(1,4)),3)},{},{
does(player1, move(coord(1,4),coord(2,3)),1).
does(player2, move(coord(4,4),coord(3,3)),2).
time(1..3).
}).
#pos(pos21,{does(player1,move(coord(0,3),coord(1,4)),3)},{},{
does(player1, move(coord(1,4),coord(2,3)),1).
does(player2, move(coord(4,4),coord(3,3)),2).
time(1..3).
}).
#pos(pos22,{does(player1,move(coord(0,4),coord(1,3)),3)},{},{
does(player1, move(coord(1,4),coord(2,3)),1).
does(player2, move(coord(4,4),coord(3,3)),2).
time(1..3).
}).
#pos(pos23,{does(player1,move(coord(0,0),coord(1,1)),3)},{},{
does(player1, move(coord(1,4),coord(2,3)),1).
does(player2, move(coord(4,4),coord(3,3)),2).
time(1..3).
}).
#pos(pos24,{does(player1,move(coord(0,3),coord(1,2)),3)},{},{
does(player1, move(coord(1,4),coord(2,3)),1).
does(player2, move(coord(4,4),coord(3,3)),2).
time(1..3).
}).
#pos(pos25,{does(player1,move(coord(0,1),coord(1,2)),3)},{},{
does(player1, move(coord(1,4),coord(2,3)),1).
does(player2, move(coord(4,4),coord(3,3)),2).
time(1..3).
}).
#pos(pos26,{does(player1,move(coord(0,2),coord(1,1)),3)},{},{
does(player1, move(coord(1,4),coord(2,3)),1).
does(player2, move(coord(4,4),coord(3,3)),2).
time(1..3).
}).
#pos(pos27,{does(player1,move(coord(0,2),coord(1,3)),3)},{},{
does(player1, move(coord(1,4),coord(2,3)),1).
does(player2, move(coord(4,4),coord(3,3)),2).
time(1..3).
}).
#pos(pos28,{does(player1,move(coord(1,0),coord(2,1)),3)},{},{
does(player1, move(coord(1,4),coord(2,3)),1).
does(player2, move(coord(4,4),coord(3,3)),2).
time(1..3).
}).
#brave_ordering(ord24@1, pos18, pos19).
#brave_ordering(ord25@1, pos18, pos20).
#brave_ordering(ord26@1, pos18, pos21).
#brave_ordering(ord27@1, pos18, pos22).
#brave_ordering(ord28@1, pos18, pos23).
#brave_ordering(ord29@1, pos18, pos24).
#brave_ordering(ord30@1, pos18, pos25).
#brave_ordering(ord31@1, pos18, pos26).
#brave_ordering(ord32@1, pos18, pos27).
#brave_ordering(ord33@1, pos28, pos19).
#brave_ordering(ord34@1, pos28, pos20).
#brave_ordering(ord35@1, pos28, pos21).
#brave_ordering(ord36@1, pos28, pos22).
#brave_ordering(ord37@1, pos28, pos23).
#brave_ordering(ord38@1, pos28, pos24).
#brave_ordering(ord39@1, pos28, pos25).
#brave_ordering(ord40@1, pos28, pos26).
#brave_ordering(ord41@1, pos28, pos27).


#modeo(diagonal_collision(const(state_1), var(c_1), var(c_2), var(t)),(positive)).
#modeo(adjacent(const(direction_2), const(state_2), var(c_1), var(c_2), var(t)),(positive)).
%#modeo(coucou(var(t)),(positive)).


%#modeo(possible_move(var(c_1),var(c_2)),(positive)).
%#modeo(has_state(var(c_1),const(state),const(t)),(positive)).
%#modeo(has_state(var(c_2),const(state),const(t)),(positive)).
%#bias("coucou :- body(possible_move(C1,C2,2)).").
%#bias(":- not coucou.").
#constant(direction_1, up_right).
#constant(direction_1, down_right).
#constant(direction_2, bottom).

#constant(state_1, red).
#constant(state_1, blue).
#constant(state_1, empty).
#constant(state_2, red).
#constant(t,2).
#constant(t,4).
#weight(-1).
#maxv(3).
#maxp(1).

%#show does/3.
%#show possible_move/2.
%#show does(Player,move_pawn(Pawn,Direction),T) : does(Player,move_pawn(Pawn,Direction),T), direction_domain(Direction), belongs_to(Pawn, Player), T=1.
%#show legal(player2,move_pawn(P,D),2) : legal(player2,move_pawn(P,D),2).
%#show legal(player1,move_pawn(P,D),1) : legal(player1,move_pawn(P,D),1).
%#show holds(is_at(Pawn, coord(X,Y)), 2) : holds(is_at(Pawn, coord(X,Y)), 2).
#pos(pos0,{does(player1,move(coord(0,0),coord(1,1)),1)},{},{
time(1).
}).
#pos(pos1,{does(player1,move(coord(0,1),coord(1,2)),1)},{},{
time(1).
}).
#pos(pos2,{does(player1,move(coord(0,2),coord(1,1)),1)},{},{
time(1).
}).
#pos(pos3,{does(player1,move(coord(0,2),coord(1,3)),1)},{},{
time(1).
}).
#pos(pos4,{does(player1,move(coord(0,3),coord(1,2)),1)},{},{
time(1).
}).
#pos(pos5,{does(player1,move(coord(0,4),coord(1,3)),1)},{},{
time(1).
}).
#pos(pos6,{does(player1,move(coord(1,0),coord(2,1)),1)},{},{
time(1).
}).
#pos(pos7,{does(player1,move(coord(1,4),coord(2,3)),1)},{},{
time(1).
}).
#brave_ordering(ord0@1, pos7, pos0).
#brave_ordering(ord1@1, pos7, pos1).
#brave_ordering(ord2@1, pos7, pos2).
#brave_ordering(ord3@1, pos7, pos3).
#brave_ordering(ord4@1, pos7, pos4).
#brave_ordering(ord5@1, pos7, pos5).
#brave_ordering(ord6@1, pos6, pos0).
#brave_ordering(ord7@1, pos6, pos1).
#brave_ordering(ord8@1, pos6, pos2).
#brave_ordering(ord9@1, pos6, pos3).
#brave_ordering(ord10@1, pos6, pos4).
#brave_ordering(ord11@1, pos6, pos5).
