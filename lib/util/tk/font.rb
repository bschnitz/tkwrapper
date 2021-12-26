# frozen_string_literal: true

require 'tk'
require 'forwardable'

require_relative 'tk'

class TkWrapper::Util::Tk::Font
  def initialize(tk_widget)
    @tk_widget = tk_widget
  end

  %i[family size weight slant underline overstrike].each do |option|
    define_method("#{option}=") do |value, **args|
      load unless @config
      args[:update] ||= false
      @config[option] = value
      update if args[:update]
    end

    define_method(option) do
      load unless @config
      @config[option]
    end
  end

  def with_update(&block)
    block.call(self)
    update
  end

  def method_missing(method, *args)
    if TkFont.respond_to?(method)
      TkFont.send(method, @tk_widget.font, *args)
    else
      super
    end
  end

  def respond_to_missing?(method, *)
    TkFont.respond_to?(method) || super
  end

  def load
    @config = TkFont.actual(@tk_widget.font).to_h.transform_keys(&:to_sym)
  end

  def update
    @tk_widget.font = TkFont.new(@config)
  end

  def char_width
    measure('0')
  end

  def linespace
    metrics['linespace']
  end

  def metrics
    @tk_widget.font.metrics.each_with_object({}) do |(key, value), metrics|
      metrics[key] = value
    end
  end
end
