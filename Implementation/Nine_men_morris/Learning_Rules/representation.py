import numpy as np

coordinates_list = np.array(
    [[100, 100], [100, 400], [100, 700], [400, 700], [700, 700], [700, 400], [700, 100], [400, 100],
     [200, 200], [200, 400], [200, 600], [400, 600], [600, 600], [600, 400], [600, 200], [400, 200],
     [300, 300], [300, 400], [300, 500], [400, 500], [500, 500], [500, 400], [500, 300], [400, 300]])


def coordinates_to_position(coordinates):
    coord = np.zeros(2, dtype=int)
    index = np.where(np.all(coordinates_list == coordinates, axis=1))[0][0]
    coord[0] = (-index) % 8
    coord[1] = index // 8
    return coord


def position_to_coordinates(position):
    i = position[0]
    j = position[1]
    if i == 0:
        return np.array([400 - (3 - j) * 100, 400 - (3 - j) * 100])
    elif i == 1:
        return np.array([400, 400 - (3 - j) * 100])
    elif i == 2:
        return np.array([400 + (3 - j) * 100, 400 - (3 - j) * 100])
    elif i == 3:
        return np.array([400 + (3 - j) * 100, 400])
    elif i == 4:
        return np.array([400 + (3 - j) * 100, 400 + (3 - j) * 100])
    elif i == 5:
        return np.array([400, 400 + (3 - j) * 100])
    elif i == 6:
        return np.array([400 - (3 - j) * 100, 400 + (3 - j) * 100])
    elif i == 7:
        return np.array([400 - (3 - j) * 100, 400])


def is_odd(number):
    return (number // 2) * 2 != number


def are_adjacent(pos1, pos2):
    if pos1[0] == (pos2[0] + 1) % 8 and pos1[1] == pos2[1]:
        return True
    elif pos1[0] == (pos2[0] - 1) % 8 and pos1[1] == pos2[1]:
        return True
    elif is_odd(pos1[0]) and pos1[0] == pos2[0] and pos1[1] == pos2[1] + 1:
        return True
    elif is_odd(pos1[0]) and pos1[0] == pos2[0] and pos1[1] == pos2[1] - 1:
        return True
    else:
        return False

print are_adjacent(np.array([1,2]),np.array([1,1]))