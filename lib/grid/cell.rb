# frozen_string_literal: true

# wraps some code of Tk to make it more object oriented, provide new
# functionality and to ease usage
module TkWrapper
  require 'tk'
  require 'tkextlib/tile'

  # Cell in a Grid
  class Cell
    attr_accessor :rowspan, :colspan, :widget
    attr_reader :row_index, :col_index

    def initialize(widget, grid, row_index, col_index)
      @grid = grid
      @widget = widget
      @row_index = row_index
      @col_index = col_index
      @rowspan = 1
      @colspan = 1
    end

    def build
      @widget.grid(
        row: @row_index,
        column: @col_index,
        rowspan: @rowspan,
        columnspan: @colspan
      )
    end
  end
end
