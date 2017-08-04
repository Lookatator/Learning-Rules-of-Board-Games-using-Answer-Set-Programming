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
#brave_ordering(ord0@1, pos7, pos0).
#brave_ordering(ord1@1, pos7, pos1).
#brave_ordering(ord2@1, pos7, pos2).
#brave_ordering(ord3@1, pos7, pos3).
#brave_ordering(ord4@1, pos7, pos4).
#brave_ordering(ord5@1, pos7, pos5).
#brave_ordering(ord6@1, pos6, pos0).
#brave_ordering(ord7@1, pos6, pos1).
#brave_ordering(ord8@1, pos6, pos2).
#brave_ordering(ord9@1, pos6, pos3).
#brave_ordering(ord10@1, pos6, pos4).
#brave_ordering(ord11@1, pos6, pos5).
#pos(pos9,{does(player1,move(coord(0,0),coord(1,1)),1)},{},{
time(1).
}).
#pos(pos10,{does(player1,move(coord(0,1),coord(1,2)),1)},{},{
time(1).
}).
#pos(pos11,{does(player1,move(coord(0,2),coord(1,1)),1)},{},{
time(1).
}).
#pos(pos12,{does(player1,move(coord(0,2),coord(1,3)),1)},{},{
time(1).
}).
#pos(pos13,{does(player1,move(coord(0,3),coord(1,2)),1)},{},{
time(1).
}).
#pos(pos14,{does(player1,move(coord(0,4),coord(1,3)),1)},{},{
time(1).
}).
#pos(pos15,{does(player1,move(coord(1,0),coord(2,1)),1)},{},{
time(1).
}).
#pos(pos16,{does(player1,move(coord(1,4),coord(2,3)),1)},{},{
time(1).
}).
#brave_ordering(ord12@1, pos13, pos9).
#brave_ordering(ord13@1, pos13, pos10).
#brave_ordering(ord14@1, pos13, pos12).
#brave_ordering(ord15@1, pos13, pos14).
#brave_ordering(ord16@1, pos13, pos15).
#brave_ordering(ord17@1, pos13, pos16).
#brave_ordering(ord18@1, pos11, pos9).
#brave_ordering(ord19@1, pos11, pos10).
#brave_ordering(ord20@1, pos11, pos12).
#brave_ordering(ord21@1, pos11, pos14).
#brave_ordering(ord22@1, pos11, pos15).
#brave_ordering(ord23@1, pos11, pos16).
