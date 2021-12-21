# frozen_string_literal: true

require 'tkextlib/tile'

class TkWrapper::Widgets::Label < TkWrapper::Widgets::Base::Widget
  def tk_class
    Tk::Tile::Label
  end
end
