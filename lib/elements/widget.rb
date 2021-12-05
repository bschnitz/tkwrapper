# frozen_string_literal: true

# wraps some code of Tk to make it more object oriented, provide new
# functionality and to ease usage
module TkWrapper
  require 'tk'
  require_relative '../util/virtual_methods'

  class Widget
    extend VirtualMethods

    attr_accessor :config, :tkwidget

    virtual def widget(parent) end

    def initialize(config: {}, childs: [])
      @config = config
      @childs = childs.is_a?(Array) ? childs : [childs]
    end

    def build(parent)
      @tkwidget = widget(parent)
      configure(@config)
      @childs.each do |child|
        child.build(@tkwidget)
      end
    end

    def configure(configuration)
      configure_grid(configuration[:grid])
      configure_global(configuration[:id])
      configure_options(configuration, %i[style text anchor])
    end

    def configure_options(configuration, options)
      options.each do |option|
        configure_option(configuration, option)
      end
    end

    def configure_option(configuration, option)
      return if configuration[option].nil?

      @tkwidget[option] = configuration[option]
    end

    def configure_grid(configuration)
      return unless configuration

      if configuration.is_a?(TrueClass)
        TkGrid.columnconfigure(@tkwidget, 0, weight: 1)
        TkGrid.rowconfigure(@tkwidget, 0, weight: 1)
      else
        @tkwidget.grid(**configuration)
      end
    end

    def configure_global(id)
      Widget.configure_global(self, id)
    end

    def self.configure_global(widget, id)
      @configurations.each do |(matcher, callback)|
        case matcher
        when Regexp
          (match = matcher.match(id)) && callback.call(widget, match)
        when String, Symbol
          matcher == id && callback.call(widget)
        end
      end
    end

    def self.config(matcher, &callback)
      (@configurations ||= []).push([matcher, callback])
    end
  end
end
