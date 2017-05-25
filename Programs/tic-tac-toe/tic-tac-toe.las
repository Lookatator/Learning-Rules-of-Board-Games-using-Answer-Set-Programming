% initialize the two players
role(player1, x).
role(player2, o).

% initialize the time
time(1..6).

% describe the state of the game before any player plays
holds(cell(coord(1..3,1..3), empty),1).

% describe what actions are legal or not.
legal(P, fill(X), T) :- holds(cell(X,empty), T), role(P, S), time(T).

% explain how an action by a player influences the state of the game
holds(cell(X,S),T+1) :- does(P,fill(X),T), role(P,S).
holds(cell(X,A),T+1) :- holds(cell(X,A),T), not does(player1,fill(X),T), not does(player2,fill(X),T), time(T). 

% conditions to stop the game
terminal(T) :- wins(P,T), role(P,S).
% terminal(T) :- all_filled(T).

wins(P,T) :- role(P,S), full_line(S,T), not terminated(T-1).
wins(P,T) :- role(P,S), full_column(S,T), not terminated(T-1).
wins(P,T) :- role(P,S), full_diagonal(S,T), not terminated(T-1).

%all_filled(T) :- time(T), not holds(cell(X,empty),T) : X=coord(1..3,1..3). 

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
1{does(player1,fill(coord(1..3,1..3)),T) ; does(player2,fill(coord(1..3,1..3)),T)}1 :- time(T), not terminated(T).
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



% describing the game
does(player1, fill(coord(2,2)),1).
does(player2, fill(coord(1,2)),2).
does(player1, fill(coord(1,1)),3).
does(player2, fill(coord(3,2)),4).

% hypothesis space
%#modeh(does(player1,fill(coord(const(x),const(x))),5)).
#modeh(does(player1,fill(coord(3,3)),5)).
%#modeh(does(player1,fill(coord(const(x),const(x))),7)).
%#modeb(1, does(player2,fill(coord(const(x),const(x))),6)).
%#bias(":- head(does(player1,A,5)), not legal(player1,A,5).").
#bias(":- head(does(player1,A,T1)), body(does(player2,A,T2)), T1<T2.").
#bias(":- head(does(player1,A,T1)), body(naf(does(player2,A,T2))), T1<T2.").
#bias(":- body(naf(does(player2,A,T2))).").
#bias(":- constraint.").
#constant(x, 1).
#constant(x, 2).
#constant(x, 3).
#max_penalty(10).
#disallow_multiple_head_variables.

#pos(a, {},{}).
#neg(b, {}, {wins(player1,6)}).
%idees : script python generer hypotheses, weak constraints pour indiquer préférences 
