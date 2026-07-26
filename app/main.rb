
module Main
  def initialize args
    args.state.living = {}
    load args
  end

  def load args
    (0..72).each do |y|
      (0..128).each do |x|
        if rand(100) < 20
          args.state.living[[x,y]] = 1
        end
      end
    end
  end

  def step args

  end

  def render args
    (0..72).each do |y|
      (0..128).each do |x|
        if args.state.living.include?([x,y])
          args.outputs.primitives << {x:x*10, y:y*10, w:10, h:10, path:'sprites/square/blue.png'}
        end
      end
    end
  end

  def tick args
    if args.state.tick_count == 0
      initialize args
    end

    render(args)
  end

end
