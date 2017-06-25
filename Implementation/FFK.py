import pygame
import numpy as np
from pygame.locals import *
from board import Board
from pawn import Pawn


def are_close(pos1, pos2):
    return np.linalg.norm(np.array(pos1) - np.array(pos2)) < 25


is_open = True

pygame.init()
window = pygame.display.set_mode((501, 501))

board = Board(window)

#
# for pawn in pawns_p1 + pawns_p2:
#     board.add_pawn(pawn)
#
while is_open:
    for event in pygame.event.get():
        if event.type == QUIT:
            is_open = False
#     if event.type == MOUSEBUTTONDOWN and event.button == 1 and event.pos[1] < 100 and np.linalg.norm(
#                     np.array(event.pos) - np.array([50, 50])):
#         pygame.draw.circle(fenetre, (0, 0, 0), (50, 50), 25, 0)
#         pygame.draw.circle(fenetre, (0, 255, 0), (50, 100), 25, 0)
#         pygame.display.flip()
#

    if event.type == MOUSEBUTTONDOWN and event.button == 1:
        is_action = False
        for pos_x in range(0, 5):
            for pos_y in range(0, 5):
                if are_close(event.pos, [50 + 100 * pos_x, 50 + 100 * pos_y]):
                    board.action(pos_x, pos_y)
                    is_action = True
        if not is_action:
            board.unselect()

    if board.wins_p1():
        print "player 1 wins"
        is_open = False
    elif board.wins_p2():
        print "player 2 wins"
        is_open = False
