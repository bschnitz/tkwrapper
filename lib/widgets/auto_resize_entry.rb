# frozen_string_literal: true

class TkWrapper::Widgets::AutoResizeEntry < TkWrapper::Widgets::Entry
  # auto resizes on user input, only works if in the grid geometry manager of tk
  attr_accessor :min_width, :add_width

  def initialize(config: {}, childs: [], id: nil)
    @min_width = config[:min_width] || 0
    @add_width = config[:add_width] || 0
    super(config: config, childs: childs, id: id)
  end

  def build(parent, configure: true)
    super(parent, configure: configure)
    parent.tk_widget.bind('Configure') { resize }
    tk_widget.textvariable = TkVariable.new unless tk_widget.textvariable
    tk_widget.textvariable.trace('write') { resize }
    resize
  end

  def value=(value)
    tk_widget.textvariable.value = value
  end

  def value
    tk_widget.textvariable.value
  end

  def resize
    max_width = cell_bbox[2]
    text_width = @font.measure(value)
    new_width = [[@min_width, text_width + @add_width].max, max_width].min
    tk_widget.width = 0
    tk_widget.grid(ipadx: new_width / 2.0)
    @parent.tk_widget.update
  end
end
