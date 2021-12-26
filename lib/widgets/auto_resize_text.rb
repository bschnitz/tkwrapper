# frozen_string_literal: true

require_relative 'text'

class TkWrapper::Widgets::AutoResizeText < TkWrapper::Widgets::Frame
  attr_reader :text

  def initialize(**args)
    @min_number_chars = 8
    @min_number_lines = 2

    super(**args)

    @longest_line_width = 0
    @config.merge({ grid: :onecell }, overwrite: false)
  end

  def create_childs
    @text = Text.new(config: {
      grid:   { sticky: 'nsew' },
      width:  @min_number_chars,
      height: @min_number_lines
    })
  end

  def build(parent, **args)
    super(parent, **args)
    @text.bind('<Modified>', &method(:autoresize))
    TkGrid.propagate(tk_widget, 0)
    resize(lines: @min_number_lines, chars: @min_number_chars)
    #@text.resize(lines: @min_number_lines, chars: @min_number_chars)
  end

  # width of cursor + borders (textfield + frame) + padding (textfield + frame)
  def additional_width_needed_for_textfield
    @text.opts.insertwidth +
      @text.accumulated_border_and_padding_width +
      accumulated_border_and_padding_width
  end

  def additional_height_needed_for_textfield
    # TODO: cursor height?
    @text.accumulated_border_and_padding_height +
      accumulated_border_and_padding_height
  end

  def width_needed_for_chars(num_chars)
    text.font.char_width * num_chars + additional_width_needed_for_textfield
  end

  def height_needed_for_lines(num_lines)
    @text.height_of_lines(num_lines) + additional_height_needed_for_textfield
  end

  def resize(height: nil, width: nil, lines: nil, chars: nil)
    width  = width_needed_for_chars(chars)  if chars
    height = height_needed_for_lines(lines) if lines

    opts.width  = width  if width
    opts.height = height if height
  end

  def width_needed_for_textfield
    @text.longest_line_width + additional_width_needed_for_textfield
  end

  def height_needed_for_textfield
    @text.height_of_lines + additional_height_needed_for_textfield
  end

  def max_width
    [@cell.bbox[2], 0].max
  end

  def min_width
    [max_width, width_needed_for_chars(@min_number_chars)].min
  end

  def min_height
    height_needed_for_lines(@min_number_lines)
  end

  def autoresize
    return unless @text.tk_widget.modified?

    width  = [[min_width,  width_needed_for_textfield].max, max_width].min
    height = [min_height, height_needed_for_textfield].max

    resize(height: height, width: width)

    @text.tk_widget.modified(false)
  end
end
