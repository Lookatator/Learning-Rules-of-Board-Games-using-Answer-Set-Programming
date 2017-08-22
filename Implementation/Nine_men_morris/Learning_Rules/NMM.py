import pygame
import numpy as np
from pygame.locals import *
from board_NMM import Board
from representation import *


def are_close(pos1, pos2):
    return np.linalg.norm(np.array(pos1) - np.array(pos2)) < 30


def place_green_pawn():
    print "*** Place Green Pawn ***"
    pygame.time.wait(500)
    while True:
        for event in pygame.event.get():
            if event.type == MOUSEBUTTONDOWN and event.button == 1:
                for position in coordinates_list:
                    if are_close(event.pos, position):
                        board.place_green_pawn(coordinates_to_position(position))
                        return
                return


def place_red_pawn():
    print "*** Place Red Pawn ***"
    pygame.time.wait(500)
    while True:
        for event in pygame.event.get():
            if event.type == MOUSEBUTTONDOWN and event.button == 1:
                for position in coordinates_list:
                    if are_close(event.pos, position):
                        board.place_red_pawn(coordinates_to_position(position))
                        return
                return


def move_pawn():
    print "*** Select Pawn to Move ***"
    pygame.time.wait(500)
    is_selected = False
    while not is_selected:
        for event in pygame.event.get():
            if event.type == MOUSEBUTTONDOWN and event.button == 1:
                for position in coordinates_list:
                    if are_close(event.pos, position):
                        board.select_pawn(coordinates_to_position(position))
                if board.pawn_is_selected():
                    is_selected = True
                else:
                    return

    print "*** Where do you want to move it ? ***"
    pygame.time.wait(500)
    while True:
        for event in pygame.event.get():
            if event.type == MOUSEBUTTONDOWN and event.button == 1:
                for position in coordinates_list:
                    if are_close(event.pos, position):
                        board.move_pawn_to(coordinates_to_position(position))
                        return
                board.unselect()
                return

def remove_pawn():
    print "*** Remove Pawn ***"
    pygame.time.wait(500)
    while True:
        for event in pygame.event.get():
            if event.type == MOUSEBUTTONDOWN and event.button == 1:
                for position in coordinates_list:
                    if are_close(event.pos, position):
                        board.remove_pawn(coordinates_to_position(position))
                        return
                return


is_open = True

pygame.init()
window = pygame.display.set_mode((801, 901))

board = Board(window)

pygame.draw.rect(window, (0, 128, 255), pygame.Rect(100 - 50, 725, 100, 50))
pygame.draw.rect(window, (0, 255, 128), pygame.Rect(300 - 50, 725, 100, 50))
pygame.draw.rect(window, (255, 0, 128), pygame.Rect(500 - 50, 725, 100, 50))
pygame.draw.rect(window, (128, 255, 0), pygame.Rect(700 - 50, 725, 100, 50))

font = pygame.font.SysFont("comicsansms", 22)
text = font.render("Place Green", True, (0, 0, 0))
window.blit(text, (110 - 50, 740))
text = font.render("Place Red", True, (0, 0, 0))
window.blit(text, (310 - 50, 740))
text = font.render("Move", True, (0, 0, 0))
window.blit(text, (510 - 50, 740))
text = font.render("Remove", True, (0, 0, 0))
window.blit(text, (710 - 50, 740))
pygame.display.flip()
pygame.time.wait(500)

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
            # is_action = False
            # for pos_x in range(0, 5):
            #     for pos_y in range(0, 5):
            #         if are_close(event.pos, [50 + 100 * pos_x, 50 + 100 * pos_y]):
            #             board.action(pos_x, pos_y)
            #             is_action = True
            #             print board.time
            # if not is_action:
            #     board.unselect()
            if 50 < event.pos[0] < 150 and 725 < event.pos[1] < 775:
                # board.perform_other_action()
                place_green_pawn()
            if 250 < event.pos[0] < 350 and 725 < event.pos[1] < 775:
                place_red_pawn()
            if 450 < event.pos[0] < 550 and 725 < event.pos[1] < 775:
                move_pawn()
            if 650 < event.pos[0] < 750 and 725 < event.pos[1] < 775:
                remove_pawn()
    # if board.wins_p1():
    #     print "player 1 wins"
    #     is_open = False
    # elif board.wins_p2():
    #     print "player 2 wins"
    #     is_open = False
