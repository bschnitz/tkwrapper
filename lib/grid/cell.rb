# frozen_string_literal: true

# wraps some code of Tk to make it more object oriented, provide new
# functionality and to ease usage
module TkWrapper
  require 'tk'
  require 'tkextlib/tile'

  # Cell in a Grid
  class Cell < Widget
    attr_accessor :rowspan, :colspan
    attr_reader :row_index, :col_index

    def initialize(config: {}, childs: [])
      super(config: config, childs: childs)

      @row_index = config[:row_index]
      @col_index = config[:col_index]
      @rowspan = config[:rowspan] || 1
      @colspan = config[:colspan] || 1
    end

    def build(parent)
      merge_into_child_config(grid: {
        rowspan: @rowspan,
        columnspan: @colspan,
        sticky: 'nsew'
      })

      super(parent)
    end
  end
end
