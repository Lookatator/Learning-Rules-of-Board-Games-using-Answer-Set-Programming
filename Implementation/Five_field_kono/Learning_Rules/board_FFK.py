import pygame

from pawn_FFK import Pawn
import subprocess
import numpy as np
import ilasp


class Board:
    def __init__(self, window):
        self.window = window
        self.selected_pawn = None
        self.last_moved_pawn = None
        self.list_actions = np.array([]).reshape(0, 2, 2).astype(int)
        self.positions = np.array([[0] * 5] * 5)
        self.positions[0, :] = 1
        self.positions[1, 0] = 1
        self.positions[1, 4] = 1
        self.positions[4, :] = 2
        self.positions[3, 0] = 2
        self.positions[3, 4] = 2
        self.draw_board()
        pawns_p1 = [Pawn(0, i, 1, window) for i in range(0, 5)] + [Pawn(1, 0, 1, window), Pawn(1, 4, 1, window)]
        pawns_p2 = [Pawn(4, i, 2, window) for i in range(0, 5)] + [Pawn(3, 0, 2, window), Pawn(3, 4, 2, window)]
        self.list_pawns = pawns_p1 + pawns_p2
        self.turn = 1
        self.time = 1
        self.count_actions = 0
        self.count_orders = 0
        self.ilasp = ilasp.Ilasp()
        self.fictive_selection = False
        self.fictive_selection_pos_x = -1
        self.fictive_selection_pos_y = -1
        with open("game_actions.txt", "w") as game_actions:
            game_actions.write("time(1).\n")
            game_actions.write("#show does(player1,move(Coord_1,Coord_2),1) : does(player1,move(Coord_1,Coord_2),1).")
        with open("positive_examples.las", "w") as positive_examples:
            pass

    def restart(self):
        self.selected_pawn = None
        self.last_moved_pawn = None
        self.list_actions = np.array([]).reshape(0, 2, 2).astype(int)
        self.positions = np.array([[0] * 5] * 5)
        self.draw_board()
        for pawn in self.list_pawns:
            pawn.undraw()
        pawns_p1 = [Pawn(0, i, 1, self.window) for i in range(0, 5)] + [Pawn(1, 0, 1, self.window),
                                                                        Pawn(1, 4, 1, self.window)]
        pawns_p2 = [Pawn(4, i, 2, self.window) for i in range(0, 5)] + [Pawn(3, 0, 2, self.window),
                                                                        Pawn(3, 4, 2, self.window)]
        self.list_pawns = pawns_p1 + pawns_p2
        self.turn = 1
        self.time = 1
        with open("game_actions.txt", "w") as game_actions:
            game_actions.write("time(1).\n")
            game_actions.write("#show does(player1,move(Coord_1,Coord_2),1) : does(player1,move(Coord_1,Coord_2),1).")

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
        succeeds = False
        print 'MOVE_PAWN_TO'
        print self.turn
        print self.selected_pawn.side
        print self.positions[pos_x, pos_y]
        if self.selected_pawn is not None:
            previous_pos_x = self.selected_pawn.pos_x
            previous_pos_y = self.selected_pawn.pos_y
            if self.turn == self.selected_pawn.side:
                self.ilasp.add_example_can_play(True, self.selected_pawn.side)
                if self.positions[pos_x, pos_y] == 0:
                    if 5 > pos_x >= 0 and 5 > pos_y >= 0:
                        if self.selected_pawn.move_to(pos_x, pos_y):
                            if self.turn == 2:
                                self.time -= 1
                                self.turn = 1
                                self.save_preferences()
                                self.save_action(self.list_actions[0, 0, 0], self.list_actions[0, 0, 1],
                                                 self.list_actions[0, 1, 0], self.list_actions[0, 1, 1])
                                self.time += 1
                                self.turn = 2
                                self.save_action(previous_pos_x, previous_pos_y, pos_x, pos_y)

                                self.list_actions = np.array([[[]]]).reshape(0, 2, 2)

                            if self.turn == 1:
                                self.list_actions = np.append([[[previous_pos_x, previous_pos_y],
                                                                [pos_x, pos_y]]],
                                                              self.list_actions, axis=0).astype(int)
                                print(self.list_actions)
                                # self.save_preferences(previous_pos_x, previous_pos_y, pos_x, pos_y)
                            print self.positions
                            self.positions[previous_pos_x, previous_pos_y] = 0
                            self.positions[pos_x, pos_y] = self.turn
                            print self.positions
                            self.turn = 1 + self.turn % 2
                            self.time += 1
                            self.last_moved_pawn = self.selected_pawn
                            succeeds = True
            else:
                self.ilasp.add_example_can_play(False, self.selected_pawn.side)
            if succeeds:
                self.ilasp.add_example_legal(True, self.selected_pawn.side,
                                             previous_pos_x, previous_pos_y,
                                             pos_x, pos_y)
                self.ilasp.generate_hypothesis()
            else:
                self.ilasp.add_example_legal(False, self.selected_pawn.side,
                                             previous_pos_x, previous_pos_y,
                                             pos_x, pos_y)
                self.ilasp.generate_hypothesis()

        self.unselect()

    def draw_board(self):
        white = (255, 255, 255)
        for i in range(0, 6):
            pygame.draw.line(self.window, white, (100 * i, 0), (100 * i, 500))
            pygame.draw.line(self.window, white, (0, 100 * i), (500, 100 * i))
        pygame.display.flip()

    def action(self, pos_x, pos_y):
        if self.selected_pawn is None:
            if not self.fictive_selection:
                for pawn in self.list_pawns:
                    if pawn.pos_x == pos_x and pawn.pos_y == pos_y:
                        self.select(pawn)
                        return
                self.fictive_selection = True
                self.fictive_selection_pos_x = pos_x
                self.fictive_selection_pos_y = pos_y
                pygame.time.wait(100)
            else:
                self.ilasp.add_example_legal(False, self.turn,
                                             self.fictive_selection_pos_x, self.fictive_selection_pos_y,
                                             pos_x, pos_y)
                self.ilasp.generate_hypothesis()
                self.fictive_selection = False
        else:
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

    def save_action(self, previous_pos_x, previous_pos_y, pos_x, pos_y):
        action_pattern = "does(player{player}, move(coord({previous_pos_x},{previous_pos_y})," \
                         "coord({pos_x},{pos_y})),{time})."
        action_str = action_pattern.format(player=self.turn,
                                           previous_pos_x=previous_pos_x,
                                           previous_pos_y=previous_pos_y,
                                           pos_x=pos_x,
                                           pos_y=pos_y,
                                           time=self.time)
        del_last_line()
        del_last_line()
        with open("game_actions.txt", "a") as game_actions:
            game_actions.write(action_str + "\n")
            time_pattern = "time(1..{time})."
            time_str = time_pattern.format(time=self.time + 1)
            game_actions.write(time_str + "\n")
            show_does_pattern = "#show does(player1,move(Coord_1,Coord_2),{time}) : " \
                                "does(player1,move(Coord_1,Coord_2),{time})."
            show_does_str = show_does_pattern.format(time=self.time + 1)
            game_actions.write(show_does_str + "\n")

    def save_preferences(self):
        possible_actions = ''
        split_possible_actions = ''
        list_index_actions = np.array([]).astype(int)
        for m in self.list_actions:
            previous_pos_x = m[0, 0]
            previous_pos_y = m[0, 1]
            pos_x = m[1, 0]
            pos_y = m[1, 1]

            selected_action = 'does(player1,move(coord({previous_pos_x},{previous_pos_y}),coord({pos_x},{pos_y})),{time})'
            selected_action = selected_action.format(previous_pos_x=previous_pos_x,
                                                     previous_pos_y=previous_pos_y,
                                                     pos_x=pos_x,
                                                     pos_y=pos_y,
                                                     time=self.time)
            try:
                possible_actions = subprocess.check_output(
                    ['clingo', '-n 0', '--verbose=0', 'kono.lp', 'game_actions.txt'])
            except subprocess.CalledProcessError as e:
                possible_actions = e.output
            with open('game_actions.txt', 'r') as game_action:
                game_action_description = ''.join(game_action.readlines()[:-1])

            possible_actions = possible_actions.replace('SATISFIABLE\n', '')
            possible_actions = possible_actions.replace('does', '#pos({{does')
            possible_actions = possible_actions.replace(')\n', ')}},{{}},{{{game_action_description}}}).\n')
            split_possible_actions = possible_actions.split('\n')

            for count in range(len(split_possible_actions)):
                if split_possible_actions[count].startswith('#pos({{' + selected_action):
                    # index_selected_action = count
                    list_index_actions = np.append(list_index_actions, [count])
                    print list_index_actions
                split_possible_actions[count] = split_possible_actions[count].replace('#pos(',
                                                                                      '#pos(pos' + str(
                                                                                          count + self.count_actions) + ',')
                print str(count) + split_possible_actions[count]

            possible_actions = '\n'.join(split_possible_actions)
            possible_actions = possible_actions.format(game_action_description='\n' + game_action_description)

        with open("positive_examples.las", "a") as positive_examples:
            positive_examples.write(possible_actions)
        for index_selected_action in list_index_actions:
            with open("positive_examples.las", "a") as positive_examples:
                for count in range(len(split_possible_actions)):
                    ordering_template = '#brave_ordering(ord{order}@1, pos{index_selected_action}, pos{count}).'
                    if count not in list_index_actions and split_possible_actions[count].startswith('#'):
                        positive_examples.write(ordering_template.format(count=count + self.count_actions,
                                                                         order=self.count_orders,
                                                                         index_selected_action=index_selected_action + self.count_actions)
                                                + '\n')
                        self.count_orders += 1
        self.count_actions += len(split_possible_actions)

    def undo(self):
        self.turn = 1
        self.time -= 1
        self.last_moved_pawn.select()
        self.last_moved_pawn.move_to(int(self.list_actions[0, 0, 0]), int(self.list_actions[0, 0, 1]))
        self.last_moved_pawn.unselect()
        pygame.time.wait(100)


def del_last_line():
    with open("game_actions.txt", "r") as game_actions:
        game_actions_str = ''.join(game_actions.readlines()[:-1])
    with open("game_actions.txt", "w") as game_actions:
        game_actions.write(game_actions_str)
