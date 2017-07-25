import re
import subprocess

p = subprocess.Popen(["ILASP", "-q", "essai.las"], stdout=subprocess.PIPE)
(coucou, err) = p.communicate()

print coucou

# m = re.search(
#     r'rule\(\(m1\),\(move\(coord\((?P<pos_x>[0-9]),(?P<pos_y>[0-9])\),coord\((?P<new_pos_x>[0-9]),(?P<new_pos_y>[0-9])\)\)\)\)\.',
#     coucou)
m = re.search(
    r'rule\(\(m1\),\(fill\(coord\((?P<pos_x>[0-9]),(?P<pos_y>[0-9])\)\)\)\)\.',
    coucou)
pos_x = m.group('pos_x')
pos_y = m.group('pos_y')

print pos_x
print pos_y

d = {}
d['className'] = 'MyCPlusPlusClassName'
with open('template', 'r') as ftemp:
    templateString = ftemp.read()
with open('generated', 'w') as f:
    f.write(templateString.format(**d))





