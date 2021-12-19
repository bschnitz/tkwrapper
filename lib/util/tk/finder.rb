# frozen_string_literal: true

require "#{LIB_DIR}/widgets/base/manager"
require "#{LIB_DIR}/widgets/base/matcher"
require "#{LIB_DIR}/widgets/base/matches"

class TkWrapper::Util::Tk::Finder
  Match   = TkWrapper::Widgets::Base::Match
  Matcher = TkWrapper::Widgets::Base::Matcher
  Matches = TkWrapper::Widgets::Base::Matches

  def initialize(widgets: nil, lookup: nil)
    @lookup = lookup
    @widgets = widgets
  end

  def iter(comparators, widgets = @widgets, lookup = @lookup)
    Enumerator.new do |y|
      comparators = each_widget_lookup_match(lookup, comparators) { |m| y << m }
      each_widget_comparator_match(widgets, comparators) { |m| y << m }
    end
  end

  def find(comparators, widgets = @widgets, lookup = @lookup)
    iter(comparators, widgets, lookup, &:itself).first
  end

  def find_all(comparators, widgets = @widgets, lookup = @lookup)
    it = iter(comparators, widgets, lookup, &:itself)
    it.each_with_object(Matches.new) { |match, matches| matches.push(match) }
  end

  private

  def create_value_matchers(comparators)
    comparators = [comparators] unless comparators.is_a?(Array)
    comparators.map { |comparator| Matcher.new(comparator: comparator) }
  end

  def each_widget_lookup_match(lookup, comparators, &block)
    return comparators unless lookup

    comparators.filter do |comparator|
      next true unless [String, Symbol].include?(comparator.class)

      (lookup[comparator] || []).each do |widget|
        block.call(Match.new(comparator, widget: widget))
      end

      false
    end
  end

  def each_widget_comparator_match(widgets, comparators, &block)
    matchers = create_value_matchers(comparators)

    widgets.each do |widget|
      widget.ids.each do |id|
        matchers.each do |matcher|
          (match = matcher.match(id, widget)) && block.call(match)
        end
      end
    end
  end
end
