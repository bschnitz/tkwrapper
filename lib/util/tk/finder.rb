# frozen_string_literal: true

require "#{LIB_DIR}/widgets/base/manager"
require "#{LIB_DIR}/widgets/base/matcher"
require_relative 'tk'

class TkWrapper::Util::Tk::Finder
  Matcher = TkWrapper::Widgets::Base::Matcher

  def initialize(widgets: nil)
    @widgets = widgets
  end

  def each_widget_match(widgets, matchers, &block)
    widgets.each do |widget|
      widget.ids.each do |id|
        matchers.each do |matcher|
          (match = matcher.match(id, widget)) && block.call(match)
        end
      end
    end
  end

  def find_widget(comparators, widgets = @widgets)
    matchers = create_value_matchers(comparators)

    each_widget_match(widgets, matchers) do |match|
      return match.widget if match
    end
  end

  def find_all_widgets(comparators, widgets = @widgets)
    matchers = create_value_matchers(comparators)
    matches = TkWrapper::Widgets::Base::Matches.new

    each_widget_match(widgets, matchers) do |match|
      matches.push(match)
    end

    matches
  end

  private

  def create_value_matchers(comparators)
    comparators = [comparators] unless comparators.is_a?(Array)
    comparators.map { |comparator| Matcher.new(comparator: comparator) }
  end
end
