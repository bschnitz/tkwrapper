# frozen_string_literal: true

require 'tk'

class TkWrapper::Widgets::Text < TkWrapper::Widgets::Base::Widget
  def tk_class
    TkText
  end

  def pos(key)
    match = tk_widget.index(key).match(/(.*)\.(.*)/)
    [match[1].to_i, match[2].to_i]
  end

  def count_lines
    pos('end')[0] - 1
  end

  def current_line_nr
    pos('insert')[0]
  end

  def value=(value)
    tk_widget.delete('1.0', 'end')
    tk_widget.insert('1.0', value)
  end

  def lines(start_pos = '1.0', end_pos = 'end')
    start_pos = start_pos.is_a?(String) ? start_pos : "#{start_pos}.0"
    end_pos   = end_pos.is_a?(String)   ? end_pos   : "#{end_pos}.0"
    tk_widget.get(start_pos, end_pos).split("\n")
  end

  def longest_line_width
    lines.map { |line| @font.measure(line) }.max || 0
  end

  # includes spacing1 and spacing2 (add. space above and below line)
  # does not include spacing3 (additional space between lines)
  def line_height_including_padding
    # linespace: max height of characters of the font
    # spacing1: additional space above line
    # spacing3: additional space below line
    @font.linespace + opts.spacing1 + opts.spacing3
  end

  def height_of_lines(num_lines = count_lines)
    h = num_lines * line_height_including_padding

    # spacing 3: additional space between lines
    h + [num_lines - 1, 0].max * opts.spacing3
  end

  def resize(lines: nil, chars: nil)
    tk_widget['height'] = lines if lines
    tk_widget['width']  = chars if chars
  end

  def accumulated_border_and_padding_width
    2 * (opts.padx + opts.borderwidth)
  end

  def accumulated_border_and_padding_height
    2 * (opts.pady + opts.borderwidth)
  end
end
