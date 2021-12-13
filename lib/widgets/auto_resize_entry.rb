# frozen_string_literal: true

class TkWrapper::Widgets::AutoResizeEntry < TkWrapper::Widgets::Entry
  # auto resizes on user input, only works if in the grid geometry manager of tk
  attr_accessor :min_width, :add_width

  def initialize(config: {}, childs: [])
    @min_width = config[:min_width] || 0
    @add_width = config[:add_width] || 0
    super(config: config, childs: childs)
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

  def config_for_dummy_label
    grid_info = TkGrid.info(tk_widget)
    { config: { grid: {
      row: grid_info['row'],
      column: grid_info['column'],
      columnspan: grid_info['columnspan'],
      sticky: 'nw'
    } } }
  end

  def create_dummy_label_with_same_size(&block)
    label = TkWrapper::Widgets::Label.new(**config_for_dummy_label)
    label.build(@parent)
    label.tk_widget.text = value
    label.tk_widget.lower
    result = block.call(label)
    label.tk_widget.destroy
    result
  end

  def text_width_in_pixel
    create_dummy_label_with_same_size do |label|
      @parent.tk_widget.update
      label.tk_widget.winfo_width
    end
  end

  def textwidth_and_maxwidth_in_pixel
    create_dummy_frame_with_same_size_label do |frame, label|
      { text_width: label.tk_widget.winfo_width,
        max_width: frame.tk_widget.winfo_width }
    end
  end

  def resize
    max_width = cell_bbox[2]
    text_width = text_width_in_pixel
    new_width = [[@min_width, text_width + @add_width].max, max_width].min
    tk_widget.width = 0
    tk_widget.grid(ipadx: new_width / 2.0)
    @parent.tk_widget.update
  end
end
