import re
import subprocess

coucou = 'rule((m1),(move(coord(1,2),coord(3,1)))).\n' \
         'rule((m2,m3),(move(coord(1,0),coord(0,1)),move(coord(1,0),coord(0,1)))).'
m = re.match('rule\(\(m1\),\(move\(coord\([0-9],[0-9]\),coord\([0-9],[0-9]\)\)\)\)\.', coucou)
n = re.findall('[0-9]', m.group(0))
m = re.search(
    r'rule\(\(m1\),\(move\(coord\((?P<pos_x>[0-9]),(?P<pos_y>[0-9])\),coord\((?P<new_pos_x>[0-9]),(?P<new_pos_y>[0-9])\)\)\)\)\.',
    coucou)
pos_x = m.group('pos_x')
pos_y = m.group('pos_y')

new_pos_x = m.group('new_pos_x')
new_pos_y = m.group('new_pos_y')

test = ''
selected_action = 'does(player2,move(coord(3,2),coord(4,1)),4)'
index_selected_action = -1

try:
    test = subprocess.check_output(['clingo', '-n 0', '--verbose=0', 'kono.lp', 'game_actions.txt'])
except subprocess.CalledProcessError as e:
    test = e.output

with open('game_actions.txt', 'r') as game_action:
    game_action_description = ''.join(game_action.readlines()[:-1])

test = test.replace('SATISFIABLE\n', '')
test = test.replace('does', '#pos({{does')
test = test.replace(')\n', ')}},{{}},{{{game_action_description}}}).\n')
split_test = test.split('\n')

for count in range(len(split_test)):
    if split_test[count].startswith('#pos({{' + selected_action):
        index_selected_action = count
    split_test[count] = split_test[count].replace('#pos(', '#pos(pos' + str(count) + ',')

test = '\n'.join(split_test)
test = test.format(game_action_description='\n' + game_action_description)

print test

for count in range(len(split_test)):
    ordering_template = '#brave_ordering(ord{count}@1, pos{index_selected_action}, pos{count}).'
    if count != index_selected_action:
        print ordering_template.format(count=count, index_selected_action=index_selected_action)


# test = subprocess.check_output(['clingo', 'kono.lp'], stderr=subprocess.STDOUT, shell=True)
