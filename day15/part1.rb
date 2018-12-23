class Point
  attr_accessor :x
  attr_accessor :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def ==(other)
    self.class === other and
    other.x == @x and
    other.y == @y
  end

  alias eql? ==

  def <=>(other)
    if 0 == (@y <=> other.y)
      @x <=> other.x
    else
      @y <=> other.y
    end
  end

  def hash
    @x.hash ^ @y.hash
  end
end

class Unit
  attr_reader :type
  attr_accessor :position
  attr_accessor :hp
  attr_reader :damage

  def initialize(position, type)
    @type = type
    @position = position
    @hp = 200
    @damage = 3
  end

  def ==(other)
    self.class === other and
    other.position == @position and
    other.type == @type
  end

  alias eql? ==

  def <=>(other)
    @position <=> other.position
  end

  def attack(other)
    other.hp -= @damage
    other.hp <= 0
  end
end

class Game
  attr_reader :world
  attr_reader :uindex

  def initialize(filename)
    @world = []
    @units = []
    @uindex = {}

    read_file(filename)
  end

  def read_file(filename)
    y = 0
    File.foreach(filename) do |line|
      line = line.strip()
      line.each_char.with_index do |c, x|
        if c == 'G'
          @units << Unit.new(Point.new(x, y), :goblin)
          line[x] = '.'
        elsif c == 'E'
          @units << Unit.new(Point.new(x, y), :elf)
          line[x] = '.'
        end
      end
      @world << line
      y += 1
    end

    @units.each do |u|
      @uindex[u.position] = u
    end
  end

  def is_over
    elves = @units.count do |u|
      u.type == :elf
    end

    elves == 0 || elves == @units.size
  end

  def solve
    turns = run()
    remaning_hp = @units.reduce(0) {|acc, u| acc + u.hp}
    turns * remaning_hp
  end

  def run
    turns = 0
    while !is_over()
      units = @units.sort
      units.each do |u|
        if is_over()
          return turns
        end

        if u.hp > 0
          move(u)
          attack(u)
        end
      end
      turns += 1
    end

    turns
  end

  def move(unit)
    paths = {}
    q = Queue.new

    valid_adjacent_pos(unit.position) do |p|
      if !@uindex[p]
        q << p
        paths[p] = p
      elsif @uindex[p].type != unit.type
        return false
      end
    end

    while !q.empty?()
      current = q.pop()

      valid_adjacent_pos(current) do |p|
        if !paths[p]
          if @uindex[p]
            if @uindex[p].type != unit.type
              move_to(unit, paths[current])
              return true
            end
          else
            paths[p] = paths[current]
            q << p
          end
        end
      end
    end
    false
  end

  def move_to(unit, newpos)
    @uindex.delete(unit.position)
    unit.position = newpos
    @uindex[newpos] = unit
  end

  def world_size
    Point.new(@world[0].length, @world.count)
  end

  def valid_adjacent_pos(from)
    size = world_size()
    [Point.new(from.x, from.y + -1), # ^
      Point.new(from.x - 1, from.y), # <
      Point.new(from.x + 1, from.y), # >
      Point.new(from.x, from.y + 1)  # v
    ].each do |p|
      if from.x >= 0 and
        from.x < world_size.x and
        from.y >= 0 and
        from.y < world_size.y and
        @world[from.y][from.x] == '.'
        yield p
      end
    end
  end

  def attack(unit)
    target = nil
    valid_adjacent_pos(unit.position) do |p|
      if @uindex[p] and @uindex[p].type != unit.type
        current = @uindex[p]
        if !target or (current.hp < target.hp)
            target = current
        end
      end
    end

    if target
      if unit.attack(target)
        @uindex.delete(target.position)
        @units.delete(target)
        return true
      end
    end
    false
  end
end

def main
  game = Game.new("input")
  puts "#{game.solve}"
end

main()
