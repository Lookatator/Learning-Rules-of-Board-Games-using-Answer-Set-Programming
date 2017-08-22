import pygame
import representation
import numpy as np


class Pawn:
    def __init__(self, position, side, window):
        self.position = position
        self.side = side
        self.is_selected = False
        self.window = window
        if self.side == 2:
            self.color = (255, 0, 0)
        if self.side == 1:
            self.color = (0, 255, 0)
        self.draw()

    def select(self):
        self.color = (0, 0, 255)
        self.is_selected = True
        self.draw()

    def unselect(self):
        if self.side == 2:
            self.color = (255, 0, 0)
        if self.side == 1:
            self.color = (0, 255, 0)
        self.is_selected = False
        self.draw()

    def legal_move(self, new_position):
        return representation.are_adjacent(self.position,
                                           new_position)

    def move_to(self, new_position):
        self.undraw()
        if self.legal_move(new_position):
            self.position = new_position
            self.draw()
            return True
        return False

    def undraw(self):
        pygame.draw.circle(self.window, (0, 0, 0), (self.get_coordinates()), 25, 0)
        pygame.display.flip()

    def draw(self):
        pygame.draw.circle(self.window, self.color, (self.get_coordinates()), 25, 0)
        pygame.display.flip()

    def get_coordinates(self):
        return representation.position_to_coordinates(self.position)
