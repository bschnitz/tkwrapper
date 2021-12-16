# frozen_string_literal: true

# single 'match' as part of a Matches object
class TkWrapper::Widgets::Base::Match
  attr_reader :key, :widget, :match

  def initialize(value, cls: nil, match: nil, widget: nil)
    @key = match&.[](0) || value
    @widget = widget
    @match = match
    @cls = cls
    @value = value
  end

  def tk_widget
    @widget&.tk_widget
  end
end
