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

type Work struct {
	time, item int
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

func findWork(tasks [26]string) int {
	for i, task := range tasks {
		if task == "" {
			return i;
		}
	}
	return -1;
}


func run(nworkers int, timePenalty int, tasks [26]string) int {
	workers := make([]Work, nworkers)
	for i := 0; i < nworkers; i++ {
		workers[i] = Work{0, 0}
	}

	time := -1
	for hasWorked := true; hasWorked; time++ {
		hasWorked = false

		for i, worker := range workers {
			if worker.time == 0 {
				item := findWork(tasks)
				if item != -1 {
					hasWorked = true
					workers[i] = Work{timePenalty + item + 1, item}
					tasks[item] = "?"
				}
			}
		}

		for i, worker := range workers {
			if worker.time > 0 {
				workers[i].time--
				hasWorked = true

				if workers[i].time == 0 {
					for j := 0; j < 26; j++ {
						tasks[j] = strings.Replace(tasks[j], string('A' + workers[i].item), "", -1)
					}
				}
			}
		}
	}
	return time
}

func main() {
	tasks := createTasks(readFile("input"))

	fmt.Println(run(5, 60, tasks))
}