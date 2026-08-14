
module Main
  def initialize args
    args.state.living = {}
    load(args)
  end

  def apply_rule rule, live, living_neighbors
    if live
      pass = [0,0,0,0,0,0,0,0,0]
      living_neighbors.s.each_with_index do |v, i|
        if i > 0 and v >= i
          pass[i] = v
        end
      end
      return pass
    else
      pass = [0,0,0,0,0,0,0,0,0]
      living_neighbors.b.each_with_index do |v, i|
        if i > 0 and v >= i
          pass[i] = v
        end
      end
      return pass
    end
    return [0,0,0,0,0,0,0,0,0]
  end

  def load args
    (0..72).each do |y|
      (0..128).each do |x|
        if rand(100) < 15
          args.state.living[[x,y]] = {living:true, s:[0,0,1,1,0,0,0,0,0], b:[0,0,0,1,0,0,0,0,0]}
        end
      end
    end
  end

  # For each cell, do something
  def step args
    neighbors = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]
    life = {}
    args.state.living.each_key do |cell|
      cx, cy = cell
      neighbors.each do |n|
        nx, ny = n
        lx = cx + nx
        ly = cy + ny
        if not life.include?([lx, ly])
          life[[lx, ly]] = {s:[0,0,0,0,0,0,0,0,0], b:[0,0,0,0,0,0,0,0,0]}
        end
        b = life[[lx, ly]].b.zip(args.state.living[cell].b).map{|pair| pair.reduce(&:+) }
        s = life[[lx, ly]].s.zip(args.state.living[cell].s).map{|pair| pair.reduce(&:+) }
        life[[lx, ly]] =  {s:s, b:b}
      end
    end

    next_step = {}
    life.each do |cell, living_neighbors|
      living = args.state.living.include?(cell)
      pass = apply_rule(0, living, living_neighbors)
      if pass.any? {|e| e > 0}
        next_step[cell] = {living:true, s:[0,0,1,1,0,0,0,0,0], b:[0,0,0,1,0,0,0,0,0]}
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

    if args.state.tick_count % 4 == 0
      step(args)
    end

  end

end
