# frozen_string_literal: true

# single 'match' as part of a Matches object
class TkWrapper::Widgets::Base::Match
  attr_reader :key, :widget, :match

  def initialize(key, widget, match)
    @key = key
    @widget = widget
    @match = match
  end

  def tk_widget
    @widget.tk_widget
  end
end
