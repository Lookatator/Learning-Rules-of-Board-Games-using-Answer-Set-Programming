import pygame
from pygame.locals import *

from pawn import Pawn


class Board:
    def __init__(self, window):
        self.window = window
        self.list_pawns = []
        self.selected_pawn = None
        self.positions = [[0] * 5] * 5
        self.draw_board()
        pawns_p1 = [Pawn(0, i, 1, window) for i in range(0, 5)] + [Pawn(1, 0, 1, window), Pawn(1, 4, 1, window)]
        pawns_p2 = [Pawn(4, i, 2, window) for i in range(0, 5)] + [Pawn(3, 0, 2, window), Pawn(3, 4, 2, window)]
        self.list_pawns = pawns_p1 + pawns_p2
        self.turn = 1
        self.time = 1

    def add_pawn(self, pawn):
        self.list_pawns += pawn
        self.positions[pawn.pos_x][pawn.pos_y] = pawn.side
        pawn.draw()

    def select(self, pawn):
        self.unselect()
        pygame.time.wait(100)
        self.selected_pawn = pawn
        self.selected_pawn.select()

    def unselect(self):
        if self.selected_pawn is not None:
            pygame.time.wait(100)
            self.selected_pawn.unselect()
            self.selected_pawn = None

    def move_pawn_to(self, pos_x, pos_y):
        if self.selected_pawn is not None:
            if self.turn == self.selected_pawn.side:
                if self.positions[pos_x][pos_y] == 0:
                    if 5 > pos_x >= 0 and 5 > pos_y >= 0:
                        if self.selected_pawn.move_to(pos_x, pos_y):
                            self.turn = 1 + self.turn % 2
                            self.time += 1
        self.unselect()

    def draw_board(self):

        white = (255, 255, 255)
        for i in range(0, 6):
            pygame.draw.line(self.window, white, (100 * i, 0), (100 * i, 500))
            pygame.draw.line(self.window, white, (0, 100 * i), (500, 100 * i))

    def action(self, pos_x, pos_y):
        for pawn in self.list_pawns:
            if pawn.pos_x == pos_x and pawn.pos_y == pos_y:
                self.select(pawn)
                return
        self.move_pawn_to(pos_x, pos_y)

    def wins_p1(self):
        for pawn in self.list_pawns:
            if pawn.side == 1:
                if pawn.pos_x == 4 or (pawn.pos_x == 3 and (pawn.pos_y == 0 or pawn.pos_y == 4)):
                    pass
                else:
                    return False
        return True

    def wins_p2(self):
        for pawn in self.list_pawns:
            if pawn.side == 2:
                if pawn.pos_x == 0 or (pawn.pos_x == 1 and (pawn.pos_y == 0 or pawn.pos_y == 4)):
                    pass
                else:
                    return False
        return True
