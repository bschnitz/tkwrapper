require "#{LIB_DIR}/util/tk/cell"
require "#{LIB_DIR}/util/tk/finder"

require_relative 'base'
require_relative 'window_info'

class TkWrapper::Widgets::Base::Widget
  extend Forwardable
  include Enumerable

  def_delegators :@finder, :find, :find_all
  def_delegators :tk_widget, :update
  def_delegator :tk_widget, :bind_append, :bind
  def_delegator :@manager, :widgets, :managed

  attr_accessor :config
  attr_reader :parent, :ids, :cell, :childs, :manager, :winfo

  def tk_class() end

  def initialize(parent: nil, config: {}, childs: [], manager: nil, ids: [], id: [])
    @cell = TkWrapper::Util::Tk::Cell.new(self)
    @winfo = TkWrapper::Widgets::Base::WindowInfo.new(self)
    @finder = TkWrapper::Util::Tk::Finder.new(widgets: self)
    @config = TkWrapper::Widgets::Base::Configuration.new(config)
    @manager = manager
    @ids = init_id(id) + init_id(ids)
    @parent = parent
    modify_configuration(@config)
    @childs = normalize_childs(childs)
    parent&.push(self)
  end

  def init_id(id)
    id.is_a?(Array) ? id : [id]
  end

  def normalize_childs(childs)
    childs = create_childs || childs
    childs.is_a?(Array) ? childs : [childs]
  end

  def create_tk_widget(parent)
    tk_class = @config[:tk_class] || self.tk_class

    return unless tk_class

    tk_class.new(parent&.tk_widget)
  end

  # if parent is provided and self has no tk_class, the tk_widget of the
  # parent is returned, if parent is not nil
  def tk_widget(parent = @parent)
    return @tk_widget if @tk_widget

    (@tk_widget = create_tk_widget(parent)) || parent&.tk_widget
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

  protected

  def build_childs
    @childs.each { |child| child.build(self, manager: @manager) }
  end

  def modify_configuration(config) end

  def create_childs() end

  def before_build(**args) end

  def after_build() end

  def inner_build(configure: true, manager: nil)
    tk_widget # creates the widget if possible and not yet created
    @font = TkWrapper::Util::Tk::Font.new(tk_widget)
    @manager ||= manager
    @config.merge(*@manager.configurations(self), overwrite: false) if @manager
    self.configure if configure
    @manager&.execute_modifications(self)
    @manager&.widgets&.push(self)
    build_childs
  end

  def build(parent, configure: true, manager: nil)
    @parent = parent
    before_build(configure: configure, manager: manager)
    inner_build(configure: configure, manager: manager)
    after_build
  end

  def configure
    @config.configure_tk_widget(tk_widget)
    @config.configure_tearoff
  end
end
