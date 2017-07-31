#pos(pos0,{does(player1,move(coord(0,0),coord(1,1)),1)},{},{
time(1).
}).
#pos(pos1,{does(player1,move(coord(0,1),coord(1,2)),1)},{},{
time(1).
}).
#pos(pos2,{does(player1,move(coord(0,2),coord(1,1)),1)},{},{
time(1).
}).
#pos(pos3,{does(player1,move(coord(0,2),coord(1,3)),1)},{},{
time(1).
}).
#pos(pos4,{does(player1,move(coord(0,3),coord(1,2)),1)},{},{
time(1).
}).
#pos(pos5,{does(player1,move(coord(0,4),coord(1,3)),1)},{},{
time(1).
}).
#pos(pos6,{does(player1,move(coord(1,0),coord(2,1)),1)},{},{
time(1).
}).
#pos(pos7,{does(player1,move(coord(1,4),coord(2,3)),1)},{},{
time(1).
}).
#brave_ordering(ord0@1, pos6, pos0).
#brave_ordering(ord1@1, pos6, pos1).
#brave_ordering(ord2@1, pos6, pos2).
#brave_ordering(ord3@1, pos6, pos3).
#brave_ordering(ord4@1, pos6, pos4).
#brave_ordering(ord5@1, pos6, pos5).
#brave_ordering(ord7@1, pos6, pos7).
#pos(pos9,{does(player1,move(coord(2,1),coord(1,0)),3)},{},{
does(player1, move(coord(1,0),coord(2,1)),1).
does(player2, move(coord(4,1),coord(3,2)),2).
time(1..3).
}).
#pos(pos10,{does(player1,move(coord(2,1),coord(1,2)),3)},{},{
does(player1, move(coord(1,0),coord(2,1)),1).
does(player2, move(coord(4,1),coord(3,2)),2).
time(1..3).
}).
#pos(pos11,{does(player1,move(coord(0,1),coord(1,0)),3)},{},{
does(player1, move(coord(1,0),coord(2,1)),1).
does(player2, move(coord(4,1),coord(3,2)),2).
time(1..3).
}).
#pos(pos12,{does(player1,move(coord(1,4),coord(2,3)),3)},{},{
does(player1, move(coord(1,0),coord(2,1)),1).
does(player2, move(coord(4,1),coord(3,2)),2).
time(1..3).
}).
#pos(pos13,{does(player1,move(coord(0,3),coord(1,2)),3)},{},{
does(player1, move(coord(1,0),coord(2,1)),1).
does(player2, move(coord(4,1),coord(3,2)),2).
time(1..3).
}).
#pos(pos14,{does(player1,move(coord(0,4),coord(1,3)),3)},{},{
does(player1, move(coord(1,0),coord(2,1)),1).
does(player2, move(coord(4,1),coord(3,2)),2).
time(1..3).
}).
#pos(pos15,{does(player1,move(coord(0,1),coord(1,2)),3)},{},{
does(player1, move(coord(1,0),coord(2,1)),1).
does(player2, move(coord(4,1),coord(3,2)),2).
time(1..3).
}).
#pos(pos16,{does(player1,move(coord(0,0),coord(1,1)),3)},{},{
does(player1, move(coord(1,0),coord(2,1)),1).
does(player2, move(coord(4,1),coord(3,2)),2).
time(1..3).
}).
#pos(pos17,{does(player1,move(coord(0,2),coord(1,1)),3)},{},{
does(player1, move(coord(1,0),coord(2,1)),1).
does(player2, move(coord(4,1),coord(3,2)),2).
time(1..3).
}).
#pos(pos18,{does(player1,move(coord(0,2),coord(1,3)),3)},{},{
does(player1, move(coord(1,0),coord(2,1)),1).
does(player2, move(coord(4,1),coord(3,2)),2).
time(1..3).
}).
#brave_ordering(ord9@1, pos18, pos9).
#brave_ordering(ord10@1, pos18, pos10).
#brave_ordering(ord11@1, pos18, pos11).
#brave_ordering(ord12@1, pos18, pos12).
#brave_ordering(ord13@1, pos18, pos13).
#brave_ordering(ord14@1, pos18, pos14).
#brave_ordering(ord15@1, pos18, pos15).
#brave_ordering(ord16@1, pos18, pos16).
#brave_ordering(ord17@1, pos18, pos17).
#pos(pos20,{does(player1,move(coord(2,1),coord(1,0)),5)},{},{
does(player1, move(coord(1,0),coord(2,1)),1).
does(player2, move(coord(4,1),coord(3,2)),2).
does(player1, move(coord(0,2),coord(1,3)),3).
does(player2, move(coord(4,2),coord(3,3)),4).
time(1..5).
}).
#pos(pos21,{does(player1,move(coord(1,4),coord(2,3)),5)},{},{
does(player1, move(coord(1,0),coord(2,1)),1).
does(player2, move(coord(4,1),coord(3,2)),2).
does(player1, move(coord(0,2),coord(1,3)),3).
does(player2, move(coord(4,2),coord(3,3)),4).
time(1..5).
}).
#pos(pos22,{does(player1,move(coord(1,3),coord(0,2)),5)},{},{
does(player1, move(coord(1,0),coord(2,1)),1).
does(player2, move(coord(4,1),coord(3,2)),2).
does(player1, move(coord(0,2),coord(1,3)),3).
does(player2, move(coord(4,2),coord(3,3)),4).
time(1..5).
}).
#pos(pos23,{does(player1,move(coord(1,3),coord(2,2)),5)},{},{
does(player1, move(coord(1,0),coord(2,1)),1).
does(player2, move(coord(4,1),coord(3,2)),2).
does(player1, move(coord(0,2),coord(1,3)),3).
does(player2, move(coord(4,2),coord(3,3)),4).
time(1..5).
}).
#pos(pos24,{does(player1,move(coord(0,1),coord(1,0)),5)},{},{
does(player1, move(coord(1,0),coord(2,1)),1).
does(player2, move(coord(4,1),coord(3,2)),2).
does(player1, move(coord(0,2),coord(1,3)),3).
does(player2, move(coord(4,2),coord(3,3)),4).
time(1..5).
}).
#pos(pos25,{does(player1,move(coord(0,1),coord(1,2)),5)},{},{
does(player1, move(coord(1,0),coord(2,1)),1).
does(player2, move(coord(4,1),coord(3,2)),2).
does(player1, move(coord(0,2),coord(1,3)),3).
does(player2, move(coord(4,2),coord(3,3)),4).
time(1..5).
}).
#pos(pos26,{does(player1,move(coord(0,3),coord(1,2)),5)},{},{
does(player1, move(coord(1,0),coord(2,1)),1).
does(player2, move(coord(4,1),coord(3,2)),2).
does(player1, move(coord(0,2),coord(1,3)),3).
does(player2, move(coord(4,2),coord(3,3)),4).
time(1..5).
}).
#pos(pos27,{does(player1,move(coord(1,3),coord(2,4)),5)},{},{
does(player1, move(coord(1,0),coord(2,1)),1).
does(player2, move(coord(4,1),coord(3,2)),2).
does(player1, move(coord(0,2),coord(1,3)),3).
does(player2, move(coord(4,2),coord(3,3)),4).
time(1..5).
}).
#pos(pos28,{does(player1,move(coord(0,0),coord(1,1)),5)},{},{
does(player1, move(coord(1,0),coord(2,1)),1).
does(player2, move(coord(4,1),coord(3,2)),2).
does(player1, move(coord(0,2),coord(1,3)),3).
does(player2, move(coord(4,2),coord(3,3)),4).
time(1..5).
}).
#pos(pos29,{does(player1,move(coord(2,1),coord(1,2)),5)},{},{
does(player1, move(coord(1,0),coord(2,1)),1).
does(player2, move(coord(4,1),coord(3,2)),2).
does(player1, move(coord(0,2),coord(1,3)),3).
does(player2, move(coord(4,2),coord(3,3)),4).
time(1..5).
}).
#brave_ordering(ord20@1, pos23, pos20).
#brave_ordering(ord21@1, pos23, pos21).
#brave_ordering(ord22@1, pos23, pos22).
#brave_ordering(ord24@1, pos23, pos24).
#brave_ordering(ord25@1, pos23, pos25).
#brave_ordering(ord26@1, pos23, pos26).
#brave_ordering(ord27@1, pos23, pos27).
#brave_ordering(ord28@1, pos23, pos28).
#brave_ordering(ord29@1, pos23, pos29).
