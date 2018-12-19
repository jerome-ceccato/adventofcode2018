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

int run(size_t const (&size)[2], int ** &map, std::vector<coordinates> points, int limit)
{
	int matching = 0;
	for (int x = 0; x < (int)size[0]; x++) {
		for (int y = 0; y < (int)size[1]; y++) {
			int total = 0;
			for (int i = 0; i < (int)points.size(); i++) {
				total += abs(points[i].first - x) + abs(points[i].second - y);
			}
			if (total < limit)
				matching++;
		}
	}
	return matching;
}

int main(int ac, char **av)
{
	int const limit = 10000;
	auto input = readInput("input");
	size_t mapSize[2];
	int **map;
	auto points = buildMap(input, mapSize, map);

	int max = run(mapSize, map, points, limit);

	std::cout << max << std::endl;
	return 0;
}
