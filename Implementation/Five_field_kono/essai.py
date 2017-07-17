import re

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

