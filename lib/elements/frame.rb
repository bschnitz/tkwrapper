# frozen_string_literal: true

# wraps some code of Tk to make it more object oriented, provide new
# functionality and to ease usage
module TkWrapper
  require 'tk'
  require 'tkextlib/tile'
  require_relative './widget'

  class Frame < Widget
    def widget(parent)
      Tk::Tile::Frame.new(parent)
    end
  end
end
