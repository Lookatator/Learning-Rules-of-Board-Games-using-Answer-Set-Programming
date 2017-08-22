import subprocess

class Ilasp:
    def __init__(self):
        self.context = ""
        self.examples_legal = ""
        self.examples_can_play = ""
        self.examples_phase = ""
        self.time = 1
        self.dependency_learning = False

    def add_example_legal(self, positive, player, prev_pos_x, prev_pos_y, new_pos_x, new_pos_y):
        move = "(player{player}," \
               "move(coord({prev_pos_x},{prev_pos_y})," \
               "coord({new_pos_x},{new_pos_y}))," \
               "{time})".format(player=player,
                                prev_pos_x=prev_pos_x,
                                prev_pos_y=prev_pos_y,
                                new_pos_x=new_pos_x,
                                new_pos_y=new_pos_y,
                                time=self.time)
        if positive:
            type_example = "pos"
        else:
            type_example = "neg"

        partial_interpretation_legal = '#{type_example}({{legal{move}}},{{}},{{{context} time(1..{time}).}}).'.format(
            type_example=type_example,
            move=move,
            time=self.time,
            context=self.context)
        self.examples_legal += partial_interpretation_legal + '\n'
        if positive:
            self.add_context(move)
            self.time += 1
        print 'ADD POSITIVE EXAMPLE'
        print self.examples_legal

    def add_example_can_play(self, positive, player):
        can_play = "(player{player}," \
                   "move," \
                   "{time})".format(player=player,
                                    time=self.time)
        if positive:
            type_example = "pos"
        else:
            type_example = "neg"

        partial_interpretation_can_play = '#{type_example}({{can_play{can_play}}},{{}},{{{context} time(1..{time}).}}).'.format(
            type_example=type_example,
            can_play=can_play,
            time=self.time,
            context=self.context)
        self.examples_can_play += partial_interpretation_can_play + '\n'
        print 'ADD POSITIVE EXAMPLE'
        print self.examples_can_play

    def add_example_phase(self, positive, n_phase):
        phase = "(phase({phase})," \
                   "move," \
                   "{time})".format(phase=n_phase,
                                    time=self.time)
        if positive:
            type_example = "pos"
        else:
            type_example = "neg"

        partial_interpretation_phase = '#{type_example}({{phase{phase}}},{{}},{{{context} time(1..{time}).}}).'.format(
            type_example=type_example,
            phase=phase,
            time=self.time,
            context=self.context)
        self.examples_phase += partial_interpretation_phase + '\n'
        print 'ADD POSITIVE EXAMPLE'
        print self.examples_phase

    def add_context(self, move):
        self.context += 'does' + move + '.\n'

    #TODO : use cached !
    def generate_hypothesis(self):
        if self.dependency_learning:
            with open('kono-rules-temp.las', 'w') as kono_rules_temp:
                with open('kono-rules.las', 'r') as kono_rules:
                    kono_rules_temp.write(str(kono_rules.read()))
                with open('can_play-mode.las', 'r') as can_play_mode:
                    kono_rules_temp.write(str(can_play_mode.read()))
                kono_rules_temp.write(self.examples_can_play)
                print self.examples_can_play
            print 'GENERATING HYPOTHESIS'
            hypothesis = ''
            try:
                print subprocess.check_output(
                    ['ILASP', '--2i', 'kono-rules-temp.las'])
                hypothesis = subprocess.check_output(
                    ['ILASP', '--2i', '--quiet', 'kono-rules-temp.las'])
                print str(hypothesis)
            except subprocess.CalledProcessError as e:
                hypothesis = e.output
                print str(hypothesis)

            with open('kono-rules-temp.las', 'w') as kono_rules_temp:
                with open('kono-rules.las', 'r') as kono_rules:
                    kono_rules_temp.write(str(kono_rules.read()))
                with open('extra-mode.las', 'r') as extra_mode:
                    kono_rules_temp.write(str(extra_mode.read()))
                kono_rules_temp.write(self.examples_legal)
                kono_rules_temp.write(hypothesis)
                print self.examples_legal
            print 'GENERATING HYPOTHESIS'
            hypothesis = ''
            try:
                print subprocess.check_output(
                    ['ILASP', '--2i', 'kono-rules-temp.las'])
                hypothesis = subprocess.check_output(
                    ['ILASP', '--2i', '--quiet', 'kono-rules-temp.las'])
                print str(hypothesis)
            except subprocess.CalledProcessError as e:
                hypothesis = e.output
                print str(hypothesis)
        else:
            with open('kono-rules-temp.las', 'w') as kono_rules_temp:
                with open('kono-rules.las', 'r') as kono_rules:
                    kono_rules_temp.write(str(kono_rules.read()))
                with open('can_play-mode.las', 'r') as can_play_mode:
                    kono_rules_temp.write(str(can_play_mode.read()))
                with open('extra-mode.las', 'r') as extra_mode:
                    kono_rules_temp.write(str(extra_mode.read()))
                kono_rules_temp.write(self.examples_legal)
                print self.examples_legal
            print 'GENERATING HYPOTHESIS'
            hypothesis = ''
            try:
                print subprocess.check_output(
                    ['ILASP', '--2i','kono-rules-temp.las'])
                hypothesis = subprocess.check_output(
                    ['ILASP', '--2i',  '--quiet', 'kono-rules-temp.las'])
                print str(hypothesis)
            except subprocess.CalledProcessError as e:
                hypothesis = e.output
                print str(hypothesis)

