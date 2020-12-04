import aoc


map = aoc.get_input('day3.txt').splitlines()

trees = 0

col = 0
for row in map:
    trees += (row[col % len(row)] == '#')
    col += 3

print(f"Part 1: trees = {trees}")

res = 1
slopes = [[1, 1], [1, 3], [1, 5], [1, 7], [2, 1]]
for dy, dx in slopes:
    trees = 0
    col = 0
    for row in map[::dy]:
        trees += (row[col % len(row)] == '#')
        col += dx
    res *= trees
print(f"Part 2: product = {res}")