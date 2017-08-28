import subprocess

class Ilasp:
    def __init__(self):
        self.context = ""
        self.examples_legal = ""
        self.examples_can_play = ""
        self.examples_phase = ""
        self.time = 1
        self.dependency_learning = False
        with open("cached-phase", "w"):
            pass
        with open("cached-can_play", "w"):
            pass

    def add_example_legal_place_pawn(self, positive, player, position):
        place_pawn = "(player{player}," \
               "place_pawn(coord({pos_x},{pos_y}))," \
               "{time})".format(player=player,
                                pos_x=position[0]+1,
                                pos_y=position[1]+1,
                                time=self.time)
        if positive:
            type_example = "pos"
        else:
            type_example = "neg"

        partial_interpretation_legal = '#{type_example}({{legal{place_pawn}}},{{}},{{{context} time(1..{time}).}}).'.format(
            type_example=type_example,
            place_pawn=place_pawn,
            time=self.time,
            context=self.context)
        self.examples_legal += partial_interpretation_legal + '\n'
        if positive:
            self.add_context(place_pawn)
            self.time += 1
        print 'ADD POSITIVE EXAMPLE'
        # print self.examples_legal

    def add_example_legal_move(self, positive, player, prev_position, new_position):
        move = "(player{player}," \
               "move(coord({prev_pos_x},{prev_pos_y})," \
               "coord({new_pos_x},{new_pos_y}))," \
               "{time})".format(player=player,
                                prev_pos_x=prev_position[0]+1,
                                prev_pos_y=prev_position[1]+1,
                                new_pos_x=new_position[0]+1,
                                new_pos_y=new_position[1]+1,
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
        # print self.examples_legal

    def add_example_legal_remove_pawn(self, positive, player, position):
        remove_pawn = "(player{player}," \
               "remove_pawn(coord({pos_x},{pos_y}))," \
               "{time})".format(player=player,
                                pos_x=position[0]+1,
                                pos_y=position[1]+1,
                                time=self.time)
        if positive:
            type_example = "pos"
        else:
            type_example = "neg"

        partial_interpretation_legal = '#{type_example}({{legal{remove_pawn}}},{{}},{{{context} time(1..{time}).}}).'.format(
            type_example=type_example,
            remove_pawn=remove_pawn,
            time=self.time,
            context=self.context)
        self.examples_legal += partial_interpretation_legal + '\n'
        if positive:
            self.add_context(remove_pawn)
            self.time += 1
        print 'ADD POSITIVE EXAMPLE'
        # print self.examples_legal

    def add_example_can_play(self, positive, player, action_name):
        can_play = "(player{player}," \
                   "{action_name}," \
                   "{time})".format(player=player,
                                    action_name=action_name,
                                    time=self.time)
        if positive:
            type_example = "pos"
        else:
            type_example = "neg"
        if positive:
            partial_interpretation_can_play = '#pos({{can_play{can_play}}},{{}},{{{context} time(1..{time}).}}).'.format(
                can_play=can_play,
                time=self.time,
                context=self.context)
        else:
            partial_interpretation_can_play = '#pos({{}},{{can_play{can_play}}},{{{context} time(1..{time}).}}).'.format(
                can_play=can_play,
                time=self.time,
                context=self.context)
        self.examples_can_play += partial_interpretation_can_play + '\n'
        print 'ADD POSITIVE EXAMPLE'
        self.generate_hypothesis_omniscient()
        # print self.examples_can_play

    def add_example_phase(self, positive, n_phase):
        phase = "(phase({phase})," \
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
        # print self.examples_phase

    def add_context(self, move):
        self.context += 'does' + move + '.\n'

    def generate_hypothesis_external(self):
        pass

    def generate_hypothesis_intermediate(self):
        pass

    def generate_hypothesis_omniscient(self):
        hypothesis = ''
        with open("9MM-rules-temp.las", 'w') as NMM_rules_temp:
            with open("9MM.las", 'r') as NMM_rules:
                NMM_rules_temp.write(str(NMM_rules.read()))
            with open("finished-mode.las", 'r') as finished_mode:
                NMM_rules_temp.write(str(finished_mode.read()))
            NMM_rules_temp.write(self.examples_phase)
        try:
            print subprocess.check_output(
                ['ILASP', '--2i', '9MM-rules-temp.las'])
            hypothesis = subprocess.check_output(
                ['ILASP', '--2i', '--quiet', '--cached-rel=cached-phase', '9MM-rules-temp.las'])
            print str(hypothesis)
        except subprocess.CalledProcessError as e:
            hypothesis = e.output
            print str(hypothesis)

        with open("9MM-rules-temp.las", 'w') as NMM_rules_temp:
            with open("9MM.las", 'r') as NMM_rules:
                NMM_rules_temp.write(str(NMM_rules.read()))
            with open("can_play-mode.las", 'r') as can_play_mode:
                NMM_rules_temp.write(str(can_play_mode.read()))
            NMM_rules_temp.write(self.examples_can_play)
            NMM_rules_temp.write(hypothesis)
        # print subprocess.check_output(
        #     ['ILASP', '--2i', '9MM-rules-temp.las'])
        try:
            hypothesis += '\n' + str(subprocess.check_output(
                # ['ILASP', '--2i', '--quiet', '--cached-rel=cached-can_play', '-ml=4', '9MM-rules-temp.las'])) #TODO: find a way to use cached file ???
                ['ILASP', '--2i', '--quiet', '-ml=4', '9MM-rules-temp.las'])) #TODO: find a way to use cached file ???
            print 'hyp: ' + str(hypothesis)
        except subprocess.CalledProcessError as e:
            hypothesis += '\n' + str(e.output)
            print str(hypothesis)


