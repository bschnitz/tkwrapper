# frozen_string_literal: true

module TkWrapper
  require 'tk'
  require 'tkextlib/tile'
  require_relative './widget'

  class Label < Widget
    def tk_class
      Tk::Tile::Label
    end
  end
end
