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

same_row((Y,X1),(Y,X2)) :- X1!=X2, cell(coord(Y,X1), S1), cell(coord(Y,X2), S2).

same_column((Y1,X),(Y2,X)) :- Y1!=Y2, cell(coord(Y1,X), S1), cell(coord(Y2,X), S2).

same_diagonal((Y1,X1),(Y2,X2)) :- X1!=X2, Y1-Y2==X1-X2, cell(coord(Y1,X1), S1), cell(coord(Y2,X2), S2).


% describing the game
does(player1, fill(coord(2,2)),1).
does(player2, fill(coord(1,2)),2).
does(player1, fill(coord(1,1)),3).
does(player2, fill(coord(3,3)),4).

%does(player1, fill(coord(2,1)),7) :- does(player2, Z,6), not Z=fill(coord(2,1)). 
%does(player1, fill(coord(1,3)),7) :- does(player2, fill(coord(2,1)),6). 
%:- not wins(player1, 8).

%does(player1,X,5) :- legal(player1, X, 5), rule((m1),(X)).
%does(player1,Z,7) :- legal(player1, Z, 7), legal(player2,Y,6), does(player2, Y, 6), rule((m2,m3,2),(Z,Y)).
%does(player1,X,7) :- legal(player1, X, 7), legal(player2,Y,6), not does(player2, Y, 6), rule((m2,m4,2),(X,Y)).

does(player1,X,5) :- legal(player1,X,5), rule((m1),(X)).
does(player1,Z,7) :- legal(player1,Z,7), legal(player2,Y,6), does(player2, Y, 6), rule((m2,m3,2),(Z,Y)).
does(player1,X,7) :- legal(player1,X,7), legal(player2,Y,6), not does(player2, Y, 6), rule((m2,m4,2),(X,Y)).


% :- not 1{rule((m1),(X)) : move_domain(X)}1.



rule1 :- rule((m1),(fill(coord(X,Y)))).
:- not rule1.
:- rule((m1),(fill(coord(X1,Y1)))), rule((m1),(fill(coord(X2,Y2)))), g(X1, Y1)< g(X2, Y2).

rule2 :- rule((m2,m3,2),(fill(coord(X,Y)),fill(coord(Z,T)))).
:- not rule2.
:- rule((m2,m3,2),(fill(coord(X1,Y1)),fill(coord(Z1,T1)))), 
	rule((m2,m3,2),(fill(coord(X2,Y2)),fill(coord(Z2,T2)))),
	g(X1, Y1, Z1, T1)< g(X2, Y2, Z2, T2).

rule3 :- rule((m2,m4,2),(fill(coord(X,Y)),fill(coord(Z,T)))).
:- not rule3.
:- rule((m2,m4,2),(fill(coord(X1,Y1)),fill(coord(Z1,T1)))), 
	rule((m2,m4,2),(fill(coord(X2,Y2)),fill(coord(Z2,T2)))),
	g(X1, Y1, Z1, T1)< g(X2, Y2, Z2, T2).


rule4(Y) :- rule((m2,m3,2),(X,Y)).
:- rule((m2,m4,2),(X,Y)), not rule4(Y).


% constraints to reduce the computation time
:- rule((m1),(fill(coord(X,Y)))), not legal(player1,fill(coord(X,Y)),5).
:- rule((m2,m3,2),(fill(coord(X,Y)),fill(coord(Z,T)))), does(player2, fill(coord(Z,T)), 6), not legal(player1, fill(coord(X,Y)),7).
:- rule((m2,m3,2),(fill(coord(X,Y)),fill(coord(Z,T)))), not legal(player2, fill(coord(Z,T)),6).
:- rule((m2,m4,2),(fill(coord(X,Y)),fill(coord(Z,T)))), not does(player2, fill(coord(Z,T)), 6), not legal(player1, fill(coord(X,Y)),7).
:- rule((m2,m4,2),(fill(coord(X,Y)),fill(coord(Z,T)))), not legal(player2, fill(coord(Z,T)),6).

% hypothesis space
#modeh(rule((m1),(fill(coord(const(x),const(x)))))).
#modeh(rule((m2,m3,2),( fill(coord(const(x),const(x))) , fill(coord(const(x),const(x))) ))).
#modeh(rule((m2,m4,2),( fill(coord(const(x),const(x))) , fill(coord(const(x),const(x))) ))).

#constant(x, 1).
#constant(x, 2).
#constant(x, 3).

%:- rule((m2,m4,2),( fill(coord(3,1)) , fill(coord(3,1)) )), rule((m1),(fill(coord(2,1)))), rule((m2,m3,2),( fill(coord(2,3)) , fill(coord(3,1)) )).
%:- rule((m2,m4,2),( fill(coord(2,3)) , fill(coord(2,3)) )), rule((m1),(fill(coord(2,1)))), rule((m2,m3,2),( fill(coord(3,1)) , fill(coord(2,3)) )).
%:- rule((m2,m3,2),( fill(coord(1,3)) , fill(coord(2,1)) )), rule((m1),(fill(coord(3,1)))), rule((m2,m4,2),( fill(coord(2,1)) , fill(coord(2,1)) )).
%:- rule((m2,m3,2),( fill(coord(2,1)) , fill(coord(1,3)) )), rule((m2,m4,2),( fill(coord(1,3)) , fill(coord(1,3)) )), rule((m1),(fill(coord(3,1)))).

%#pos({wins(player1,8)},{},{:- rule((m2,m3,2),(fill(coord(X,Y)),fill(coord(Z,T)))), not does(player2, fill(coord(Z,T)), 6).}).
#pos({},{},{:- rule((m2,m4,2),(fill(coord(X,Y)),fill(coord(Z,T)))), not does(player2, fill(coord(X,Y)), 6).}).
%#pos({wins(player1,8)},{}).
#neg({},{wins(player1,8)}).

%1 ~ rule((m2,m4,2),( fill(coord(2,3)) , fill(coord(1,3)) )).
%1 ~ rule((m1),(fill(coord(2,1)))).
%1 ~ rule((m2,m3,2),( fill(coord(2,3)) , fill(coord(1,3)) )).

%:- rule((m2,m4,2),( fill(coord(2,3)) , fill(coord(1,3)) )), rule((m1),(fill(coord(2,1)))), rule((m2,m3,2),( fill(coord(2,3)) , fill(coord(1,3)) )).

%1 ~ rule((m1),(fill(coord(2,1)))).
%1 ~ rule((m2,m3,2),(fill(coord(2,3)),fill(coord(3,1)))).
%1 ~ rule((m2,m4,2),(fill(coord(3,1)),fill(coord(3,1)))).

#max_penalty(4).
%#disallow_multiple_head_variables.



%idees : script python generer hypotheses, weak constraints pour indiquer préférences 
