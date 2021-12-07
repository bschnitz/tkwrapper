# frozen_string_literal: true

module TkWrapper
  require 'tk'
  require 'tkextlib/tile'
  require_relative './widget'

  class Entry < Widget
    def tkwidget(parent)
      @tkwidget || Tk::Tile::Entry.new(parent.tkwidget)
    end
  end
end
