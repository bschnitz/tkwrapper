# frozen_string_literal: true

# wraps some code of Tk to make it more object oriented, provide new
# functionality and to ease usage
module TkWrapper
  require 'tk'
  require_relative '../util/merge_recursive'
  require_relative '../tk_extensions'

  class Widget
    include TkExtensions

    attr_accessor :config
    attr_reader :parent, :childs

    def tk_class() end

    def initialize(config: {}, childs: [])
      @config = config
      @childs = childs.is_a?(Array) ? childs : [childs]
      @id = config.dig(:id)
    end

    def create_tk_widget(parent)
      tk_class = @config.delete(:tk_class) || self.tk_class

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
      configure_global(configuration.delete(:id))
      configure_grid(configuration.delete(:grid))
      configure_tearoff(configuration.delete(:tearoff))
      #configure_options(configuration, %i[style text anchor padding])
      configure_all_options(configuration)
    end

    def configure_all_options(options)
      options.each do |option, value|
        tk_widget[option] = value
      end
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

      case configuration
      when :onecell
        configuration = { weights: {rows: [1], cols: [1]} }
      when :fullcell
        configuration = { column: 0, row: 0, sticky: 'nsew' }
      when :default
        configuration = {
          weights: { rows: [1], cols: [1] },
          column: 0, row: 0, sticky: 'nsew'
        }
      end

      configure_weights(configuration.delete(:weights))

      tk_widget.grid(**configuration) unless configuration.empty?
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
        next unless (match = match_id(matcher, id, widget))

        arguments = match.is_a?(MatchData) ? [widget, match] : [widget]
        config = callback.call(*arguments)
        config.is_a?(Hash) && merge_recursive!(widget.config, config)
      end
    end

    def self.config(matcher, &callback)
      (@configurations ||= []).push([matcher, callback])
    end

    def grid
      @config[:grid] ||= {}
    end

    def self.match_id(matcher, id, widget)
      case matcher
      when Regexp
        matcher.match(id)
      when String, Symbol
        matcher == id
      else
        widget.is_a?(matcher)
      end
    end

    def match_id(matcher)
      Widget.match_id(matcher, @id, self)
    end

    def find(matcher)
      nodes_to_scan = [self]
      until nodes_to_scan.empty?
        node = nodes_to_scan.pop
        return node if node.match_id(matcher)

        nodes_to_scan = node.childs + nodes_to_scan
      end
    end

    def find_all(matcher)
      found_nodes = []
      nodes_to_scan = [self]

      until nodes_to_scan.empty?
        node = nodes_to_scan.pop
        found_nodes.push(node) if node.match_id(matcher)

        nodes_to_scan = node.childs + nodes_to_scan
      end

      found_nodes
    end
  end

  # the first parent, which contains a tk_widget, which is really different from
  # self.tk_widget
  def get_container_parent
    container = @parent
    while container.tk_widget == tk_widget
      return unless container.parent # not in a grid?

      container = container.parent
    end
    container
  end

  # returns the bounding box of the tk_widget
  def cell_bbox
    return unless (container = get_container_parent)

    grid_info = TkGrid.info(tk_widget)
    start_col = grid_info['column']
    end_col = start_col + grid_info['columnspan'] - 1
    start_row = grid_info['row']
    end_row = start_row + grid_info['rowspan'] - 1

    TkGrid.bbox(container.tk_widget, start_col, start_row, end_col, end_row)
  end
end
