import sys
import aoc


def part1(numbers):
    for n in numbers:
        other = 2020 - n
        if other in numbers:
            print(f"{n} * {other} = {n * other}")
            return


def part2(numbers):
    for n1 in numbers:
        for n2 in numbers:
            if n1 == n2:
                continue
            n3 = 2020 - n1 - n2
            if n3 in numbers:
                print(f"{n1} * {n2} * {n3} = {n1 * n2 * n3}")
                return

input = aoc.get_input('day1.txt')
numbers = {int(line) for line in input.splitlines()}
part1(numbers)
part2(numbers)
