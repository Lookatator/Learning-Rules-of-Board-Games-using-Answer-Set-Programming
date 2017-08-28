% initialize the two players
role(player1, red).
role(player2, blue).

% Opponent relations
opponent_player(P1, P2) :- role(P1, C1), role(P2, C2), P1 != P2.
opponent_color(C1, C2) :- role(P1, C1), role(P2, C2), C1 != C2.

% describe the state of the game before any player plays
holds(cell(coord(1..8,1..3), empty),1).

range0_x(1..8).
range1_x(1..7).

range0_y(1..3).
range1_y(1..2).

% even and odd numbers
even(2).
even(4).
even(6).
even(8).

% explain how an action at time T by a player influences the state of the game at time T+1
holds(cell(Coord, Color), T+1) :- time(T), role(Player, Color), does(Player, place_pawn(Coord), T).
holds(cell(Coord_2, Color), T+1) :- time(T), role(Player, Color), does(Player, move(Coord_1, Coord_2), T).
holds(cell(Coord_1, empty), T+1) :- time(T), role(Player, Color), does(Player, move(Coord_1, Coord_2), T).

holds(cell(Coord, empty), T+1) :- time(T), role(Player, Color), does(Player, remove_pawn(Coord), T).

holds(cell(Coord, empty), T+1) :- holds(cell(Coord, empty), T), time(T), not holds(cell(Coord, red), T+1), not holds(cell(Coord, blue), T+1).
holds(cell(Coord, red), T+1) :- holds(cell(Coord, red), T), time(T), not holds(cell(Coord, empty), T+1), not holds(cell(Coord, blue), T+1).
holds(cell(Coord, blue), T+1) :- holds(cell(Coord, blue), T), time(T), not holds(cell(Coord, red), T+1), not holds(cell(Coord, empty), T+1).

% describe what actions are legal or not.
legal(Player, place_pawn(Coord), T) :- holds(cell(Coord,empty),T), role(Player, Color), time(T), can_play(Player, place_pawn, T).


legal(Player, move(Coord_1, Coord_2), T) :- time(T), holds(cell(Coord_1, Color),T), holds(cell(Coord_2,empty),T), role(Player, Color), adjacent(Coord_1,Coord_2), can_play(Player, move, T).


legal(Player, remove_pawn(Coord), T) :- time(T), role(Player, Color), holds(cell(Coord,Color_2),T), opponent_color(Color, Color_2), not is_in_mill(Coord, T), can_play(Player, remove_pawn, T).

legal(Player, remove_pawn(Coord), T) :- time(T), role(Player, Color), holds(cell(Coord,Color_2),T), opponent_player(Player, Player_2), role(Player_2, Color_2), all_in_mill(Player_2, T), can_play(Player, remove_pawn, T).

% adjacent/2 tells when two cells are linked
adjacent(coord(X1,Y1),coord(X1+1,Y1)) :- range1_x(X1), range0_y(Y1).
adjacent(coord(X1+1,Y1),coord(X1,Y1)) :- range1_x(X1), range0_y(Y1).
adjacent(coord(8,Y1),coord(1,Y1)) :- range0_y(Y1).
adjacent(coord(1,Y1),coord(8,Y1)) :- range0_y(Y1).

adjacent(coord(X1,Y1),coord(X1,Y1+1)) :- even(X1), range1_y(Y1).
adjacent(coord(X1,Y1+1),coord(X1,Y1)) :- even(X1), range1_y(Y1).

% is_in_mill(Coord, T) is true iff the cell of coordinates Coord is in the mill of a player.
is_in_mill(Coord_1, T) :- has_mill(Player, mill(Coord_1, Coord_2, Coord_3), T), role(Player, Color), time(T).
is_in_mill(Coord_2, T) :- has_mill(Player, mill(Coord_1, Coord_2, Coord_3), T), role(Player, Color), time(T).
is_in_mill(Coord_3, T) :- has_mill(Player, mill(Coord_1, Coord_2, Coord_3), T), role(Player, Color), time(T).

