
module Main
  def initialize args
    args.state.living = {}
    load(args)
  end

  def load args
    (0..72).each do |y|
      (0..128).each do |x|
        if rand(100) < 10
          args.state.living[[x,y]] = 1
        end
      end
    end
  end

  def step args
    neighbors = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]
    life = {}
    args.state.living.each_key do |cell|
      cx, cy = cell
      neighbors.each do |n|
        nx, ny = n
        lx = cx + nx
        ly = cy + ny
        if life.include?([lx, ly])
          life[[lx, ly]] += 1
        else
          life[[lx, ly]] = 1
        end
      end
    end

    next_step = {}
    life.each do |cell, living_neighbors|
      if args.state.living.include?(cell)
        if living_neighbors > 1 and living_neighbors < 4
          next_step[cell] = 1
        end
      else
        if living_neighbors == 3
          next_step[cell] = 1
        end
      end
    end

    args.state.living = next_step
  end

  def render args
    out = []
    args.state.living.each_key do |living|
      x, y = living
      out << {x:x*10, y:y*10, w:10, h:10, path:'sprites/square/blue.png'}.sprite!
    end
    args.outputs.primitives << out
  end

  def tick args
    if args.state.tick_count == 0
      initialize args
    end

    render(args)

    if args.state.tick_count % 8 == 0
      step(args)
    end

  end

end
