# frozen_string_literal: true

require_relative 'matcher'

class TkWrapper::Widgets::Base::ComparatorItemStore
  Matcher = TkWrapper::Widgets::Base::Matcher

  def initialize
    @key_map = {}        # for fast lookup
    @comparator_map = {} # for lookup using comparisons by Matcher class
  end

  def push(key, *items)
    if [String, Symbol].include?(key)
      (@key_map[key] ||= []).concat(items)
    else
      (@comparator_map[key] ||= []).concat(items)
    end
  end

  # returns [{items: [...], match: Match}, {items: [...]}, ...]
  def items_and_matches_for_widget(widget)
    widget.ids.reduce([]) do |items, id|
      items + items_from_key_map(id) + items_from_comparator_map(id, widget)
    end
  end

  private

  def items_from_key_map(id)
    (items = @key_map[id]) ? [{ items: items }] : []
  end

  def items_from_comparator_map(id, widget)
    matcher = Matcher.new(value: id)

    @comparator_map.filter_map do |(comparator, items)|
      (m = matcher.match(comparator, widget)) && { items: items, match: m }
    end
  end
end