% has_mill(Player, mill(Coord_1, Coord_2, Coord_3), T) is true iff Player has a mill of his own color and the mill is formed by the following coordinates: Coord_1, Coord_2, Coord_3
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

% all_in_mill/2 tells if a player has all his pawns in mills at time T
all_in_mill(Player, T) :- time(T), role(Player, Color), not not_all_in_mill(Player, T).

not_all_in_mill(Player, T) :- role(Player, Color), holds(cell(Coord,Color),T), not is_in_mill(Coord,T), time(T).



% can_play/3 describe what kind of action a player can perform at each time step
can_play(player1, place_pawn, 1).

%can_play(P1, place_pawn, T+1) :- does(P2, Action, T), time(T), not has_new_mill(P2, T+1), opponent_player(P1, P2), phase(phase(1),T+1).
%can_play(P1, move, T+1) :- does(P2, Action, T), time(T), not has_new_mill(P2, T+1), opponent_player(P1, P2), phase(phase(2),T+1).
%can_play(P1, remove_pawn, T+1) :- does(P1, Action, T), time(T), has_new_mill(P1, T+1), role(P1, C1),  phase(phase(1..2),T+1).

% has_new_mill/2 tells if a player has a mill at time T that he did not have at time T-1.
has_new_mill(Player, T) :- time(T), has_mill(Player, Mill, T), not has_mill(Player, Mill, T-1). 

% phase/2 defines the phase of the game in which we are. phase(Phase, T) is true iff the system is in the phase "Phase" at time T.
phase(phase(1), 1).
phase(phase(N), T+1) :- time(T), phase(phase(N), T), not finished(phase(N), T+1).
phase(phase(N+1), T) :- time(T), finished(phase(N),T).

% finished(Phase, T) is true iff the phase "Phase" is finished at time T.
%finished(phase(1), T) :- time(T), has_pawns(player1, 0, T), has_pawns(player2, 0, T).

% has_pawns(Player,N,T) is true iff Player has still N pawns to place at time T
has_pawns(Player,9,1) :- role(Player, Color).

has_pawns(Player, N-1, T+1) :- time(T), role(Player, Color), has_pawns(Player, N, T), does(Player, place_pawn(coord(X,Y)), T), range0_x(X), range0_y(Y).
has_pawns(Player, N,   T+1) :- time(T), role(Player, Color), has_pawns(Player, N, T), not has_pawns(Player, N-1, T+1).



% conditions to stop the game
terminal(T) :- wins(Player,T), role(Player,Color).

% A player wins if his opponent cannot move or if his opponent has only than 2 pawns left on the board.
wins(P1, T) :- pawns_on_board(P2, N, T), opponent_player(P1, P2), phase(phase(2),T), N<=2, time(T).
wins(P1, T) :- can_play(P2, move, T), opponent_player(P1, P2), time(T), not able_to_play(P2, T).

% pawns_on_board(Player, N, T) is true iff Player has exactly N pawns on the board at time T.
pawns_on_board(Player,0,1) :- role(Player, Color).
pawns_on_board(Player,N+1,T+1) :- role(Player, Color), time(T), pawns_on_board(Player,N,T), does(Player, place_pawn(Coord), T).
pawns_on_board(Player,N-1,T+1) :- role(Player, Color), time(T), pawns_on_board(Player,N,T), does(Player_2, remove_pawn(Coord), T), opponent_player(Player, Player_2).
pawns_on_board(Player,N  ,T+1) :- role(Player, Color), time(T), pawns_on_board(Player,N,T), not pawns_on_board(Player,N+1,T+1), not pawns_on_board(Player,N-1,T+1).

% A player is able to play if he can perform at least one action.
able_to_play(Player, T) :- legal(Player, Action, T).


% only one action is performed at every step
%1{does(Player, M, T) : legal(Player, M, T)}1 :- time(T), not terminated(T).

