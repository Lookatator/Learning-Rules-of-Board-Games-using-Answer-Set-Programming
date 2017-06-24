import pygame
import numpy as np
from pygame.locals import *

pygame.init()

fenetre = pygame.display.set_mode((501, 501))
white = (255,255,255)
for i in range(0, 6):
    pygame.draw.line(fenetre, white, (100 * i, 0), (100 * i, 500))
    pygame.draw.line(fenetre, white, (0, 100 * i), (500, 100 * i))


pygame.display.flip()
is_open = True

while is_open:
    for event in pygame.event.get():
        if event.type == QUIT:
            is_open = False
    if event.type == MOUSEBUTTONDOWN and event.button == 1 and event.pos[1] < 100 and np.linalg.norm(np.array(event.pos) - np.array([50,50])):
        pygame.draw.circle(fenetre, (0, 0, 0), (50, 50), 25, 0)
        pygame.draw.circle(fenetre, (0, 255, 0), (50, 100), 25, 0)
        pygame.display.flip()

