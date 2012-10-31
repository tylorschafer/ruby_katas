class Board
  attr_reader :steps, :size

  def initialize(options = {})
    @size = options[:size] || 20
    @steps = options[:steps] || 100
    @filename = options[:filename] || "#{@steps}_steps.png"
    @board = instantiate_board(@size)
  end

  def [](x)
    @board[x] || []
  end

  def rows
    @board
  end

  def run!
    @steps.times { step }
    end_game
  end

  private

  def alive_neighbors(x,y)
    neighbors = @board[x][y].neighbors.reject do |x,y|
      x < 0 || x > @size-1 || y < 0 || y > @size-1
    end

    neighbors.reduce(0) do |sum, pair|
      nx, ny = pair
      neighbor = @board[nx][ny]
      neighbor.alive? ? sum + 1 : sum
    end
  end

  def instantiate_board(size)
    Array.new(size) do |x|
      Array.new(size) do |y|
        BoardSquare.new(x,y)
      end
    end
  end

  def step
    rows.each_with_index do |row, x|
      row.each_with_index do |square, y|
        case alive_neighbors(x,y)
        when 0, 1, 4..8
          @board[x][y].kill if square.alive?
        when 3
          @board[x][y].resurrect if square.dead?
        end
      end
    end
    step!
  end

  def step!
    rows.each_with_index do |row, x|
      row.each_with_index do |square, y|
        square.transition!
      end
    end
  end

  def end_game
    print
  end

  def print
    BoardOutput.new(self, filename: @filename)
  end
end
