import pygame
from pygame.locals import *

from pawn_FFK import Pawn


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
        self.list_pawns += [pawn]
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
                        previous_pos_x = self.selected_pawn.pos_x
                        previous_pos_y = self.selected_pawn.pos_y
                        if self.selected_pawn.move_to(pos_x, pos_y):
                            action_pattern = "does(player{player}, move(coord({previous_pos_x},{previous_pos_y})," \
                                             "coord({pos_x},{pos_y})),{time})."
                            action_str = action_pattern.format(player=self.turn,
                                                               previous_pos_x=previous_pos_x,
                                                               previous_pos_y=previous_pos_y,
                                                               pos_x=pos_x,
                                                               pos_y=pos_y,
                                                               time=self.time)

                            save_action(action_str,self.time)
                            self.turn = 1 + self.turn % 2
                            self.time += 1
        self.unselect()

    def draw_board(self):

        white = (255, 255, 255)
        for i in range(0, 6):
            pygame.draw.line(self.window, white, (100 * i, 0), (100 * i, 500))
            pygame.draw.line(self.window, white, (0, 100 * i), (500, 100 * i))
        pygame.display.flip()

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


def del_last_line():
    with open("game_actions.txt", "r") as game_actions:
        game_actions_str = ''.join(game_actions.readlines()[:-1])
    with open("game_actions.txt", "w") as game_actions:
        game_actions.write(game_actions_str)


def save_action(action_str, current_time):
    del_last_line()
    with open("game_actions.txt", "a") as game_actions:
        game_actions.write(action_str+"\n")
        time_pattern = "time(1..{time})."
        time_str = time_pattern.format(time=current_time+1)
        game_actions.write(time_str+"\n")
