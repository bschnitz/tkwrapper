# frozen_string_literal: true

require_relative 'padding'

class TkWrapper::Widgets::Base::TkOptions
  attr_reader :padding

  def self.default_to_zero(*properties)
    properties.each do |property|
      define_method(property) do
        value = @widget.tk_widget[property]
        value.is_a?(Numeric) ? value : 0
      end
    end
  end

  default_to_zero :padx, :insertwidth, :borderwidth,
                  :spacing1, :spacing2, :spacing3

  def initialize(widget)
    @widget = widget
    @padding = TkWrapper::Widgets::Base::Padding.new(@widget)
  end

  def padding=(hash)
    @padding.set(**hash)
  end

  def method_missing(key, value = nil)
    if key[-1] == '='
      @widget.tk_widget[key[0..-2].to_sym] = value
    else
      @widget.tk_widget[key]
    end
  end

  def respond_to_missing?(*)
    # no known way to check if tk_widget[key] exists
    false
  end
end
