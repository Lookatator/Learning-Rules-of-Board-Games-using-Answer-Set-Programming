% initialize the two players

role(player1, red).
role(player2, blue).

% initialize the time
time(1..3).

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

possible_move(coord(X1,X2),coord(Y1,Y2)) :- X1==Y1-1, X2==Y2-1, X1=0..3, X2=0..3, Y1=1..4, Y2=1..4.
possible_move(coord(X1,X2),coord(Y1,Y2)) :- X1==Y1-1, X2==Y2+1, X1=0..3, X2=1..4, Y1=1..4, Y2=0..3.
possible_move(coord(X1,X2),coord(Y1,Y2)) :- X1==Y1+1, X2==Y2-1, X1=1..4, X2=0..3, Y1=0..3, Y2=1..4.
possible_move(coord(X1,X2),coord(Y1,Y2)) :- X1==Y1+1, X2==Y2+1, X1=1..4, X2=1..4, Y1=0..3, Y2=0..3.

% describe what actions are legal or not.
legal(P, move(X,Y), T) :- possible_move(X,Y), holds(cell(X,S), T), holds(cell(Y,empty), T), role(P, S), time(T).

% explain how an action by a player influences the state of the game
holds(cell(Y,S),T+1) :- does(P,move(X,Y),T), role(P,S).
holds(cell(X,empty),T+1) :- does(P,move(X,Y),T), role(P,S).
holds(cell(X,A),T+1) :- holds(cell(X,A),T), time(T),  
		not does(P,move(X,Y),T) : possible_move(X,Y), role(P,S); 
		not does(P,move(Z,X),T) : possible_move(Z,X), role(P,S).

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

% only one action is performed at every step
1{does(P,M,T) : move_domain(M) , role(P,S)}1 :- time(T), not terminated(T).
terminated(T) :- terminal(T).
terminated(T+1) :- terminated(T), time(T).

% everything that is done must be legal
:- does(P,M,T), not legal(P,M,T).

% :- 0{terminated(T) : time(T)}0.

%% turn-based game
% a player cannot play twice
:- does(P,M1,T), does(P,M2,T+1).

% the first player starts
1{does(player1,M,1) : move_domain(M)}1.

:- not holds(cell(coord(2,1),red),3).
:- not holds(cell(coord(3,2),blue),3).


%#hide.
#show holds/2.
%#show wins/2.
%#show terminal/1.
%#show terminated/1.
%#show goal/3.
%#show terminal/1.
%#show legal(P,M,1) : legal(P,M,1).
#show does/3.
%#show possible_move/2.


