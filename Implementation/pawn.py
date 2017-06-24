import pygame

class Pawn:
    def __init__(self, pos_x, pos_y, side):
        self.pos_x = pos_x
        self.pos_y = pos_y
        self.side = side
        self.is_selected = False

    def select(self):
        self.is_selected = True

    def unselect(self):
        self.is_selected = False

    def move_to(self, new_pos_x, new_pos_y):
        if self.pos_x == new_pos_x + 1 or self.pos_x == new_pos_x - 1:
            if self.pos_y == new_pos_y + 1 or self.pos_y == new_pos_y - 1:
                self.pos_x = new_pos_x
                self.pos_y = new_pos_y

    def undraw(self):
        