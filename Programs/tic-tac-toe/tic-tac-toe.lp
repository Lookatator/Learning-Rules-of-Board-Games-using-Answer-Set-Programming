% initialize the two players
role(player1, x).
role(player2, o).

% initialize the time
time(1..10).

% describe the state of the game before any player plays
holds(cell(coord(1..3,1..3), empty),1).

% describe what actions are legal or not.
legal(P, fill(X), T) :- holds(cell(X,empty), T), role(P, S), time(T).

% explain how an action by a player influences the state of the game
holds(cell(X,S),T+1) :- does(P,fill(X),T), role(P,S).
holds(cell(X,A),T+1) :- holds(cell(X,A),T), not does(player1,fill(X),T), not does(player2,fill(X),T), time(T). 

% conditions to stop the game
terminal(T) :- wins(P,T), role(P,S).
terminal(T) :- all_filled(T).

wins(P,T) :- role(P,S), full_line(S,T), not terminated(T-1).
wins(P,T) :- role(P,S), full_column(S,T), not terminated(T-1).
wins(P,T) :- role(P,S), full_diagonal(S,T), not terminated(T-1).

all_filled(T) :- time(T), not holds(cell(X,empty),T) : X=coord(1..3,1..3). 

% describe the different goals that a player may fulfill
goal(P, 100, T) :- wins(P,T).
goal(P, 50, T) :- role(P,S), time(T), terminal(T), not wins(P,T), not goal(P, 0, T).
goal(P, 0, T) :- role(P,S), not wins(P,T), wins(P2,T), P2 != P.

full_line(S,T) :- role(P,S), time(T), L=1..3, holds(cell(X,S),T) : X=coord(L,1..3).

full_column(S,T) :- role(P,S), time(T), C=1..3, holds(cell(X,S),T) : X=coord(1..3,C).

full_diagonal(S,T) :- role(P,S), time(T), holds(cell(coord(N,N),S),T) : N=1..3.
full_diagonal(S,T) :- role(P,S), time(T), holds(cell(coord(N,4-N),S),T) : N=1..3.

% defining the move domain
move_domain(fill(coord(1..3,1..3))).

% only one action is performed at every step
1{does(P,M,T) : move_domain(M) , role(P,S)}1 :- time(T), not terminated(T).
terminated(T) :- terminal(T).
terminated(T+1) :- terminated(T), time(T).

% everything that is done must be legal
:- does(P,M,T), not legal(P,M,T).

% the game has to stop
:- 0{terminated(T) : time(T)}0.

%% turn-based game
% a player cannot play twice
:- does(P,M1,T), does(P,M2,T+1).

% the first player starts
1{does(player1,M,1) : move_domain(M)}1.

:~ time(T), not wins(player1,T). [(-T)@1]
:- time(T), wins(player2,T).
:- not 1{wins(player1,T) : time(T)}1.

% describing the game
does(player1, fill(coord(2,2)),1).
does(player2, fill(coord(1,2)),2).
does(player1, fill(coord(1,1)),3).
does(player2, fill(coord(3,2)),4).

% hypothesis space
does(player1, M, 5) :- move_domain(M), rule(p1_t5,M).
does(player1, M1, 7) :- does(player2, M2, 6), move_domain(M1), move_domain(M2), rule(p1_t7,M2,M1).
1{rule(p1_t5, M) : move_domain(M)}1. 
1{rule(p1_t7, M2, M1) : move_domain(M1)}1 :- move_domain(M2).
:- wins(player2,7).
:- wins(player2,9).
% :- not wins(player1,8), does(player2, M, 6), move_domain(M).
:- wins(player1,6).

%#hide.
%#show holds(cell(X,S),T) : S!=empty.
%#show full_line/2.
%#show full_column/2.
%#show full_diagonal/2.
#show wins/2.
%#show terminal/1.
%#show terminated/1.
%#show goal/3.
%#show terminal/1.
%#show does/3.
#show rule(p1_t5, M) : rule(p1_t5, M).
#show rule(p1_t7, M2, M1) : rule(p1_t7, M2, M1).

