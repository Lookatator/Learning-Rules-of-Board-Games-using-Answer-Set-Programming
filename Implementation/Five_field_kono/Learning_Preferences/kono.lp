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
holds(cell(X,A),T+1) :- holds(cell(X,A),T), time(T),  
		not does(P,move(X,Y),T) : possible_move(X,Y), role(P,S); 
		not does(P,move(Z,X),T) : possible_move(Z,X), role(P,S).

holds(is_at(Pawn,coord(X2,Y2)),T+1) :- does(Player, move(coord(X1,Y1),coord(X2,Y2)), T), holds(is_at(Pawn, coord(X1,Y1)),T), belongs_to(Pawn, Player), time(T).
holds(is_at(Pawn,coord(X,Y)),T+1) :- holds(is_at(Pawn, coord(X,Y)),T), belongs_to(Pawn, Player),  time(T), not does(Player, move_pawn(Pawn,Direction), T) : direction_domain(Direction).


% conditions to stop the game
terminal(T) :- wins(P,T), role(P,S).

wins(player1,T) :- holds(cell(coord(3,0), red),T), holds(cell(coord(3,4), red),T), time(T), not terminated(T-1), holds(cell(coord(4,X), red),T) : X=0..4.
wins(player2,T) :- holds(cell(coord(1,0), blue),T), holds(cell(coord(1,4), blue),T), time(T), not terminated(T-1), holds(cell(coord(0,X), blue),T) : X=0..4.

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
1{does(Player,move_pawn(Pawn,Direction),T) : direction_domain(Direction), belongs_to(Pawn, Player)}1 :- time(T), not terminated(T).


terminated(T) :- terminal(T).
terminated(T+1) :- terminated(T), time(T).

% everything that is done must be legal
:- does(P,M,T), not legal(P,M,T).

% :- 0{terminated(T) : time(T)}0.

%% turn-based game
% a player cannot play twice
:- does(P,M1,T-1), does(P,M2,T), highest_time(T).
highest_time(T) :- time(T), T>=T1 : time(T1). % trick to reduce the time taken by gringo to compute the answer

% the first player starts
1{does(player1,move_pawn(Pawn,Direction),1) : direction_domain(Direction), belongs_to(Pawn, player1)}1.



%does(player1,move_pawn(pawn_p1_6,down_right),1).

diagonal_collision(cell(Coord_1,State_1), cell(Coord_2,State_2), T) :- holds(cell(Coord_1,State_1),T), holds(cell(Coord_2,State_2), T), possible_move(Coord_1,Coord_2), time(T).

has_state(Coord,State,T) :- holds(cell(Coord,State),T), time(T).

#show.

