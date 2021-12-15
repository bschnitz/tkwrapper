# frozen_string_literal: true

require 'tk'

require "#{LIB_DIR}/tk_extensions"
require "#{LIB_DIR}/util/tk/font"
require "#{LIB_DIR}/util/tk/cell"
require "#{LIB_DIR}/util/tk/finder"

require_relative 'base'

class TkWrapper::Widgets::Base::Widget
  extend Forwardable
  include TkExtensions
  include Enumerable

  def_delegators :@finder, :find, :find_all

  attr_accessor :config
  attr_reader :parent, :childs, :ids, :cell, :childs

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

  def each(&block)
    nodes_to_walk = [self]
    until nodes_to_walk.empty?
      node = nodes_to_walk.pop
      block.call(node)
      nodes_to_walk = node.childs + nodes_to_walk
    end
  end

  def initialize(config: {}, childs: [], id: nil)
    @cell = TkWrapper::Util::Tk::Cell.new(self)
    @finder = TkWrapper::Util::Tk::Finder.new(self)
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
end
