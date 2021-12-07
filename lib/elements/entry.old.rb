# frozen_string_literal: true

# wraps some code of Tk to make it more object oriented, provide new
# functionality and to ease usage
module TkWrapper
  require 'tk'
  require 'tkextlib/tile'
  require_relative '../util/multi_bind'

  # easyfied handling of Tkk Entry with autoresize
  class Entry
    # min_width: minimal width in pixel
    # add_width: width to add after determining width via autoresize
    attr_accessor :id, :min_width, :add_width
    attr_reader :entry, :label, :frame

    def initialize(parent, frame = nil)
      @parent = parent
      @frame = frame || Tk::Tile::Frame.new(parent)
      @entry = Tk::Tile::Entry.new(@frame) { textvariable TkVariable.new }
      @min_width = 80
      @add_width = 0
    end

    def value=(value)
      @entry.textvariable.value = value
    end

    def value
      @entry.textvariable.value
    end

    def autoresize
      @parent.class.include(MultiBind)
      @parent.multi_bind('Configure') { resize }
      @entry.textvariable.trace('write') { resize }
    end

    def create_dummy_label_with_same_size(&block)
      label = Tk::Tile::Label.new(@frame)
      label.text = value
      label.place(relx: 0, rely: 0)
      label.lower
      @frame.update
      result = block.call(label)
      label.destroy
      result
    end

    def content_text_size_in_pixel
      return 0 if value.empty?

      create_dummy_label_with_same_size(&:winfo_width)
    end

    def resize
      @entry.width = 0

      content_width = content_text_size_in_pixel
      max_width = @parent.winfo_width
      new_width = [[@min_width, content_width + @add_width].max, max_width].min

      # pad to both directions, so need to devide by 2
      @entry.grid(ipadx: new_width / 2.0)
    end
  end
end
