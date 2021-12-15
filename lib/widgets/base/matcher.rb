# frozen_string_literal: true

require "#{LIB_DIR}/widgets/base/match"

class TkWrapper::Widgets::Base::Matcher
  Match = TkWrapper::Widgets::Base::Match

  def initialize(widget: nil, matcher: nil, map: {})
    @map = map
    @match_function = curry_match_function(widget, matcher)
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

  def match_regex(widget, matcher)
    matches = widget.ids.filter_map do |id|
      (match = matcher.match(id)) && Match.new(match[0], widget, match)
    end

    matches.empty? ? false : matches
  end

  def match_string(widget, matcher)
    @map[matcher] unless @map.empty?

    widget.ids.any? { |id| return Match.new(id, widget, id) if id == matcher }
  end

  def match_class(widget, matcher)
    widget.is_a?(matcher) && Match.new(matcher.name, widget, matcher)
  end

  def match_func(widget, matcher)
    case matcher
    when Regexp         then match_regex(widget, matcher)
    when String, Symbol then match_string(widget, matcher)
    when Class          then match_class(widget, matcher)
    when nil            then Match.new(nil, widget, nil)
    else                     false
    end
  end

  def curry_match_function(widget, matcher)
    if widget && matcher
      -> { match_func(widget, matcher) }
    elsif widget
      ->(x_matcher) { match_func(widget, x_matcher) }
    elsif matcher
      ->(x_widget)  { match_func(x_widget, matcher) }
    else
      ->(x_widget, x_matcher) { match_func(x_widget, x_matcher) }
    end
  end
end
