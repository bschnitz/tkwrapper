# frozen_string_literal: true

require 'tk'
require 'tkextlib/tile'

require_relative '../lib/tkwrapper'

class GridExample
  include TkWrapper

  def initialize
    root = TkRoot.new

    TkGrid.columnconfigure(root, 0, weight: 1)
    TkGrid.rowconfigure(root, 0, weight: 1)

    configure_styles

    frame = Tk::Tile::Frame.new(root)
    frame.grid padx: 10, pady: 10
    form = Form.new(frame)

    form.add_entry(:title,      labeltext: 'Title:')
    form.add_entry(:year,       labeltext: 'Year:')
    form.add_entry(:categories, labeltext: 'Categories:')
    form.add_entry(:other)

    form.build

    Tk.mainloop
  end
end

GridExample.new
