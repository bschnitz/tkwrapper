# frozen_string_literal: true

require 'tkextlib/tile'

class TkWrapper::Widgets::Button < TkWrapper::Widgets::Base::Widget
  def tk_class
    Tk::Tile::Button
  end
end
