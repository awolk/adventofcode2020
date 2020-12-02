import re

with open('input.txt') as f:
    input_file = f.read()
lines = input_file.splitlines()

pattern = re.compile('([0-9]+)-([0-9]+) ([a-z]): ([a-z]+)')

valid_pt1 = 0
valid_pt2 = 0
for line in lines:
    min, max, letter, password = pattern.match(line).groups()
    min, max = int(min), int(max)
    if min <= password.count(letter) <= max:
        valid_pt1 += 1

    pos1 = password[min - 1] == letter
    pos2 = password[max - 1] == letter
    valid_pt2 += pos1 ^ pos2


print(f"Part 1: {valid_pt1}")
print(f"Part 2: {valid_pt2}")
