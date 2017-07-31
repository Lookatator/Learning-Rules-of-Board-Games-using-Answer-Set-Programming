% initialize the two players
role(player1, red).
role(player2, blue).

% describe the state of the game before any player plays
holds(cell(coord(1..8,1..3), empty),1).

holds(has_pawns(player1,9),1).
holds(has_pawns(player2,9),1).

range0_x(1..8).
range1_x(1..7).

range0_y(1..3).
range1_y(1..2).

adjacent(coord(X1,Y1),coord(X1+1,Y1)) :- range1_x(X1), range0_y(Y1).
adjacent(coord(X1+1,Y1),coord(X1,Y1)) :- range1_x(X1), range0_y(Y1).
adjacent(coord(8,Y1),coord(1,Y1)) :- range0_y(Y1).
adjacent(coord(1,Y1),coord(8,Y1)) :- range0_y(Y1).

adjacent(coord(X1,Y1),coord(X1,Y1+1)) :- even(X1), range1_y(Y1).
adjacent(coord(X1,Y1+1),coord(X1,Y1)) :- even(X1), range1_y(Y1).

even(2).
even(4).
even(6).
even(8).

odd(1).
odd(3).
odd(5).
odd(7).

turn(player1, 1).
turn(player2, T+1) :- time(T), turn(player1, T).
turn(player1, T+1) :- time(T), turn(player2, T).

phase(phase(1), 1).
phase(phase(N), T+1) :- time(T), phase(phase(N), T), not ending(phase(N), T+1).
phase(phase(N+1), T) :- time(T), ending(phase(N),T), not terminated(T).

ending(phase(1), T) :- time(T), holds(has_pawns(player1, 0), T), holds(has_pawns(player2, 0), T).
ending(phase(2), T) :- terminal(T).

% USUALLY:
% can_play(Player, Action, T) :- turn(Player, T).

can_play(player1, place_pawn, 1).

:- can_play(player1, Action, T), can_play(player2, Action, T).

can_play(player1, place_pawn, T+1) :- does(player2, Action, T), time(T), not new_mill(player2, T+1).
can_play(player1, move, T+1) :- does(player2, Action, T), time(T), not new_mill(player2, T+1).
can_play(player1, remove_pawn, T+1) :- does(player1, Action, T), time(T), new_mill(player1, T+1).

can_play(player2, place_pawn, T+1) :- does(player1, Action, T), time(T), not new_mill(player1, T+1).
can_play(player2, move, T+1) :- does(player1, Action, T), time(T), not new_mill(player1, T+1).
can_play(player2, remove_pawn, T+1) :- does(player2, Action, T), time(T), new_mill(player2, T+1).

% describe what actions are legal or not.

legal(Player, place_pawn(Coord), T) :- holds(cell(Coord,empty),T), role(Player, Color), time(T), can_play(Player, place_pawn, T), phase(phase(1),T).
legal(Player, move(Coord_1, Coord_2), T) :- time(T), holds(cell(Coord_1, Color),T), holds(cell(Coord_2,empty),T), role(Player, Color), adjacent(Coord_1,Coord_2), can_play(Player, move, T), phase(phase(2),T).
legal(Player, remove_pawn(Coord), T) :- time(T), role(Player, Color), can_play(Player, remove_pawn, T), phase(phase(1..2),T),
					holds(cell(Coord,S),T), not holds(cell(Coord,Color),T), not holds(cell(Coord,empty),T).


% explain how an action by a player influences the state of the game

holds(cell(Coord, Color), T+1) :- time(T), role(Player, Color), does(Player, place_pawn(Coord), T).
holds(cell(Coord_2, Color), T+1) :- time(T), role(Player, Color), does(Player, move(Coord_1, Coord_2), T).
holds(cell(Coord_1, empty), T+1) :- time(T), role(Player, Color), does(Player, move(Coord_1, Coord_2), T).

holds(cell(Coord, empty), T+1) :- time(T), role(Player, Color), does(Player, remove_pawn(Coord), T).

holds(cell(Coord, empty), T+1) :- holds(cell(Coord, empty), T), time(T), not holds(cell(Coord, red), T+1), not holds(cell(Coord, blue), T+1).
holds(cell(Coord, red), T+1) :- holds(cell(Coord, red), T), time(T), not holds(cell(Coord, empty), T+1), not holds(cell(Coord, blue), T+1).
holds(cell(Coord, blue), T+1) :- holds(cell(Coord, blue), T), time(T), not holds(cell(Coord, red), T+1), not holds(cell(Coord, empty), T+1).

%TODO : changer pour has_pawns/3.
holds(has_pawns(Player, N-1), T+1) :- time(T), role(Player, Color), holds(has_pawns(Player, N), T), does(Player, place_pawn(coord(X,Y)), T), range0_x(X), range0_y(Y).
holds(has_pawns(Player, N),   T+1) :- time(T), role(Player, Color), holds(has_pawns(Player, N), T), not holds(has_pawns(Player, N-1), T+1).


