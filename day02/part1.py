def readfile(filename):
    with open(filename) as file:
        return [line.rstrip('\n') for line in file]

def uniques(line):
    letters = {}
    for letter in line:
        letters[letter] = letters.get(letter, 0) + 1

    twice = 0
    thrice = 0
    for letter in letters:
        if letters[letter] == 2:
            twice = 1
        elif letters[letter] == 3:
            thrice = 1

    return twice, thrice

def main():
    a, b = 0, 0
    for line in readfile('input'):
        matches = uniques(line)
        a += matches[0]
        b += matches[1]
    print(a * b)

main()
