# frozen_string_literal: true

require "#{LIB_DIR}/widgets/base/manager"
require "#{LIB_DIR}/widgets/base/matcher"
require_relative 'tk'

class TkWrapper::Util::Tk::Finder
  def initialize(widget)
    @widget = widget
  end

  def wrap_matcher(matcher)
    TkWrapper::Widgets::Base::Matcher.new(matcher: matcher)
  end

  def find(matcher)
    matcher = wrap_matcher(matcher)

    @widget.each { |widget| return widget if matcher.match(widget) }
  end

  def find_all(matchers)
    matchers = [matchers] unless matchers.is_a?(Array)
    matchers = matchers.map(&method(:wrap_matcher))

    matches = TkWrapper::Widgets::Base::Matches.new

    @widget.each do |widget|
      matchers.each do |matcher|
        matches.add(matcher.match(widget))
      end
    end

    matches
  end
end
