% initialize the two players
role(player1, x).
role(player2, o).

% initialize the time
time(1..5).

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

wins(P) :- wins(P,T).

all_filled(T) :- time(T), not holds(cell(coord(1,1),empty),T),
			not holds(cell(coord(1,2),empty),T),
			not holds(cell(coord(1,3),empty),T),
			not holds(cell(coord(2,1),empty),T),
			not holds(cell(coord(2,2),empty),T),
			not holds(cell(coord(2,3),empty),T),
			not holds(cell(coord(3,1),empty),T),
			not holds(cell(coord(3,2),empty),T),
			not holds(cell(coord(3,3),empty),T).

% describe the different goals that a player may fulfill
goal(P, 100, T) :- wins(P,T).
goal(P, 50, T) :- role(P,S), time(T), terminal(T), not wins(P,T), not goal(P, 0, T).
goal(P, 0, T) :- role(P,S), not wins(P,T), wins(P2,T), P2 != P.

full_line(S,T) :- role(P,S), time(T), L=1..3, holds(cell(coord(L,1),S),T), holds(cell(coord(L,2),S),T), holds(cell(coord(L,3),S),T).

full_column(S,T) :- role(P,S), time(T), C=1..3, holds(cell(coord(1,C),S),T), holds(cell(coord(2,C),S),T), holds(cell(coord(3,C),S),T) .

full_diagonal(S,T) :- role(P,S), time(T), holds(cell(coord(1,1),S),T), holds(cell(coord(2,2),S),T), holds(cell(coord(3,3),S),T).
full_diagonal(S,T) :- role(P,S), time(T), holds(cell(coord(1,3),S),T), holds(cell(coord(2,2),S),T), holds(cell(coord(3,1),S),T).

% defining the move domain
move_domain(fill(coord(1..3,1..3))).

% only one action is performed at every step
1{does(player1,fill(coord(1,1)),T) ; 
  does(player1,fill(coord(1,2)),T) ; 
  does(player1,fill(coord(1,3)),T) ; 
  does(player1,fill(coord(2,1)),T) ; 
  does(player1,fill(coord(2,2)),T) ; 
  does(player1,fill(coord(2,3)),T) ; 
  does(player1,fill(coord(3,1)),T) ; 
  does(player1,fill(coord(3,2)),T) ; 
  does(player1,fill(coord(3,3)),T) ; 
  does(player2,fill(coord(1,1)),T) ; 
  does(player2,fill(coord(1,2)),T) ; 
  does(player2,fill(coord(1,3)),T) ; 
  does(player2,fill(coord(2,1)),T) ; 
  does(player2,fill(coord(2,2)),T) ; 
  does(player2,fill(coord(2,3)),T) ; 
  does(player2,fill(coord(3,1)),T) ; 
  does(player2,fill(coord(3,2)),T) ; 
  does(player2,fill(coord(3,3)),T)}1 :- time(T), not terminated(T).
terminated(T) :- terminal(T).
terminated(T+1) :- terminated(T), time(T).

% everything that is done must be legal
:- does(P,M,T), not legal(P,M,T).

% the game has to stop
%:- 0{terminated(T) : time(T)}0.

%% turn-based game
% a player cannot play twice
:- does(P,M1,T), does(P,M2,T+1).

% the first player starts
%1{does(player1,M,1) : move_domain(M)}1.

%same_row(coord(Y,X1),coord(Y,X2)) :- X1!=X2, X1=1..3, X2=1..3, Y=1..3.
%same_column(coord(Y1,X),coord(Y2,X)) :- Y1!=Y2, Y1=1..3, Y2=1..3, X=1..3.
%same_diagonal(coord(X1,X1),coord(X2,X2)) :- X1!=X2, X1=1..3, X2=1..3.

same_row(coord(1,1),coord(1,2)).
same_row(coord(1,1),coord(1,3)).
same_row(coord(2,1),coord(2,2)).
same_row(coord(2,1),coord(2,3)).
same_row(coord(3,1),coord(3,2)).
same_row(coord(3,1),coord(3,3)).
same_row(coord(1,2),coord(1,1)).
same_row(coord(1,2),coord(1,3)).
same_row(coord(2,2),coord(2,1)).
same_row(coord(2,2),coord(2,3)).
same_row(coord(3,2),coord(3,1)).
same_row(coord(3,2),coord(3,3)).
same_row(coord(1,3),coord(1,1)).
same_row(coord(1,3),coord(1,2)).
same_row(coord(2,3),coord(2,1)).
same_row(coord(2,3),coord(2,2)).
same_row(coord(3,3),coord(3,1)).
same_row(coord(3,3),coord(3,2)).
same_column(coord(1,1),coord(2,1)).
same_column(coord(1,1),coord(3,1)).
same_column(coord(1,2),coord(2,2)).
same_column(coord(1,2),coord(3,2)).
same_column(coord(1,3),coord(2,3)).
same_column(coord(1,3),coord(3,3)).
same_column(coord(2,1),coord(1,1)).
same_column(coord(2,1),coord(3,1)).
same_column(coord(2,2),coord(1,2)).
same_column(coord(2,2),coord(3,2)).
same_column(coord(2,3),coord(1,3)).
same_column(coord(2,3),coord(3,3)).
same_column(coord(3,1),coord(1,1)).
same_column(coord(3,1),coord(2,1)).
same_column(coord(3,2),coord(1,2)).
same_column(coord(3,2),coord(2,2)).
same_column(coord(3,3),coord(1,3)).
same_column(coord(3,3),coord(2,3)).
same_diagonal(coord(1,1),coord(2,2)).
same_diagonal(coord(1,1),coord(3,3)).
same_diagonal(coord(2,2),coord(1,1)).
same_diagonal(coord(2,2),coord(3,3)).
same_diagonal(coord(3,3),coord(1,1)).
same_diagonal(coord(3,3),coord(2,2)).

% describing the game
:- not does(player1, fill(coord(2,2)),1).
:- not does(player2, fill(coord(1,2)),2).
:- not does(player1, fill(coord(1,1)),3).
:- not does(player2, fill(coord(3,3)),4).


#show.
#show does(P,X,5) : does(P,X,5).

