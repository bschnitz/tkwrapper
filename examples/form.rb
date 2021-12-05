# frozen_string_literal: true

require 'tk'
require 'tkextlib/tile'

require_relative '../lib/tkwrapper'

def configure_styles
  #Tk::Tile::Style.theme_use 'clam'
  Tk::Tile::Style.configure('TEntry', { padding: 3 })
  Tk::Tile::Style.configure('TLabelframe', { padding: '5 0 5 5' })
  #Tk::Tile::Style.configure('TLabel', { background: 'blue' })
end

class GridExample
  include TkWrapper

  def initialize
    root = TkRoot.new
    #root.geometry('800x600')

    TkGrid.columnconfigure(root, 0, weight: 1)
    TkGrid.rowconfigure(root, 0, weight: 1)

    configure_styles

    frame = Tk::Tile::Frame.new(root)
    frame.grid padx: 10, pady: 10
    form = Form.new(frame)

    form.add_entry(
      id: :title,
      label: { type: :frame, text: 'Title' },
      value: 'Die Geschichte vom Mönch'
    )

    form.add_entry(id: :year,       label: 'Year:')
    form.add_entry(id: :categories, label: 'Categories:')

    form.build

    #root.update
    #puts frame.winfo_width

    Tk.mainloop
  end
end

GridExample.new
