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
    parent.tk_widget.bind('Configure') { resize(:configure) }
    tk_widget.textvariable = TkVariable.new unless tk_widget.textvariable
    tk_widget.textvariable.trace('write') { resize(:write) }
    resize(:init)
  end

  def value=(value)
    tk_widget.textvariable.value = value
  end

  def value
    tk_widget.textvariable.value
  end

  def config_for_dummy_label
    grid_info = TkGrid.info(tk_widget)
    { config: { grid: {
      row: grid_info['row'],
      column: grid_info['column'],
      columnspan: grid_info['columnspan'],
      sticky: 'nw'
    } } }
  end

  def create_dummy_label
    label = TkWrapper::Widgets::Label.new(**config_for_dummy_label)
    label.build(@parent)
    label.tk_widget.lower
    label
  end

  def with_dummy_label(&block)
    if @label
      TkGrid.grid(@label.tk_widget)
    else
      @label = create_dummy_label
    end
    result = block.call(@label)
    TkGrid.remove(@label.tk_widget)
    result
  end

  def text_width_in_pixel
    with_dummy_label do |label|
      label.tk_widget.text = value
      @parent.tk_widget.update
      label.tk_widget.winfo_width
    end
  end

  def resize(type)
    max_width = cell_bbox[2]
    @text_width = text_width_in_pixel unless
      type == :configure && @text_width
    new_width = [[@min_width, @text_width + @add_width].max, max_width].min
    tk_widget.width = 0
    tk_widget.grid(ipadx: new_width / 2.0)
    @parent.tk_widget.update
  end
end
