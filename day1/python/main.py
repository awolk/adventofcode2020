import sys

with open('input.txt') as f:
    input_file = f.read()

numbers = {int(line) for line in input_file.split('\n')}

for n in numbers:
    other = 2020 - n
    if other in numbers:
        print(f"{n} * {other} = {n * other}")
        break

for n1 in numbers:
    for n2 in numbers:
        if n1 == n2:
            continue
        n3 = 2020 - n1 - n2
        if n3 in numbers:
            print(f"{n1} * {n2} * {n3} = {n1 * n2 * n3}")
            sys.exit()
