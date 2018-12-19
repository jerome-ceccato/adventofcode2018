def readfile(filename):
    with open(filename) as file:
        return [int(line.rstrip('\n')) for line in file]

def main():
    print(sum(readfile('input')))

main()
