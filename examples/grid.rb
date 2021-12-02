# frozen_string_literal: true

require 'tk'
require 'tkextlib/tile'

require_relative '../lib/tkwrapper'

class GridExample
  include TkWrapper

  def initialize
    root = TkRoot.new
    content = Tk::Tile::Frame.new(root)

    l1 = Tk::Tile::Label.new(content) { text '1'; background 'yellow'; justify 'center' }
    l2 = Tk::Tile::Label.new(content) { text '2'; background 'green' }
    l3 = Tk::Tile::Label.new(content) { text '3'; background 'yellow' }
    l4 = Tk::Tile::Label.new(content) { text '4'; background 'green' }
    l5 = Tk::Tile::Label.new(content) { text '5'; background 'yellow' }
    l6 = Tk::Tile::Label.new(content) { text '6'; background 'green' }
    l7 = Tk::Tile::Label.new(content) { text '7'; background 'yellow' }

    grid = Grid.new(content)

    grid.matrix = [
      [l2,      :right, l3, l7],
      [:bottom, nil,    l4, :bottom],
      [l5,      l6,     l1, :right]
    ]

    # same as:
    # grid
    #   .add_row([l2, :right, l3, l7])
    #   .add_row([:bottom, nil,    l4, :bottom])
    #   .add_row([l5,      l6,     l1, :right], build: true)

    grid.each do |cell|
      cell.widget.grid sticky: 'nsew', padx: 5, pady: 5
      cell.widget.configure(anchor: 'center')
    end

    grid.rows.each { |row| row.weight = 1 }
    grid.cols.each { |col| col.weight = 1 }

    # try:
    # grid.cols[2].weight = 2
    # and resize the window

    TkGrid.columnconfigure( root, 0, :weight => 1 )
    TkGrid.rowconfigure( root, 0, :weight => 1 )

    Tk.mainloop
  end
end

GridExample.new
