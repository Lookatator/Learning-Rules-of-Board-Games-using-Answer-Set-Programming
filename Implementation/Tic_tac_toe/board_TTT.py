import pygame
from pygame.locals import *
import numpy as np

from pawn_TTT import Pawn


class Board:
    def __init__(self, window):
        self.window = window
        self.list_pawns = []
        self.selected_pawn = None
        self.positions = np.zeros((3, 3), dtype=np.uint8)
        self.draw_board()
        self.list_pawns = []
        self.turn = 1
        self.time = 1
        self.possible_good_states = ''
        self.count_possible_moves = 0

    def add_pawn(self, pawn):
        self.list_pawns += [pawn]
        self.positions[pawn.pos_y, pawn.pos_x] = pawn.side
        pawn.draw()

    # def select(self, pawn):
    #     self.unselect()
    #     pygame.time.wait(100)
    #     self.selected_pawn = pawn
    #     self.selected_pawn.select()
    #
    # def unselect(self):
    #     if self.selected_pawn is not None:
    #         pygame.time.wait(100)
    #         self.selected_pawn.unselect()
    #         self.selected_pawn = None

    def move_pawn_to(self, pos_x, pos_y):
        self.add_pawn(Pawn(pos_x, pos_y, self.turn, self.window))
        print self.positions
        self.turn = 1 + self.turn % 2
        self.time += 1
        pygame.time.wait(100)

    def draw_board(self):
        white = (255, 255, 255)
        for i in range(0, 4):
            pygame.draw.line(self.window, white, (100 * i, 0), (100 * i, 300))
            pygame.draw.line(self.window, white, (0, 100 * i), (300, 100 * i))
        pygame.display.flip()

    def action(self, pos_x, pos_y):
        for pawn in self.list_pawns:
            if pawn.pos_x == pos_x and pawn.pos_y == pos_y:
                return
        self.move_pawn_to(pos_x, pos_y)

        struc_examples = "#pos(pos{count},{action},{temp})."
        struct_orders = "#brave_ordering(ord{count}@1,pos{chosen_pos},pos{other_pos}, <)."

        action = "{does(player" + str(self.turn) + ", " + \
                 "fill(coord(" + str(pos_y+1) + "," + str(pos_x+1) + "))," + \
                 str(self.time) + ")}"
        print struc_examples.format(count=self.count_possible_moves,
                                    action=action,
                                    temp="{}")
        number_action = self.count_possible_moves
        self.count_possible_moves += 1
        for x in range(3):
            for y in range(3):
                if self.positions[x, y] == 0:
                    action = "{does(player" + str(3-self.turn) + ", " + \
                             "fill(coord(" + str(x+1) + "," + str(y+1) + "))," + \
                             str(self.time) + ")}"

                    print struc_examples.format(count=self.count_possible_moves,
                                                action=action,
                                                temp="{}")
                    print struct_orders.format(count=self.count_possible_moves,
                                               chosen_pos=number_action,
                                               other_pos=self.count_possible_moves)
                    self.count_possible_moves += 1


                    # struc_examples = "good_state({player}, {a11}, {a12}, {a13}, {a21}, {a22}, {a23}, {a31}, {a32}, {a33})."
                    # good_state = struc_examples.format(a11=int(self.positions[0, 0]), a12=self.positions[0, 1], a13=self.positions[0, 2],
                    #                                         a21=self.positions[1, 0], a22=self.positions[1, 1],
                    #                                         a23=self.positions[1, 2], a31=self.positions[2, 0],
                    #                                         a32=self.positions[2, 1], a33=self.positions[2, 2])
                    # self.possible_good_states += good_state + "\n"

    def wins_p1(self):
        return np.all(self.positions[0, :] == 1) or \
               np.all(self.positions[1, :] == 1) or \
               np.all(self.positions[2, :] == 1) or \
               np.all(self.positions[:, 0] == 1) or \
               np.all(self.positions[:, 1] == 1) or \
               np.all(self.positions[:, 2] == 1) or \
               self.positions[0, 0] == self.positions[1, 1] == self.positions[2, 2] == 1 or \
               self.positions[2, 0] == self.positions[1, 1] == self.positions[0, 2] == 1

    def wins_p2(self):
        return np.all(self.positions[0, :] == 2) or \
               np.all(self.positions[1, :] == 2) or \
               np.all(self.positions[2, :] == 2) or \
               np.all(self.positions[:, 0] == 2) or \
               np.all(self.positions[:, 1] == 2) or \
               np.all(self.positions[:, 2] == 2) or \
               self.positions[0, 0] == self.positions[1, 1] == self.positions[2, 2] == 2 or \
               self.positions[2, 0] == self.positions[1, 1] == self.positions[0, 2] == 2
