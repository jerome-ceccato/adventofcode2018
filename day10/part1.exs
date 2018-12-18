defmodule Point do
  defstruct x: 0, y: 0

  def apply(self, point, fct) do
    %Point{x: fct.(self.x, point.x), y: fct.(self.y, point.y)}
  end
end

defmodule Object do
  defstruct position: Point, velocity: Point

  def new(match) do
  	coords = Enum.map(tl(match), &String.to_integer(&1))
    %Object{
      position: %Point{x: Enum.at(coords, 0), y: Enum.at(coords, 1)},
      velocity: %Point{x: Enum.at(coords, 2), y: Enum.at(coords, 3)}
    }
  end

  def advancedBy(self, n) do
    %Object{
      position: %Point{
        x: self.position.x + n * self.velocity.x,
        y: self.position.y + n * self.velocity.y
      },
      velocity: self.velocity
    }
  end

  def boundingSize(objects) do
    box = {List.first(objects).position, List.first(objects).position}

    box =
      objects
      |> Enum.reduce(box, fn item, box ->
        {Point.apply(elem(box, 0), item.position, &min/2),
         Point.apply(elem(box, 1), item.position, &max/2)}
      end)

    %Point{x: abs(elem(box, 0).x - elem(box, 1).x), y: abs(elem(box, 0).y - elem(box, 1).y)}
  end
end

defmodule Main do
  def readFile(filename) do
    {:ok, input} = File.read(filename)

    matches = Regex.scan(~r/position=<\s*(-?\d+),\s*(-?\d+)> velocity=<\s*(-?\d+),\s*(-?\d+)>/, input)
    Enum.map(matches, &Object.new(&1))
  end

  def smallestSize(points, current) do
  	newPoints = Enum.map(points, &Object.advancedBy(&1, 1))
  	newSize = Object.boundingSize(newPoints)
  	if newSize.x > current.x || newSize.y > current.y do
  		points
  	else
  		smallestSize(newPoints, newSize)
  	end
  end

  def representation(objects) do
  	size = Object.boundingSize(objects)
  	minx = Enum.reduce(objects, List.first(objects).position.x, fn item, acc -> min(acc, item.position.x) end)
	miny = Enum.reduce(objects, List.first(objects).position.y, fn item, acc -> min(acc, item.position.y) end)

	data = Enum.reduce(objects, %{}, fn obj, acc -> Map.put(acc, obj.position.x - minx, Map.put(Map.get(acc, obj.position.x - minx, %{}), obj.position.y - miny, true)) end)

	Enum.into 0..size.y, [], fn y -> 
		(Enum.into 0..size.x, "", fn x ->
			if data[x][y] do
				"#"
			else
				"."
			end
		end) <> "\n"
	end
  end

  def run() do
    points = readFile("input")
    current = Object.boundingSize(points)
    target = smallestSize(points, current)
    IO.puts representation(target)
  end
end

Main.run()
