# frozen_string_literal: true

$0 = 'AutoResizeEntry'

require 'tk'
require 'tkextlib/tile'

require_relative '../lib/tkwrapper'

include TkWrapper
include TkWrapper::Widgets

Tk::Tile::Style.configure('Visible.TFrame', { background: '#e784e7' })
Tk::Tile::Style.configure('Border.TFrame', { borderwidth: 2 })

Widget.config(:container, { grid: {
  column: 0,
  row: 0,
  padx: 5,
  pady: 5,
  sticky: 'nsew',
  weights: { rows: [1], cols: [1] }
} })

Root.new(
  config: { grid: :onecell },
  childs: Frame.new(
    config: { id: :container },
    childs: AutoResizeEntry.new(
      config: { grid: { column: 0, row: 0, sticky: 'nw' } }
    )
  )
)

Tk.mainloop
