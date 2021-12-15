# frozen_string_literal: true

require 'tk'

require "#{LIB_DIR}/tk_extensions"
require "#{LIB_DIR}/util/tk/font"

require_relative 'base'

class TkWrapper::Widgets::Base::Widget
  include TkExtensions

  attr_accessor :config
  attr_reader :parent, :childs, :ids

  def tk_class() end

  def self.manager
    @manager ||= TkWrapper::Widgets::Base::Manager.new
  end

  def self.config(matcher = nil, configuration = nil, **configurations)
    manager.add_configurations(matcher, configuration, **configurations)
  end

  def self.modify(matcher, &callback)
    manager.add_modification(matcher, &callback)
  end

  def manager
    TkWrapper::Widgets::Base::Widget.manager
  end

  def initialize(config: {}, childs: [], id: nil)
    @config = TkWrapper::Widgets::Base::Configuration.new(config)
    @childs = childs.is_a?(Array) ? childs : [childs]
    @ids = []
    add_ids(id)
    add_ids(config[:id])
  end

  def add_ids(ids)
    return unless ids

    ids = [ids] unless ids.is_a?(Array)
    @ids.concat(ids)
  end

  def create_tk_widget(parent)
    tk_class = @config[:tk_class] || self.tk_class

    return unless tk_class

    parent&.tk_widget ? tk_class.new(parent.tk_widget) : tk_class.new
  end

  # if parent is provided and self has no tk_class, the tk_widget of the
  # parent is returned, if parent is not nil
  def tk_widget(parent = @parent)
    return @tk_widget if @tk_widget

    (@tk_widget = create_tk_widget(parent)) || parent&.tk_widget
  end

  def build(parent, configure: true)
    @parent = parent
    tk_widget # creates the widget if possible and not yet created
    @font = TkWrapper::Util::Tk::Font.new(tk_widget)
    self.configure if configure
    manager.execute_modifications(self)
    @childs.each { |child| child.build(self) }
  end

  def push(child)
    @childs.push(child)
    child.build(self)
  end

  def configure
    @config.merge_global_configurations(manager, self)
    @config.configure_tk_widget(tk_widget)
    @config.configure_tearoff
  end

  def check_match(matcher)
    case matcher
    when Regexp
      @ids.any? { |id| if (match = matcher.match(id)) then return match end }
    when String, Symbol
      @ids.any? { |id| id == matcher }
    when nil
      true
    else
      is_a?(matcher)
    end
  end

  def find(matcher)
    nodes_to_scan = [self]
    until nodes_to_scan.empty?
      node = nodes_to_scan.pop
      return node if node.check_match(matcher)

      nodes_to_scan = node.childs + nodes_to_scan
    end
  end

  def find_all(matchers)
    matchers = [matchers] unless matchers.is_a?(Array)

    matches = TkWrapper::Widgets::Base::Matches.new

    nodes_to_scan = [self]
    until nodes_to_scan.empty?
      node = nodes_to_scan.shift
      matches.add_with_multiple_matchers(node, matchers)
      nodes_to_scan += node.childs
    end

    matches
  end

  def modify(matchers, &callback)
    items = find_all(matchers)

    callback.call(items)
  end

  def modify_each(matchers, &callback)
    items = find_all(matchers)

    return unless items

    with_match = items[0].is_a?(Array)

    items.each do |item|
      with_match ? callback.call(item[0], item[1]) : callback.call(item)
    end
  end

  private

  def find_all_single(matcher)
    found_nodes = []
    nodes_to_scan = [self]

    until nodes_to_scan.empty?
      node = nodes_to_scan.pop
      match = node.check_match(matcher)
      found_nodes.push([node, match, matcher]) if match
      nodes_to_scan = node.childs + nodes_to_scan
    end

    found_nodes
  end
end

# the first parent, which contains a tk_widget, which is really different
# from self.tk_widget
def get_container_parent
  container = @parent
  while container.tk_widget == tk_widget
    return unless container.parent # not in a grid?

    container = container.parent
  end
  container
end

# returns the bounding box of the tk_widget
def cell_bbox
  return unless (container = get_container_parent)

  grid_info = TkGrid.info(tk_widget)
  start_col = grid_info['column']
  end_col = start_col + grid_info['columnspan'] - 1
  start_row = grid_info['row']
  end_row = start_row + grid_info['rowspan'] - 1

  TkGrid.bbox(container.tk_widget, start_col, start_row, end_col, end_row)
end
