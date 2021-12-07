# frozen_string_literal: true

require 'tk'
require 'tkextlib/tile'

require_relative '../lib/tkwrapper'

#include TkWrapper

#Tk::Tile::Style.configure('TEntry', { padding: 3 })
#Tk::Tile::Style.configure('TLabelframe', { padding: '5 0 5 5' })
#Tk::Tile::Style.configure('TFrame', { background: 'green' })
#Tk::Tile::Style.configure('TLabelframe', { background: 'blue' })
#Tk::Tile::Style.configure('TLabel', { background: 'blue' })
#
#Root.new(
#  config: { grid: true },
#  childs: Frame.new(
#    config: { grid: { padx: 10, pady: 10, sticky: 'nsew' } },
#    childs: Form.new(
#      childs: [
#        {
#          type: :entry,
#          id: :title,
#          label: { type: :frame, text: 'Title' },
#          value: 'Die Geschichte vom Mönch'
#        },
#        { type: :entry, id: :year, label: 'Year' },
#        { type: :entry, id: :categories, label: 'Categories' }
#      ]
#    )
#  )
#)
#
#Tk.mainloop

include TkWrapper

Root.new(
  config: { grid: true },
  childs: Frame.new(
    config: { grid: { padx: 10, pady: 10, sticky: 'nsew' } },
    childs: Grid.new(
      config: { id: :grid },
      childs: [
        [label, entry]
      ]
    )
  )
)

Tk.mainloop