%terminated(T) :- terminal(T).
%terminated(T+1) :- terminated(T), time(T).

% everything that is done must be legal
%:- does(P,M,T), not legal(P,M,T).

legal(Player, place_pawn(Coord), T) :- extra_place_pawn(Player, place_pawn(Coord), T), can_play(Player, place_pawn, T).
legal(Player, move(Coord_1, Coord_2), T) :- extra_move(Player, move(Coord_1, Coord_2), T), can_play(Player, move, T).
legal(Player, remove_pawn(Coord), T) :- extra_remove_pawn(Player, remove_pawn(Coord), T), can_play(Player, remove_pawn, T).

can_play(Player, place_pawn, T+1) :- can_play_t(Player, place_pawn, T+1), time(T+1).
can_play(Player, move, T+1) :- can_play_t(Player, move, T+1), time(T+1).
can_play(Player, remove_pawn, T+1) :- can_play_t(Player, remove_pawn, T+1), time(T+1).

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
#pos({can_play(player1,place_pawn,1)},{},{ time(1..1).}).
#pos({can_play(player2,place_pawn,2)},{},{does(player1,place_pawn(coord(7,1)),1).
 time(1..2).}).
#pos({can_play(player1,place_pawn,3)},{},{does(player1,place_pawn(coord(7,1)),1).
does(player2,place_pawn(coord(6,1)),2).
 time(1..3).}).
#pos({can_play(player2,place_pawn,4)},{},{does(player1,place_pawn(coord(7,1)),1).
does(player2,place_pawn(coord(6,1)),2).
does(player1,place_pawn(coord(8,1)),3).
 time(1..4).}).
#pos({can_play(player1,place_pawn,5)},{},{does(player1,place_pawn(coord(7,1)),1).
does(player2,place_pawn(coord(6,1)),2).
does(player1,place_pawn(coord(8,1)),3).
does(player2,place_pawn(coord(6,2)),4).
 time(1..5).}).
#pos({},{can_play(player2,place_pawn,6)},{does(player1,place_pawn(coord(7,1)),1).
does(player2,place_pawn(coord(6,1)),2).
does(player1,place_pawn(coord(8,1)),3).
does(player2,place_pawn(coord(6,2)),4).
does(player1,place_pawn(coord(1,1)),5).
 time(1..6).}).
#pos({},{can_play(player1,place_pawn,6)},{does(player1,place_pawn(coord(7,1)),1).
does(player2,place_pawn(coord(6,1)),2).
does(player1,place_pawn(coord(8,1)),3).
does(player2,place_pawn(coord(6,2)),4).
does(player1,place_pawn(coord(1,1)),5).
 time(1..6).}).
#pos({can_play(player1,remove_pawn,6)},{},{does(player1,place_pawn(coord(7,1)),1).
does(player2,place_pawn(coord(6,1)),2).
does(player1,place_pawn(coord(8,1)),3).
does(player2,place_pawn(coord(6,2)),4).
does(player1,place_pawn(coord(1,1)),5).
 time(1..6).}).
#pos({can_play(player2,place_pawn,7)},{},{does(player1,place_pawn(coord(7,1)),1).
does(player2,place_pawn(coord(6,1)),2).
does(player1,place_pawn(coord(8,1)),3).
does(player2,place_pawn(coord(6,2)),4).
does(player1,place_pawn(coord(1,1)),5).
does(player1,remove_pawn(coord(6,2)),6).
 time(1..7).}).
#pos({},{can_play(player2,remove_pawn,8)},{does(player1,place_pawn(coord(7,1)),1).
does(player2,place_pawn(coord(6,1)),2).
does(player1,place_pawn(coord(8,1)),3).
does(player2,place_pawn(coord(6,2)),4).
does(player1,place_pawn(coord(1,1)),5).
does(player1,remove_pawn(coord(6,2)),6).
does(player2,place_pawn(coord(6,2)),7).
 time(1..8).}).
