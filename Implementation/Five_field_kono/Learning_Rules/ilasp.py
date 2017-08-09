import subprocess


class Ilasp:
    def __init__(self):
        self.context = ""
        self.examples = ""
        self.time = 1

    def add_positive_example(self, player, prev_pos_x, prev_pos_y, new_pos_x, new_pos_y, time):
        move = "(player{player}," \
               "move(coord({prev_pos_x},{prev_pos_y})," \
               "coord({new_pos_x},{new_pos_y}))," \
               "{time})".format(player=player,
                                prev_pos_x=prev_pos_x,
                                prev_pos_y=prev_pos_y,
                                new_pos_x=new_pos_x,
                                new_pos_y=new_pos_y,
                                time=self.time)
        partial_interpretation = '#pos({{legal{move}}},{{}},{{{context} time(1..{time}).}}).'.format(move=move,
                                                                                                     time=self.time,
                                                                                                     context=self.context)
        self.examples += partial_interpretation + '\n'
        self.add_context(move)
        self.time += 1
        print 'ADD POSITIVE EXAMPLE'
        print self.examples
        self.generate_hypothesis()

    def add_negative_example(self, player, prev_pos_x, prev_pos_y, new_pos_x, new_pos_y, time):
        move = "(player{player}," \
               "move(coord({prev_pos_x},{prev_pos_y})," \
               "coord({new_pos_x},{new_pos_y}))," \
               "{time})".format(player=player,
                                prev_pos_x=prev_pos_x,
                                prev_pos_y=prev_pos_y,
                                new_pos_x=new_pos_x,
                                new_pos_y=new_pos_y,
                                time=self.time)
        partial_interpretation = '#neg({{legal{move}}},{{}},{{{context} time(1..{time}).}}).'.format(move=move,
                                                                                                     time=self.time,
                                                                                                     context=self.context)
        self.examples += partial_interpretation + '\n'
        print 'ADD NEGATIVE EXAMPLE'
        print self.examples
        self.generate_hypothesis()

    def add_context(self, move):
        self.context += 'does' + move + '.\n'

    def generate_hypothesis(self):
        with open('kono-rules-temp.las', 'w') as kono_rules_temp:
            with open('kono-rules.las', 'r') as kono_rules:
                kono_rules_temp.write(str(kono_rules.read()))
            kono_rules_temp.write(self.examples)

        print 'GENERATING HYPOTHESIS'
        hypothesis = ''
        try:
            hypothesis = subprocess.check_output(
                ['ILASP', '-ml=3', '--2i', '--cached-rel=cached', 'kono-rules-temp.las'])
            print str(hypothesis)
        except subprocess.CalledProcessError as e:
            hypothesis = e.output
            print str(hypothesis)
