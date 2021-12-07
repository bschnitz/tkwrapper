# frozen_string_literal: true

# wraps some code of Tk to make it more object oriented, provide new
# functionality and to ease usage
module TkWrapper
  require 'tk'
  require_relative '../util/merge_recursive'

  class Widget
    attr_accessor :config
    attr_reader :parent

    def tk_class() end

    def initialize(config: {}, childs: [])
      @config = config
      @childs = childs.is_a?(Array) ? childs : [childs]
    end

    def create_tk_widget(parent)
      tk_class = self.tk_class || @config.delete(:tk_class)

      return unless tk_class

      parent&.tk_widget ? tk_class.new(parent.tk_widget) : tk_class.new
    end

    # if parent is provided and self has no tk_class, the tk_widget of the
    # parent is returned, if parent is not nil
    def tk_widget(parent = @parent)
      return @tk_widget if @tk_widget

      (@tk_widget = create_tk_widget(parent)) || parent&.tk_widget
    end

    def add_config(**config)
      merge_recursive!(@config, config)
    end

    def build(parent, configure: true)
      @parent = parent
      tk_widget # creates the widget if possible and not yet created
      self.configure(@config) if configure
      @childs.each { |child| child.build(self) }
    end

    def configure(configuration)
      configure_global(configuration[:id])
      configure_grid(configuration[:grid])
      configure_tearoff(configuration[:tearoff])
      configure_options(configuration, %i[style text anchor])
    end

    def configure_tearoff(configuration)
      return if configuration.nil?

      TkOption.add '*tearOff', (configuration ? 1 : 0)
    end

    def configure_options(configuration, options)
      options.each do |option|
        configure_option(configuration, option)
      end
    end

    def configure_option(configuration, option)
      return if configuration[option].nil?

      tk_widget[option] = configuration[option]
    end

    def configure_grid(configuration)
      return unless configuration

      if configuration.is_a?(TrueClass)
        TkGrid.columnconfigure(tk_widget, 0, weight: 1)
        TkGrid.rowconfigure(tk_widget, 0, weight: 1)
      else
        configure_weights(configuration.delete(:weights))
        tk_widget.grid(**configuration) unless configuration.empty?
      end
    end

    def configure_weights(config)
      config&.dig(:rows)&.each_with_index do |weight, index|
        TkGrid.rowconfigure(tk_widget, index, weight: weight)
      end

      config&.dig(:cols)&.each_with_index do |weight, index|
        TkGrid.columnconfigure(tk_widget, index, weight: weight)
      end
    end

    def configure_global(id)
      # TODO: Widget.memorize(self, id)
      Widget.configure_global(self, id)
    end

    # TODO: complete the following
    # def self.memorize(widget, id)
    #   ((@memorized_widgets ||= {})[id] ||= []).push(widget)
    # end

    def self.configure_global(widget, id)
      return unless @configurations

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

    def grid
      @config[:grid] ||= {}
    end
  end
end
