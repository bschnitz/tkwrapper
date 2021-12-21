# frozen_string_literal: true

require "#{LIB_DIR}/util/hash_recursive.rb"

require_relative 'base'

class TkWrapper::Widgets::Base::Configuration
  attr_reader :config

  GRID_SPECIAL_VALUES = {
    onecell: {
      weights: { rows: [1], cols: [1] }
    },
    fullcell: {
      column: 0, row: 0, sticky: 'nsew'
    },
    default: {
      weights: { rows: [1], cols: [1] },
      column: 0, row: 0, sticky: 'nsew'
    }
  }.freeze

  NON_TK_OPTIONS = %i[
    tk_class tearoff weights menu min_width add_width
  ].freeze

  def initialize(config)
    @config = parse_and_clone(config)
  end

  def merge(*configurations, overwrite: true)
    configurations = configurations.map do |configuration|
      configuration = configuration.config if configuration.is_a?(self.class)

      parse_and_clone(configuration)
    end

    Util.merge_recursive!(@config, *configurations, overwrite: overwrite)
  end

  def [](key)
    key = key.to_sym
    return self.class.new(@config[key]) if @config[key].is_a?(Hash)

    @config[key]
  end

  def []=(key, value)
    key = key.to_sym
    @config[key] = parse_and_clone(value, key)
  end

  def parse_and_clone(value, key = nil)
    return parse_value(key, value) unless value.is_a?(Hash)

    value.each_with_object({}) { |(k, v), h| h[k] = parse_and_clone(v, k) }
  end

  def parse_value(key, value)
    case key
    when :grid
      parse_grid_value(value)
    else
      value
    end
  end

  def parse_grid_value(value)
    return GRID_SPECIAL_VALUES[value] if value.is_a?(Symbol)

    value
  end

  def grid(only_tk_options: false)
    return @config[:grid] unless only_tk_options

    @config[:grid].reject { |option, _| NON_TK_OPTIONS.include?(option) }
  end

  def configure_grid(tk_widget)
    grid = grid(only_tk_options: true)
    return if grid.empty?

    tk_widget.grid(grid)
  end

  def configure_tk_widget(tk_widget)
    @config.each do |option, value|
      next if NON_TK_OPTIONS.include?(option)

      case option
      when :grid  then configure_grid(tk_widget)
      when :pack  then tk_widget.pack(value)
      when :place then tk_widget.place(value)
      else             tk_widget[option] = value
      end
    end

    configure_weights(tk_widget)
  end

  def configure_weights(tk_widget)
    return unless (weights = @config.dig(:grid, :weights))

    (weights[:rows] || []).each_with_index do |weight, index|
      TkGrid.rowconfigure(tk_widget, index, weight: weight)
    end

    (weights[:cols] || []).each_with_index do |weight, index|
      TkGrid.columnconfigure(tk_widget, index, weight: weight)
    end
  end

  def configure_tearoff
    return if (tearoff = @config[:tearoff]).nil?

    TkOption.add '*tearOff', (tearoff ? 1 : 0)
  end

  def merge_global_configurations(manager, widget)
    return unless manager

    merge(*manager.configurations(widget))
  end
end
