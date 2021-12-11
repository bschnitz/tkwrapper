# frozen_string_literal: true

require 'tk'
require 'tkextlib/tile'
require_relative '../lib/tk_extensions'

root = TkRoot.new { title 'Feet to Meters' }
frame = Tk::Tile::Frame.new(root).grid(sticky: 'nsew')
TkGrid.columnconfigure root, 0, weight: 1
TkGrid.rowconfigure root, 0, weight: 1
entry = Tk::Tile::Entry.new(frame)
entry.grid(column: 0, row: 0, sticky: 'we')
mb = TkExtensions::TkWidgets::Entry.new(frame)
mb.grid(column: 1, row: 0, sticky: 'we')
mb.bind('Return') { puts 'First Bind' }
mb.bind('Return') { puts 'Second Bind' }

entry.bind('Return') { puts 'Entry: First Bind' }
entry.bind('Return') { puts 'Entry: Second Bind' }

Tk.mainloop
