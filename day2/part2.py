def readfile(filename):
    with open(filename) as file:
        return [line.rstrip('\n') for line in file]

def compare(a, b):
    diff = 0
    for i in range(0, len(a)):
        diff += a[i] != b[i]
        if diff >= 2:
            return False
    return diff

def common_characters(a, b):
    common = ''
    for i in range(0, len(a)):
        if a[i] == b[i]:
            common += a[i]
    return common

def main():
    previous_lines = []
    for line in readfile('input'):
        if line and previous_lines:
            for previous in previous_lines:
                if compare(line, previous):
                    print(common_characters(line, previous))
                    return
        previous_lines.append(line)

main()