#pos({},{can_play(player1,remove_pawn,8)},{does(player1,place_pawn(coord(7,1)),1).
does(player2,place_pawn(coord(6,1)),2).
does(player1,place_pawn(coord(8,1)),3).
does(player2,place_pawn(coord(6,2)),4).
does(player1,place_pawn(coord(1,1)),5).
does(player1,remove_pawn(coord(6,2)),6).
does(player2,place_pawn(coord(6,2)),7).
 time(1..8).}).
#pos({},{can_play(player2,place_pawn,8)},{does(player1,place_pawn(coord(7,1)),1).
does(player2,place_pawn(coord(6,1)),2).
does(player1,place_pawn(coord(8,1)),3).
does(player2,place_pawn(coord(6,2)),4).
does(player1,place_pawn(coord(1,1)),5).
does(player1,remove_pawn(coord(6,2)),6).
does(player2,place_pawn(coord(6,2)),7).
 time(1..8).}).
#pos({can_play(player1,place_pawn,8)},{},{does(player1,place_pawn(coord(7,1)),1).
does(player2,place_pawn(coord(6,1)),2).
does(player1,place_pawn(coord(8,1)),3).
does(player2,place_pawn(coord(6,2)),4).
does(player1,place_pawn(coord(1,1)),5).
does(player1,remove_pawn(coord(6,2)),6).
does(player2,place_pawn(coord(6,2)),7).
 time(1..8).}).
#pos({can_play(player2,place_pawn,9)},{},{does(player1,place_pawn(coord(7,1)),1).
does(player2,place_pawn(coord(6,1)),2).
does(player1,place_pawn(coord(8,1)),3).
does(player2,place_pawn(coord(6,2)),4).
does(player1,place_pawn(coord(1,1)),5).
does(player1,remove_pawn(coord(6,2)),6).
does(player2,place_pawn(coord(6,2)),7).
does(player1,place_pawn(coord(7,2)),8).
 time(1..9).}).
#pos({can_play(player1,place_pawn,10)},{},{does(player1,place_pawn(coord(7,1)),1).
does(player2,place_pawn(coord(6,1)),2).
does(player1,place_pawn(coord(8,1)),3).
does(player2,place_pawn(coord(6,2)),4).
does(player1,place_pawn(coord(1,1)),5).
does(player1,remove_pawn(coord(6,2)),6).
does(player2,place_pawn(coord(6,2)),7).
does(player1,place_pawn(coord(7,2)),8).
does(player2,place_pawn(coord(8,2)),9).
 time(1..10).}).
#pos({can_play(player2,place_pawn,11)},{},{does(player1,place_pawn(coord(7,1)),1).
does(player2,place_pawn(coord(6,1)),2).
does(player1,place_pawn(coord(8,1)),3).
does(player2,place_pawn(coord(6,2)),4).
does(player1,place_pawn(coord(1,1)),5).
does(player1,remove_pawn(coord(6,2)),6).
does(player2,place_pawn(coord(6,2)),7).
does(player1,place_pawn(coord(7,2)),8).
does(player2,place_pawn(coord(8,2)),9).
does(player1,place_pawn(coord(1,2)),10).
 time(1..11).}).
#pos({can_play(player1,place_pawn,12)},{},{does(player1,place_pawn(coord(7,1)),1).
does(player2,place_pawn(coord(6,1)),2).
does(player1,place_pawn(coord(8,1)),3).
does(player2,place_pawn(coord(6,2)),4).
does(player1,place_pawn(coord(1,1)),5).
does(player1,remove_pawn(coord(6,2)),6).
does(player2,place_pawn(coord(6,2)),7).
does(player1,place_pawn(coord(7,2)),8).
does(player2,place_pawn(coord(8,2)),9).
does(player1,place_pawn(coord(1,2)),10).
does(player2,place_pawn(coord(1,3)),11).
 time(1..12).}).
