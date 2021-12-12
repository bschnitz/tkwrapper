# frozen_string_literal: true

require "#{LIB_DIR}/util/hash_recursive.rb"

require_relative 'base'

class TkWrapper::Widgets::Base::Configuration
  attr_accessor :config

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

  NON_TK_OPTIONS = %i[id tk_class tearoff weights menu].freeze

  def initialize(config)
    @config = parse!(config)
  end

  def merge!(*configurations)
    configurations = configurations.map do |configuration|
      next configuration.config if configuration.is_a?(self.class)

      parse!(configuration)
    end

    Util.merge_recursive!(@config, *configurations)
  end

  def parse!(config)
    Util.each_recursive(config) do |hash, key, value|
      next if value.is_a?(Hash)

      hash[key] = parse_value(key, value)
    end

    config
  end

  def [](key)
    key = key.to_sym
    return self.class.new(@config[key]) if @config[key].is_a?(Hash)

    @config[key]
  end

  def []=(key, value)
    key = key.to_sym
    @config[key] = parse_value(key, value)
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

  def configure_tk_widget(tk_widget)
    @config.each do |option, value|
      next if NON_TK_OPTIONS.include?(option)

      if option == :grid
        grid = grid(only_tk_options: true)
        next if grid.empty?
        next tk_widget.grid(grid) if option == :grid
      end

      tk_widget[option] = value
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
    merge!(*manager.configurations(widget))
  end
end