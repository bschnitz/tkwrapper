# frozen_string_literal: true

require 'tk'
require 'tkextlib/tile'

require_relative '../lib/tkwrapper'

include TkWrapper

Tk::Tile::Style.configure('TEntry', { padding: 3 })
Tk::Tile::Style.configure('TLabelframe', { padding: '5 0 5 5' })

Root.new(
  config: { grid: true },
  childs: Frame.new(
    config: { id: :big_frame, grid: { padx: 10, pady: 10, sticky: 'nsew' } },
    childs: [
      Label.new(
        config: { text: 'It followes nothing', grid: { sticky: 'nsew' } }
      ),
      Placeholder.new(
        config: { id: :nothing, grid: { sticky: 'nsew' } }
      )
    ]
  )
)

TkWrapper::Widget.replace(:nothing) do
  Label.new(config: { text: 'Something' })
end

Tk.mainloop
