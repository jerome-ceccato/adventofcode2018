#include <iostream>
#include <vector>
#include <queue>
#include <fstream>
#include <string>

typedef std::pair<int, int> coordinates;

std::vector<coordinates> readInput(std::string const& filename)
{
	std::ifstream file(filename);
	std::string line;
	std::vector<coordinates> allLines;

	while (std::getline(file, line)) {
		int x = 0, y = 0;
		sscanf_s(line.c_str(), "%d, %d", &y, &x);
		allLines.push_back(coordinates(x, y));
	}

	return allLines;
}

std::vector<coordinates> buildMap(std::vector<coordinates> const& points, size_t(&size)[2], int** &map)
{
	coordinates min(INT_MAX, INT_MAX), max(INT_MIN, INT_MIN);
	for (size_t i = 0; i < points.size(); i++)
	{
		if (points[i].first < min.first)
			min.first = points[i].first;
		if (points[i].second < min.second)
			min.second = points[i].second;
		if (points[i].first > max.first)
			max.first = points[i].first;
		if (points[i].second > max.second)
			max.second = points[i].second;
	}

	size[0] = max.first - min.first + 1;
	size[1] = max.second - min.second + 1;

	map = new int*[size[0]];
	for (size_t x = 0; x < size[0]; x++)
		map[x] = new int[size[1]]();

	std::vector<coordinates> normalizedPoints;
	for (auto it = points.begin(); it < points.end(); ++it)
		normalizedPoints.push_back(coordinates(it->first - min.first, it->second - min.second));

	return normalizedPoints;
}

void run(size_t const (&size)[2], int ** &map, std::vector<coordinates> points)
{
	for (int x = 0; x < (int)size[0]; x++) {
		for (int y = 0; y < (int)size[1]; y++) {
			int min = INT_MAX;
			int mincount = 0;
			for (int i = 0; i < (int)points.size(); i++) {
				int dist = abs(points[i].first - x) + abs(points[i].second - y);
				if (dist == min) {
					mincount++;
				}
				else if (dist < min) {
					map[x][y] = i + 1;
					min = dist;
					mincount = 1;
				}
			}
			if (mincount > 1) {
				map[x][y] = -1;
			}
		}
	}
}

int solve(size_t const (&size)[2], int ** &map, std::vector<coordinates> points)
{
	auto counter = new int[points.size()]();

	for (int x = 0; x < (int)size[0]; x++) {
		for (int y = 0; y < (int)size[1]; y++) {
			auto current = map[x][y] - 1;

			if (current >= 0 && counter[current] >= 0) {
				if (x == 0 || y == 0 || x == ((int)size[0] - 1) || y == ((int)size[1] - 1))
					counter[current] = -1;
				else
					counter[current]++;
			}
		}
	}

	size_t max = 0;
	for (size_t i = 0; i < points.size(); i++) {
		if (counter[i] >= 0 && counter[i] > counter[max])
			max = i;
	}
	return counter[max];
}

int main(int ac, char **av)
{
	auto input = readInput("input");
	size_t mapSize[2];
	int **map;
	auto points = buildMap(input, mapSize, map);

	run(mapSize, map, points);
	int max = solve(mapSize, map, points);

	std::cout << max << std::endl;
	return 0;
}
