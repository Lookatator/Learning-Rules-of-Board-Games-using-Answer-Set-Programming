import re

coucou = 'rule((m1),(move(coord(1,2),coord(3,1)))).\n' \
         'rule((m2,m3),(move(coord(1,0),coord(0,1)),move(coord(1,0),coord(0,1)))).'
m = re.match('rule\(\(m1\),\(move\(coord\([0-9],[0-9]\),coord\([0-9],[0-9]\)\)\)\)\.', coucou)
n = re.match('[0-9]', m.group(0))
for i in range(0, 2):
    print n.group(i)