#pos({},{can_play(player1,place_pawn,13)},{does(player1,place_pawn(coord(7,1)),1).
does(player2,place_pawn(coord(6,1)),2).
does(player1,place_pawn(coord(8,1)),3).
does(player2,place_pawn(coord(6,2)),4).
does(player1,place_pawn(coord(1,1)),5).
does(player1,remove_pawn(coord(6,2)),6).
does(player2,place_pawn(coord(6,2)),7).
does(player1,place_pawn(coord(7,2)),8).
does(player2,place_pawn(coord(8,2)),9).
does(player1,place_pawn(coord(1,2)),10).
does(player2,place_pawn(coord(1,3)),11).
does(player1,place_pawn(coord(8,3)),12).
 time(1..13).}).
#pos({can_play(player2,place_pawn,13)},{},{does(player1,place_pawn(coord(7,1)),1).
does(player2,place_pawn(coord(6,1)),2).
does(player1,place_pawn(coord(8,1)),3).
does(player2,place_pawn(coord(6,2)),4).
does(player1,place_pawn(coord(1,1)),5).
does(player1,remove_pawn(coord(6,2)),6).
does(player2,place_pawn(coord(6,2)),7).
does(player1,place_pawn(coord(7,2)),8).
does(player2,place_pawn(coord(8,2)),9).
does(player1,place_pawn(coord(1,2)),10).
does(player2,place_pawn(coord(1,3)),11).
does(player1,place_pawn(coord(8,3)),12).
 time(1..13).}).
#pos({can_play(player1,place_pawn,14)},{},{does(player1,place_pawn(coord(7,1)),1).
does(player2,place_pawn(coord(6,1)),2).
does(player1,place_pawn(coord(8,1)),3).
does(player2,place_pawn(coord(6,2)),4).
does(player1,place_pawn(coord(1,1)),5).
does(player1,remove_pawn(coord(6,2)),6).
does(player2,place_pawn(coord(6,2)),7).
does(player1,place_pawn(coord(7,2)),8).
does(player2,place_pawn(coord(8,2)),9).
does(player1,place_pawn(coord(1,2)),10).
does(player2,place_pawn(coord(1,3)),11).
does(player1,place_pawn(coord(8,3)),12).
does(player2,place_pawn(coord(7,3)),13).
 time(1..14).}).
#pos({can_play(player2,place_pawn,15)},{},{does(player1,place_pawn(coord(7,1)),1).
does(player2,place_pawn(coord(6,1)),2).
does(player1,place_pawn(coord(8,1)),3).
does(player2,place_pawn(coord(6,2)),4).
does(player1,place_pawn(coord(1,1)),5).
does(player1,remove_pawn(coord(6,2)),6).
does(player2,place_pawn(coord(6,2)),7).
does(player1,place_pawn(coord(7,2)),8).
does(player2,place_pawn(coord(8,2)),9).
does(player1,place_pawn(coord(1,2)),10).
does(player2,place_pawn(coord(1,3)),11).
does(player1,place_pawn(coord(8,3)),12).
does(player2,place_pawn(coord(7,3)),13).
does(player1,place_pawn(coord(6,3)),14).
 time(1..15).}).
#pos({can_play(player1,place_pawn,16)},{},{does(player1,place_pawn(coord(7,1)),1).
does(player2,place_pawn(coord(6,1)),2).
does(player1,place_pawn(coord(8,1)),3).
does(player2,place_pawn(coord(6,2)),4).
does(player1,place_pawn(coord(1,1)),5).
does(player1,remove_pawn(coord(6,2)),6).
does(player2,place_pawn(coord(6,2)),7).
does(player1,place_pawn(coord(7,2)),8).
does(player2,place_pawn(coord(8,2)),9).
does(player1,place_pawn(coord(1,2)),10).
does(player2,place_pawn(coord(1,3)),11).
does(player1,place_pawn(coord(8,3)),12).
does(player2,place_pawn(coord(7,3)),13).
does(player1,place_pawn(coord(6,3)),14).
does(player2,place_pawn(coord(2,3)),15).
 time(1..16).}).
