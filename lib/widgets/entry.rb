# frozen_string_literal: true

require 'tkextlib/tile'

class TkWrapper::Widgets::Entry < TkWrapper::Widgets::Base::Widget
  def tk_class
    Tk::Tile::Entry
  end
end
