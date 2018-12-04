import re

def readfile(filename):
    with open(filename) as file:
        return [line.rstrip('\n') for line in file]

def extract(line):
    return map(int, re.match(r'#(\d+)\s*@\s*(\d+),(\d+):\s*(\d+)x(\d+)', line).groups())

def main():
    n = 1000
    fabric = [[[] for _ in range(n)] for _ in range(n)]
    all_ids = []

    for line in readfile('input'):
        identifier, x, y, w, h = extract(line)
        all_ids.append(identifier)
        for i in range(w):
            for j in range(h):
                fabric[x + i][y + j].append(identifier)

    for i in range(n):
        for j in range(n):
            if len(fabric[i][j]) > 1:
                for identifier in fabric[i][j]:
                    if identifier in all_ids:
                        all_ids.remove(identifier)

    print(all_ids)

main()
