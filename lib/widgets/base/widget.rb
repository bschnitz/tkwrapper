require "#{LIB_DIR}/util/tk/cell"
require "#{LIB_DIR}/util/tk/finder"
require "#{LIB_DIR}/tk_extensions"

require_relative 'base'

class TkWrapper::Widgets::Base::Widget
  extend Forwardable
  include TkExtensions
  include Enumerable

  def_delegators :@finder, :find, :find_all

  attr_accessor :config
  attr_reader :parent, :ids, :cell, :childs, :manager

  def tk_class() end

  def initialize(config: {}, childs: [], manager: nil, ids: [])
    @cell = TkWrapper::Util::Tk::Cell.new(self)
    @finder = TkWrapper::Util::Tk::Finder.new(widgets: self)
    @config = TkWrapper::Widgets::Base::Configuration.new(config)
    @childs = childs.is_a?(Array) ? childs : [childs]
    @manager = manager
    @ids = ids.is_a?(Array) ? ids : [ids]
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

  def build_childs
    @childs.each { |child| child.build(self, manager: @manager) }
  end

  def build(parent, configure: true, manager: nil)
    @parent = parent
    tk_widget # creates the widget if possible and not yet created
    @font = TkWrapper::Util::Tk::Font.new(tk_widget)
    @manager ||= manager
    @config.merge(*@manager.configurations(self)) if @manager
    self.configure if configure
    @manager&.execute_modifications(self)
    @manager&.widgets&.push(self)
    build_childs
  end

  def configure
    @config.configure_tk_widget(tk_widget)
    @config.configure_tearoff
  end

  def each(&block)
    nodes_to_walk = [self]
    until nodes_to_walk.empty?
      node = nodes_to_walk.pop
      block.call(node)
      nodes_to_walk = node.childs + nodes_to_walk
    end
  end

  def push(child)
    @childs.push(child)
    child.build(self, manager: @manager)
  end
end
