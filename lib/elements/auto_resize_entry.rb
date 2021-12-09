# frozen_string_literal: true

require_relative './entry'
require_relative '../tk_extensions/multi_bind_entry'

module TkWrapper
  # auto resizes on user input
  class AutoResizeEntry < Widget
    attr_accessor :min_width, :add_width

    def tk_class
      TkExtensions::MultiBindEntry
    end

    def initialize(config: {}, childs: [])
      super(config: config, childs: childs)
      @min_width = 80
      @add_width = 0
    end

    def build(parent, configure: true)
      super(parent, configure: configure)
      parent.tk_widget.bind('Configure') { resize }
      tk_widget.textvariable = TkVariable.new
      tk_widget.textvariable.trace('write') { resize }
      resize
    end

    def create_dummy_label_with_same_size
      Label.new(config: { grid: { row: 0, column: 0, sticky: 'nw' } })
    end

    def create_dummy_frame_for_label(label)
      grid = if @config[:grid].is_a?(Symbol)
               { row: 0, column: 0, sticky: 'nsew' }
             else
               (@config[:grid] ||= {}).merge({ sticky: 'nsew' })
             end
      dummy_frame = Frame.new(config: { grid: grid }, childs: label)
      dummy_frame.tk_widget.lower
      dummy_frame.build(@parent)
      label.tk_widget.lower
      dummy_frame
    end

    def create_dummy_frame_with_same_size_label(&block)
      dummy_label = create_dummy_label_with_same_size
      dummy_frame = create_dummy_frame_for_label(dummy_label)
      dummy_label.tk_widget.text = tk_widget.textvariable.value
      @parent.tk_widget.update
      result = block.call(dummy_frame, dummy_label)
      dummy_label.tk_widget.destroy
      dummy_frame.tk_widget.destroy
      result
    end

    def textwidth_and_maxwidth_in_pixel
      create_dummy_frame_with_same_size_label do |frame, label|
        { text_width: label.tk_widget.winfo_width,
          max_width: frame.tk_widget.winfo_width }
      end
    end

    def resize
      tk_widget.width = 0
      text_width, max_width = textwidth_and_maxwidth_in_pixel
                              .values_at(:text_width, :max_width)
      new_width = [[@min_width, text_width + @add_width].max, max_width].min
      tk_widget.grid(ipadx: new_width / 2.0)
    end
  end
end