#pos({can_play(player2,place_pawn,17)},{},{does(player1,place_pawn(coord(7,1)),1).
does(player2,place_pawn(coord(6,1)),2).
does(player1,place_pawn(coord(8,1)),3).
does(player2,place_pawn(coord(6,2)),4).
does(player1,place_pawn(coord(1,1)),5).
does(player1,remove_pawn(coord(6,2)),6).
does(player2,place_pawn(coord(6,2)),7).
does(player1,place_pawn(coord(7,2)),8).
does(player2,place_pawn(coord(8,2)),9).
does(player1,place_pawn(coord(1,2)),10).
does(player2,place_pawn(coord(1,3)),11).
does(player1,place_pawn(coord(8,3)),12).
does(player2,place_pawn(coord(7,3)),13).
does(player1,place_pawn(coord(6,3)),14).
does(player2,place_pawn(coord(2,3)),15).
does(player1,place_pawn(coord(2,2)),16).
 time(1..17).}).
#pos({can_play(player1,place_pawn,18)},{},{does(player1,place_pawn(coord(7,1)),1).
does(player2,place_pawn(coord(6,1)),2).
does(player1,place_pawn(coord(8,1)),3).
does(player2,place_pawn(coord(6,2)),4).
does(player1,place_pawn(coord(1,1)),5).
does(player1,remove_pawn(coord(6,2)),6).
does(player2,place_pawn(coord(6,2)),7).
does(player1,place_pawn(coord(7,2)),8).
does(player2,place_pawn(coord(8,2)),9).
does(player1,place_pawn(coord(1,2)),10).
does(player2,place_pawn(coord(1,3)),11).
does(player1,place_pawn(coord(8,3)),12).
does(player2,place_pawn(coord(7,3)),13).
does(player1,place_pawn(coord(6,3)),14).
does(player2,place_pawn(coord(2,3)),15).
does(player1,place_pawn(coord(2,2)),16).
does(player2,place_pawn(coord(2,1)),17).
 time(1..18).}).
#pos({can_play(player2,place_pawn,19)},{},{does(player1,place_pawn(coord(7,1)),1).
does(player2,place_pawn(coord(6,1)),2).
does(player1,place_pawn(coord(8,1)),3).
does(player2,place_pawn(coord(6,2)),4).
does(player1,place_pawn(coord(1,1)),5).
does(player1,remove_pawn(coord(6,2)),6).
does(player2,place_pawn(coord(6,2)),7).
does(player1,place_pawn(coord(7,2)),8).
does(player2,place_pawn(coord(8,2)),9).
does(player1,place_pawn(coord(1,2)),10).
does(player2,place_pawn(coord(1,3)),11).
does(player1,place_pawn(coord(8,3)),12).
does(player2,place_pawn(coord(7,3)),13).
does(player1,place_pawn(coord(6,3)),14).
does(player2,place_pawn(coord(2,3)),15).
does(player1,place_pawn(coord(2,2)),16).
does(player2,place_pawn(coord(2,1)),17).
does(player1,place_pawn(coord(3,3)),18).
 time(1..19).}).
#pos({},{can_play(player1,place_pawn,20)},{does(player1,place_pawn(coord(7,1)),1).
does(player2,place_pawn(coord(6,1)),2).
does(player1,place_pawn(coord(8,1)),3).
does(player2,place_pawn(coord(6,2)),4).
does(player1,place_pawn(coord(1,1)),5).
does(player1,remove_pawn(coord(6,2)),6).
does(player2,place_pawn(coord(6,2)),7).
does(player1,place_pawn(coord(7,2)),8).
does(player2,place_pawn(coord(8,2)),9).
does(player1,place_pawn(coord(1,2)),10).
does(player2,place_pawn(coord(1,3)),11).
does(player1,place_pawn(coord(8,3)),12).
does(player2,place_pawn(coord(7,3)),13).
does(player1,place_pawn(coord(6,3)),14).
does(player2,place_pawn(coord(2,3)),15).
does(player1,place_pawn(coord(2,2)),16).
does(player2,place_pawn(coord(2,1)),17).
does(player1,place_pawn(coord(3,3)),18).
does(player2,place_pawn(coord(5,3)),19).
 time(1..20).}).
