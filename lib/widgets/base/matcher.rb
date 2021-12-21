# frozen_string_literal: true

require "#{LIB_DIR}/widgets/base/match"

class TkWrapper::Widgets::Base::Matcher
  Match = TkWrapper::Widgets::Base::Match

  def initialize(value: nil, comparator: nil)
    @match_function = curry_match_function(value, comparator)
  end

  # args:
  #   []                if widget and matcher were provided on initialization
  #   [widget]          if matcher was provided on initialization
  #   [matcher]         if widget was provided on initialization
  #   [widget, matcher] if neither widget nor matcher were provided on initial.
  def match(*args)
    @match_function.call(*args)
  end

  private

  def match_regex(value, comparator, widget)
    (match = comparator.match(value)) &&
      Match.new(value, match: match, widget: widget)
  end

  def match_string(value, comparator, widget)
    value == comparator && Match.new(value, widget: widget)
  end

  def match_class(value, comparator, widget)
    widget.is_a?(comparator) &&
      Match.new(value, cls: comparator, widget: widget)
  end

  def match_f(value, comparator, widget)
    case comparator
    when String, Symbol then match_string(value, comparator, widget)
    when Regexp         then match_regex(value, comparator, widget)
    when Class          then match_class(value, comparator, widget)
    when nil            then Match.new(value, widget: widget)
    else                     false
    end
  end

  def curry_match_function(value, comparator)
    if value && comparator
      ->(widget)                        { match_f(value, comparator, widget) }
    elsif value
      ->(x_comparator, widget)          { match_f(value, x_comparator, widget) }
    elsif comparator
      ->(x_value, widget)               { match_f(x_value, comparator, widget) }
    else
      ->(x_value, x_comparator, widget) { match_f(x_value, x_comparator, widget) }
    end
  end
end