has_mill(Player, mill(coord(1,Y), coord(2,Y), coord(3,Y)), T) :- time(T), role(Player, Color), range0_y(Y),
										holds(cell(coord(1,Y),Color),T), holds(cell(coord(2,Y),Color),T), holds(cell(coord(3,Y),Color),T).
has_mill(Player, mill(coord(3,Y), coord(4,Y), coord(5,Y)), T) :- time(T), role(Player, Color), range0_y(Y),
										holds(cell(coord(3,Y),Color),T), holds(cell(coord(4,Y),Color),T), holds(cell(coord(5,Y),Color),T).
has_mill(Player, mill(coord(5,Y), coord(6,Y), coord(7,Y)), T) :- time(T), role(Player, Color), range0_y(Y),
										holds(cell(coord(5,Y),Color),T), holds(cell(coord(6,Y),Color),T), holds(cell(coord(7,Y),Color),T).
has_mill(Player, mill(coord(7,Y), coord(8,Y), coord(1,Y)), T) :- time(T), role(Player, Color), range0_y(Y),
										holds(cell(coord(7,Y),Color),T), holds(cell(coord(8,Y),Color),T), holds(cell(coord(1,Y),Color),T).

has_mill(Player, mill(coord(X,1), coord(X,2), coord(X,3)), T) :- time(T), role(Player, Color), even(X),
										holds(cell(coord(X,1),Color),T), holds(cell(coord(X,2),Color),T), holds(cell(coord(X,3),Color),T).

new_mill(Player, T) :- time(T), has_mill(Player, Mill, T), not has_mill(Player, Mill, T-1). 

% conditions to stop the game
%terminal(T) :- wins(P,T), role(P,S).

%wins(player1,T) :- holds(cell(coord(3,0), red),T), holds(cell(coord(3,4), red),T), time(T), not terminated(T-1), holds(cell(coord(4,X), red),T) : X=0..4.
%wins(player2,T) :- holds(cell(coord(1,0), blue),T), holds(cell(coord(1,4), blue),T), time(T), not terminated(T-1), holds(cell(coord(0,X), blue),T) : X=0..4.

% describe the different goals that a player may fulfill
%goal(P, 100, T) :- wins(P,T).
%goal(P, 50, T) :- role(P,S), time(T), terminal(T), not wins(P,T), not goal(P, 0, T).
%goal(P, 0, T) :- role(P,S), not wins(P,T), wins(P2,T), P2 != P.

% defining the move domain

move_domain(place_pawn(coord(1..8,1..3)), phase(1)).
move_domain(remove_pawn(coord(1..8,1..3)), phase(1)).
move_domain(move(Coord_1, Coord_2), phase(2)) :- adjacent(Coord_1, Coord_2).

% only one action is performed at every step
% 1{does(Player, M, T) : role(Player,Color), move_domain(M, Phase)}1 :- time(T), not terminated(T), phase(Phase, T).

1{does(Player, M, T) : legal(Player, M, T)}1 :- time(T), not terminated(T), phase(Phase, T).

terminated(T) :- terminal(T).
terminated(T+1) :- terminated(T), time(T).

phase(phase(1), 1).
phase(phase(N), T+1) :- time(T), phase(phase(N), T), not ending(phase(N), T+1).
phase(phase(N+1), T) :- time(T), ending(phase(N),T), not terminated(T).

ending(phase(1), T) :- time(T), holds(has_pawns(player1, 0), T), holds(has_pawns(player2, 0), T).
ending(phase(2), T) :- terminal(T).

% everything that is done must be legal
:- does(P,M,T), not legal(P,M,T).

% :- 0{terminated(T) : time(T)}0.

%% turn-based game
% a player cannot play twice
%:- does(P,M1,T-1), does(P,M2,T).%, highest_time(T).
%highest_time(T) :- time(T), T>=T1 : time(T1). % trick to reduce the time taken by gringo to compute the answer

% the first player starts
%1{does(player1,move_pawn(Pawn,Direction),1) : direction_domain(Direction), belongs_to(Pawn, player1)}1.
does(player1, place_pawn(coord(2,2)), 1).
does(player2, place_pawn(coord(1,2)), 2).
does(player1, place_pawn(coord(2,1)), 3).
does(player2, place_pawn(coord(8,2)), 4).
time(1..6).

#show.
%#show holds(X,1) : holds(X,1).
%#show legal(P,M,T) : legal(P,M,T).
#show does(P,M,6) : does(P,M,6).
%#show holds(has_pawns(P, N), T) :  holds(has_pawns(P, N), T).
%#show adjacent/2.
