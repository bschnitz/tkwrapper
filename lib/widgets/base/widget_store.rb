# frozen_string_literal: true

require "#{LIB_DIR}/util/tk/finder"
require_relative 'comparator_item_store'

class TkWrapper::Widgets::Base::WidgetStore
  extend Forwardable

  def_delegators :@finder, :find, :find_all

  def initialize
    @lookup = {}
    @finder = TkWrapper::Util::Tk::Finder.new(widgets: self, lookup: @lookup)
  end

  def push(widget)
    widget.ids.each do |id|
      (@lookup[id] ||= []).push(widget)
    end
  end

  def each(&block)
    @lookup.each_value do |widgets|
      widgets.each { |widget| block.call(widget) }
    end
  end

  def [](key)
    @lookup[key].size == 1 ? @lookup[key].first : @lookup[key]
  end

  private

  def map_key?(key)
    [String, Symbol].include?(key)
  end
end