#pos({},{can_play(player2,place_pawn,20)},{does(player1,place_pawn(coord(7,1)),1).
does(player2,place_pawn(coord(6,1)),2).
does(player1,place_pawn(coord(8,1)),3).
does(player2,place_pawn(coord(6,2)),4).
does(player1,place_pawn(coord(1,1)),5).
does(player1,remove_pawn(coord(6,2)),6).
does(player2,place_pawn(coord(6,2)),7).
does(player1,place_pawn(coord(7,2)),8).
does(player2,place_pawn(coord(8,2)),9).
does(player1,place_pawn(coord(1,2)),10).
does(player2,place_pawn(coord(1,3)),11).
does(player1,place_pawn(coord(8,3)),12).
does(player2,place_pawn(coord(7,3)),13).
does(player1,place_pawn(coord(6,3)),14).
does(player2,place_pawn(coord(2,3)),15).
does(player1,place_pawn(coord(2,2)),16).
does(player2,place_pawn(coord(2,1)),17).
does(player1,place_pawn(coord(3,3)),18).
does(player2,place_pawn(coord(5,3)),19).
 time(1..20).}).
#pos({can_play(player1,move,20)},{},{does(player1,place_pawn(coord(7,1)),1).
does(player2,place_pawn(coord(6,1)),2).
does(player1,place_pawn(coord(8,1)),3).
does(player2,place_pawn(coord(6,2)),4).
does(player1,place_pawn(coord(1,1)),5).
does(player1,remove_pawn(coord(6,2)),6).
does(player2,place_pawn(coord(6,2)),7).
does(player1,place_pawn(coord(7,2)),8).
does(player2,place_pawn(coord(8,2)),9).
does(player1,place_pawn(coord(1,2)),10).
does(player2,place_pawn(coord(1,3)),11).
does(player1,place_pawn(coord(8,3)),12).
does(player2,place_pawn(coord(7,3)),13).
does(player1,place_pawn(coord(6,3)),14).
does(player2,place_pawn(coord(2,3)),15).
does(player1,place_pawn(coord(2,2)),16).
does(player2,place_pawn(coord(2,1)),17).
does(player1,place_pawn(coord(3,3)),18).
does(player2,place_pawn(coord(5,3)),19).
 time(1..20).}).
#pos({},{can_play(player1,move,21)},{does(player1,place_pawn(coord(7,1)),1).
does(player2,place_pawn(coord(6,1)),2).
does(player1,place_pawn(coord(8,1)),3).
does(player2,place_pawn(coord(6,2)),4).
does(player1,place_pawn(coord(1,1)),5).
does(player1,remove_pawn(coord(6,2)),6).
does(player2,place_pawn(coord(6,2)),7).
does(player1,place_pawn(coord(7,2)),8).
does(player2,place_pawn(coord(8,2)),9).
does(player1,place_pawn(coord(1,2)),10).
does(player2,place_pawn(coord(1,3)),11).
does(player1,place_pawn(coord(8,3)),12).
does(player2,place_pawn(coord(7,3)),13).
does(player1,place_pawn(coord(6,3)),14).
does(player2,place_pawn(coord(2,3)),15).
does(player1,place_pawn(coord(2,2)),16).
does(player2,place_pawn(coord(2,1)),17).
does(player1,place_pawn(coord(3,3)),18).
does(player2,place_pawn(coord(5,3)),19).
does(player1,move(coord(3,3),coord(4,3)),20).
 time(1..21).}).
finished(phase(1),V0) :- has_pawns(player2,0, V0).
