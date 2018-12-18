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

  def smallestSize(points, current, acc) do
  	newPoints = Enum.map(points, &Object.advancedBy(&1, 1))
  	newSize = Object.boundingSize(newPoints)
  	if newSize.x > current.x || newSize.y > current.y do
  		acc
  	else
  		smallestSize(newPoints, newSize, acc + 1)
  	end
  end

  def run() do
    points = readFile("input")
    current = Object.boundingSize(points)
    IO.puts smallestSize(points, current, 0)
  end
end

Main.run()
