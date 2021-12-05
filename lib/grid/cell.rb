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

    def initialize(widget, row_index, col_index)
      @widget = widget
      @row_index = row_index
      @col_index = col_index
      @rowspan = 1
      @colspan = 1
    end

    def build(parent)
    #  cell.widget.grid sticky: 'nsew', padx: 5, pady: 5
    #  cell.widget.configure(anchor: 'center')

      @widget.config.merge!(grid: {
        row: @row_index,
        column: @col_index,
        rowspan: @rowspan,
        columnspan: @colspan,
        sticky: 'nsew'
      })

      @widget.build(parent)
    end
  end
end
