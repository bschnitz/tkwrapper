# frozen_string_literal: true

# wraps some code of Tk to make it more object oriented, provide new
# functionality and to ease usage
module TkWrapper
  require 'tk'
  require 'tkextlib/tile'
  require_relative './widget'

  class Frame
    include Widget

    def initialize(config: {}, childs: [])
      @config = config
      @childs = childs.is_a?(Array) ? childs : [childs]
    end

    def build(parent)
      @tkwidget = Tk::Tile::Frame.new(parent)
      configure(@tkwidget, @config)
      @childs.each do |child|
        child.build(@tkwidget)
      end
    end
  end
end
