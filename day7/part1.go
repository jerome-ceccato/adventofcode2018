package main

import (
"bufio" 
"fmt" 
"os"
"strings"
)

type Dependency struct {
	from, to byte
}

func readFile(filename string) []Dependency {
	file, _ := os.Open(filename)
	defer file.Close()

	var deps []Dependency
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		from, end := 5, 36
		line := scanner.Text()
		deps = append(deps, Dependency{line[from] - 'A', line[end] - 'A'})
	}

	return deps;
}

func createTasks(deps []Dependency) [26]string {
	var tasks [26]string
	for i := 0; i < 26; i++ {
		tasks[i] = "?"
	}

	for _, dep := range deps {
		newDep := string('A' + dep.from)

		if tasks[dep.from] == "?" {
			tasks[dep.from] = ""
		}
		if tasks[dep.to] == "?" {
			tasks[dep.to] = ""
		}

		tasks[dep.to] = tasks[dep.to] + newDep
	}

	return tasks
}

func buildSequence(tasks [26]string) string {
	sequence := ""
	loop := true
	for loop {
		loop = false
		for i := 0; i < 26 && !loop; i++ {
			if tasks[i] == "" {
				elem := string('A' + i)
				sequence += elem
				loop = true
				tasks[i] = "?"

				for j := 0; j < 26; j++ {
					tasks[j] = strings.Replace(tasks[j], elem, "", -1)
				}
			}
		}
	}
	return sequence
}

func main() {
	fmt.Println(buildSequence(createTasks(readFile("input"))))
}