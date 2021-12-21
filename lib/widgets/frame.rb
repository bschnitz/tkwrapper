# frozen_string_literal: true

require 'tkextlib/tile'

class TkWrapper::Widgets::Frame < TkWrapper::Widgets::Base::Widget
  def tk_class
    Tk::Tile::Frame
  end
end
