import re
import aoc


input = aoc.get_input('day4.txt')

valid = 0
valid2 = 0
details = {}

def num_in_range(s, min, max, digits=None):
    if digits is not None and len(s) != digits: return False
    try:
        i = int(s)
    except:
        return False
    if i < min or i > max: return False
    return True

def is_valid(details):
    if not num_in_range(details['byr'], 1920, 2002, 4): return False
    if not num_in_range(details['iyr'], 2010, 2020, 4): return False
    if not num_in_range(details['eyr'], 2020, 2030, 4): return False

    hgt = details['hgt']
    if hgt.endswith('cm'):
        if not num_in_range(hgt[:-2], 150, 193): return False
    elif hgt.endswith('in'):
        if not num_in_range(hgt[:-2], 59, 76): return False
    else:
        return False

    hcl = details['hcl']
    if not re.match('^#[0-9a-f]{6}$', hcl): return False

    if not details['ecl'] in ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth']: return False

    if not re.match('^[0-9]{9}$', details['pid']): return False

    return True

for line in input.splitlines() + ['']:
    if not line:
        if {'byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid'} <= set(details.keys()):
            valid += 1
            valid2 += is_valid(details)
        details = {}

    entries = line.split()
    for entry in entries:
        key, value = entry.split(':')
        details[key] = value

print('Part 1:', valid)
print('Part 2:', valid2)
