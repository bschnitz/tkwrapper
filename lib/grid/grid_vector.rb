# frozen_string_literal: true

# wraps some code of Tk to make it more object oriented, provide new
# functionality and to ease usage
module TkWrapper
  require 'tk'
  require 'tkextlib/tile'

  # Row or Col of a Grid
  module GridVector
    def initialize(grid, index)
      @index = index
      @grid = grid
    end

    def weight=(number)
      config weight: number
    end
  end
end
