import pygame
from pygame.locals import *


class Board:
    def __init__(self, window):
        self.window = window
        self.list_pawns = []
        self.selected_pawn = None
        self.positions = [[0] * 5] * 5

    def add_pawn(self, pawn):
        self.list_pawns += pawn
        self.positions[pawn.pos_x][pawn.pos_y] = pawn.side
        pawn.draw()

    def select(self, pawn):
        self.selected_pawn = pawn
        self.selected_pawn.select()

    def unselect(self):
        self.selected_pawn.unselect()
        self.selected_pawn = None

    def move_pawn_to(self, pos_x, pos_y):
        if self.selected_pawn is not None:
            if self.positions[pos_x][pos_y] == 0:
                if 5 > pos_x >= 0 and 5 > pos_y >= 0:
                    self.selected_pawn.move_to(pos_x, pos_y)
        self.unselect()

    def draw_board(self):
        window = pygame.display.set_mode((501, 501))
        white = (255, 255, 255)
        for i in range(0, 6):
            pygame.draw.line(window, white, (100 * i, 0), (100 * i, 500))
            pygame.draw.line(window, white, (0, 100 * i), (500, 100 * i))

    def action(self, pos_x, pos_y):
        for pawn in self.list_pawns:
            if pawn.pos_x == pos_x and pawn.pos_y == pos_y:
                self.select(pawn)
                return
        self.move_pawn_to(pos_x, pos_y)
