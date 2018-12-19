import re

def readfile(filename):
    with open(filename) as file:
        return [line.rstrip('\n') for line in file]

def extract(line):
    return map(int, re.match(r'#(\d+)\s*@\s*(\d+),(\d+):\s*(\d+)x(\d+)', line).groups())

def main():
    n = 1000
    fabric = [[0 for _ in range(n)] for _ in range(n)]

    for line in readfile('input'):
        _, x, y, w, h = extract(line)
        for i in range(w):
            for j in range(h):
                fabric[x + i][y + j] += 1

    count = 0
    for i in range(n):
        for j in range(n):
            if fabric[i][j] > 1:
                count += 1

    print(count)

main()
