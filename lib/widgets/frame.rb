# frozen_string_literal: true

require 'tkextlib/tile'

class TkWrapper::Widgets::Frame < TkWrapper::Widgets::Base::Widget
  def tk_class
    Tk::Tile::Frame
  end

  def accumulated_border_and_padding_width
    opts.padding.left + opts.padding.right + 2 * opts.borderwidth
  end

  def accumulated_border_and_padding_height
    opts.padding.top + opts.padding.bottom + 2 * opts.borderwidth
  end
end
