def readfile(filename):
    with open(filename) as file:
        return [int(line.rstrip('\n')) for line in file]

def main():
    data = readfile('input')
    current = 0
    sums = {current: 1}

    while True:
        for value in data:
            current += value
            if current in sums:
                print(current)
                return
            sums[current] = 1

main()
