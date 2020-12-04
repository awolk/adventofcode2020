import re
import aoc

lines = aoc.get_input('day2.txt').splitlines()

pattern = re.compile('([0-9]+)-([0-9]+) ([a-z]): ([a-z]+)')

valid_pt1 = 0
valid_pt2 = 0
for line in lines:
    a, b, letter, password = pattern.match(line).groups()
    a, b = int(a), int(b)
    if a <= password.count(letter) <= b:
        valid_pt1 += 1

    pos1 = password[a - 1] == letter
    pos2 = password[b - 1] == letter
    valid_pt2 += pos1 ^ pos2


print(f"Part 1: {valid_pt1}")
print(f"Part 2: {valid_pt2}")
