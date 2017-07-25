import pygame


class Pawn:
    def __init__(self, pos_x, pos_y, side, window):
        self.pos_x = pos_x
        self.pos_y = pos_y
        self.side = side
        self.is_selected = False
        self.window = window
        if self.side == 2:
            self.color = (255, 0, 0)
        if self.side == 1:
            self.color = (0, 255, 0)
        self.draw()

    # def select(self):
    #     self.color = (0, 0, 255)
    #     self.is_selected = True
    #     self.draw()
    #
    # def unselect(self):
    #     if self.side == 2:
    #         self.color = (255, 0, 0)
    #     if self.side == 1:
    #         self.color = (0, 255, 0)
    #     print self.color
    #     self.is_selected = False
    #     self.draw()

    def move_to(self, new_pos_x, new_pos_y):
        self.undraw()
        if self.pos_x == new_pos_x + 1 or self.pos_x == new_pos_x - 1:
            if self.pos_y == new_pos_y + 1 or self.pos_y == new_pos_y - 1:
                self.pos_x = new_pos_x
                self.pos_y = new_pos_y
                return True
        return False

    def undraw(self):
        pygame.draw.circle(self.window, (0, 0, 0), (self.get_coordinates()), 25, 0)
        pygame.display.flip()

    def draw(self):
        pygame.draw.circle(self.window, self.color, (self.get_coordinates()), 25, 0)
        pygame.display.flip()

    def get_coordinates(self):
        return 50 + self.pos_x * 100, 50 + self.pos_y * 100
