# frozen_string_literal: true

require_relative './grid_vector'

# wraps some code of Tk to make it more object oriented, provide new
# functionality and to ease usage
module TkWrapper
  require 'tk'
  require 'tkextlib/tile'

  # Row of a Grid
  class Row
    include GridVector

    def config(config)
      TkGrid.rowconfigure(@grid.container, @index, config)
    end
  end
end
