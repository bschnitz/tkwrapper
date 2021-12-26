# frozen_string_literal: true

$0 = 'AutoResizeEntry'

require 'tk'
require 'tkextlib/tile'

require_relative '../lib/tkwrapper'

include TkWrapper
include TkWrapper::Widgets

Tk::Tile::Style.configure('Visible.TFrame', { background: '#B8F058' })
Tk::Tile::Style.configure('Outer.TFrame', { background: '#B470D2' })
Tk::Tile::Style.configure('Border.TFrame', { borderwidth: 2 })

manager = Manager.new

manager.config(:container, { grid: {
  column: 0,
  row: 0,
  padx: 5,
  pady: 5,
  sticky: 'nsew',
  weights: { rows: [1], cols: [1] }
} })

Root.new(
  manager: manager,
  config: { grid: :onecell },
  childs: Frame.new(
    ids: :container,
    config: { style: 'Outer.TFrame', grid: { weights: { rows: [1], cols: [1] } } },
    childs: AutoResizeText.new(
      config: { grid: { column: 0, row: 0, sticky: 'nw' }, width: 200, height: 200, style: 'Visible.TFrame' }
    )
  )
)

Tk.mainloop
