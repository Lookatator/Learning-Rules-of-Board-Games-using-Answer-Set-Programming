#modeh(finished(phase(1),var(t))).
#modeb(2, has_pawns(const(player),const(n), var(t))).
#modeb(has_mill(var(p),var(m),var(t))).
#bias(":- constraint.").
#bias(":- body(has_pawns(P1,N1,T)), body(has_pawns(P2,N2,T)), N2>N1+1.").
#bias(":- body(has_pawns(P1,N1,T)), body(has_pawns(P2,N2,T)), N1>N2+1.").
#bias(":- body(has_pawns(P1,N1,T)), body(naf(has_pawns(P2,N2,T))), N2>N1+1.").
#bias(":- body(has_pawns(P1,N1,T)), body(naf(has_pawns(P2,N2,T))), N1>N2+1.").
#bias(":- body(has_pawns(P1,N1,T)), body(has_pawns(P1,N2,T)), N2!=N1.").
#bias(":- body(has_pawns(P1,N1,T)), body(naf(has_pawns(P1,N2,T))).").
#bias(":- body(naf(has_pawns(P1,N1,T))), body(naf(has_pawns(P1,N2,T))), N2!=N1.").

#constant(n, 0).
%#constant(n, 1).
%#constant(n, 2).
%#constant(n, 3).
%#constant(n, 4).
#constant(n, 5).
%#constant(n, 6).
%#constant(n, 7).
%#constant(n, 8).
%#constant(n, 9).

#constant(player, player1).
#constant(player, player2).