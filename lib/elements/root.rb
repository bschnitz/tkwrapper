# frozen_string_literal: true

# wraps some code of Tk to make it more object oriented, provide new
# functionality and to ease usage
module TkWrapper
  require 'tk'
  require 'tkextlib/tile'
  require_relative './widget'

  class Root
    include Widget

    def initialize(config: {}, childs: [])
      @config = config
      @childs = childs.is_a?(Array) ? childs : [childs]
      build
    end

    private

    def build
      @tkwidget = TkRoot.new
      configure(@tkwidget, @config)
      @childs.each do |child|
        child.build(@tkwidget)
      end
    end
  end
end
