# frozen_string_literal: true

require_relative './grid_vector'

# wraps some code of Tk to make it more object oriented, provide new
# functionality and to ease usage
module TkWrapper
  require 'tk'
  require 'tkextlib/tile'

  # Column of a Grid
  class Col
    include GridVector

    def config(config)
      TkGrid.columnconfigure(@grid.parent, @index, config)
    end
  end
end
