# frozen_string_literal: true

# wraps some code of Tk to make it more object oriented, provide new
# functionality and to ease usage
module TkWrapper
  require 'tk'
  require_relative '../util/virtual_methods'

  class Widget
    extend VirtualMethods

    virtual def widget(parent) end

    def initialize(config: {}, childs: [])
      @config = config
      @childs = childs.is_a?(Array) ? childs : [childs]
    end

    def build(parent)
      @tkwidget = widget(parent)
      configure(@tkwidget, @config)
      @childs.each do |child|
        child.build(@tkwidget)
      end
    end

    def configure(tkwidget, configuration)
      configure_grid(tkwidget, configuration['grid'])
    end

    def configure_grid(tkwidget, configuration)
      return unless configuration

      if configuration.is_a?(TrueClass)
        TkGrid.columnconfigure(tkwidget, 0, weight: 1)
        TkGrid.rowconfigure(tkwidget, 0, weight: 1)
      else
        tkwidget.grid(**configuration)
      end
    end
  end
end
