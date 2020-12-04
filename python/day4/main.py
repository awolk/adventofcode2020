import re
from collections import namedtuple
import aoc


Passport = namedtuple('Passport', ['byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid'])

input = aoc.get_input('day4.txt')

passports = []
for group in input.split('\n\n'):
    details = {}
    for entry in group.split():
        key, value = entry.split(':')
        if key != 'cid':
            details[key] = value
    try:
        passports.append(Passport(**details))
    except TypeError:
        pass

valid_pt1 = len(passports)


def num_in_range(s, min, max, digits=None):
    if digits is not None and len(s) != digits: return False
    try:
        i = int(s)
    except:
        return False
    if i < min or i > max: return False
    return True


def is_valid_passport(p):
    if not num_in_range(p.byr, 1920, 2002, 4): return False
    if not num_in_range(p.iyr, 2010, 2020, 4): return False
    if not num_in_range(p.eyr, 2020, 2030, 4): return False

    if p.hgt.endswith('cm'):
        if not num_in_range(p.hgt[:-2], 150, 193): return False
    elif p.hgt.endswith('in'):
        if not num_in_range(p.hgt[:-2], 59, 76): return False
    else:
        return False

    if not re.match('^#[0-9a-f]{6}$', p.hcl): return False

    if not p.ecl in ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth']: return False

    if not re.match('^[0-9]{9}$', p.pid): return False

    return True


valid_pt2 = sum(is_valid_passport(passport) for passport in passports)

print('Part 1:', valid_pt1)
print('Part 2:', valid_pt2)
