# frozen_string_literal: true

module TkWrapper
  require 'tk'
  require 'tkextlib/tile'
  require_relative './widget'

  class Entry < Widget
    def tk_class
      Tk::Tile::Entry
    end
  end
end
