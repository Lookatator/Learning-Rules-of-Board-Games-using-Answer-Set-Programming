% initialize the two players

role(player1, red).
role(player2, blue).

% describe the state of the game before any player plays
holds(cell(coord(0..3,0..1), blue),1).
holds(cell(coord(0..3,2..3), red),1).

range0(0..3).
range1(0..2).
range2(1..3).

direction_domain(right).
direction_domain(left).
direction_domain(up).
direction_domain(down).

adjacent(coord(X1,Y1),coord(X1+1,Y1),right) :- range0(Y1), range1(X1).
adjacent(coord(X1,Y1),coord(X1-1,Y1),left) :- range0(Y1), range2(X1).
adjacent(coord(X1,Y1),coord(X1,Y1-1),up) :- range0(X1), range2(Y1).
adjacent(coord(X1,Y1),coord(X1,Y1+1),down) :- range0(X1), range1(Y1).



% describe what actions are legal or not.

legal(Player, move(Coord_1,Coord_2), T) :- holds(cell(Coord_2,empty),T), holds(cell(Coord_1, Color),T), adjacent(Coord_1,Coord_2,Direction), direction_domain(Direction), role(Player, Color), time(T).
legal(Player, jump(Coord_1,Coord_2), T) :- holds(cell(Coord_1,Color),T), not holds(cell(Coord_2,Color),T), not holds(cell(Coord_2, empty),T), role(Player, Color), 
					   adjacent(Coord_1, Coord_3, Direction), adjacent(Coord_3, Coord_2, Direction), holds(cell(Coord_3,Color),T),
					   direction_domain(Direction), time(T).


% explain how an action by a player influences the state of the game

holds(cell(Coord_2,Color),T+1) :- does(Player, move(Coord_1,Coord_2),T), role(Player, Color), time(T).
holds(cell(Coord_1,empty),T+1) :- does(Player, move(Coord_1,Coord_2),T), role(Player, Color), time(T).

holds(cell(Coord_2,Color),T+1) :- does(Player, jump(Coord_1,Coord_2),T), role(Player, Color), time(T).
holds(cell(Coord_1,empty),T+1) :- does(Player, jump(Coord_1,Coord_2),T), role(Player, Color), time(T).

holds(cell(Coord, S), T+1) :- holds(cell(Coord, S), T), time(T),
					not does(Player, move(Coord, Coord_2), T) : adjacent(Coord,Coord_2,Direction), direction_domain(Direction), role(Player, Color);
					not does(Player, move(Coord_1, Coord), T) : adjacent(Coord_1,Coord,Direction), direction_domain(Direction), role(Player, Color);
					not does(Player, jump(Coord, Coord_2), T) : adjacent(Coord,Coord_3,Direction), adjacent(Coord_3,Coord_2,Direction), direction_domain(Direction), role(Player, Color);
					not does(Player, jump(Coord_1, Coord), T) : adjacent(Coord_1,Coord_3,Direction), adjacent(Coord_3,Coord,Direction), direction_domain(Direction), role(Player, Color).




% conditions to stop the game
%terminal(T) :- wins(P,T), role(P,S).

%wins(player1,T) :- holds(cell(coord(3,0), red),T), holds(cell(coord(3,4), red),T), time(T), not terminated(T-1), holds(cell(coord(4,X), red),T) : X=0..4.
%wins(player2,T) :- holds(cell(coord(1,0), blue),T), holds(cell(coord(1,4), blue),T), time(T), not terminated(T-1), holds(cell(coord(0,X), blue),T) : X=0..4.

% describe the different goals that a player may fulfill
%goal(P, 100, T) :- wins(P,T).
%goal(P, 50, T) :- role(P,S), time(T), terminal(T), not wins(P,T), not goal(P, 0, T).
%goal(P, 0, T) :- role(P,S), not wins(P,T), wins(P2,T), P2 != P.

% defining the move domain
move_domain(move(Coord_1, Coord_2)) :- adjacent(Coord_1, Coord_2, Direction), direction_domain(Direction).
move_domain(jump(Coord_1, Coord_2)) :- adjacent(Coord_1, Coord_3, Direction), adjacent(Coord_3, Coord_2, Direction), direction_domain(Direction).

% only one action is performed at every step
1{does(Player, M, T) : role(Player,Color), move_domain(M)}1 :- time(T), not terminated(T).
does(player1, jump(coord(0,3),coord(0,1)), 1).

terminated(T) :- terminal(T).
terminated(T+1) :- terminated(T), time(T).

% everything that is done must be legal
:- does(P,M,T), not legal(P,M,T).

% :- 0{terminated(T) : time(T)}0.

%% turn-based game
% a player cannot play twice
:- does(P,M1,T-1), does(P,M2,T).%, highest_time(T).
%highest_time(T) :- time(T), T>=T1 : time(T1). % trick to reduce the time taken by gringo to compute the answer

% the first player starts
%1{does(player1,move_pawn(Pawn,Direction),1) : direction_domain(Direction), belongs_to(Pawn, player1)}1.

time(1..3).

#show.
%#show holds(X,1) : holds(X,1).
%#show legal(P,M,T) : legal(P,M,T).
#show does(P,M,T) : does(P,M,T).
