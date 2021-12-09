# frozen_string_literal: true

puts "$0            : #{$0}"
puts "__FILE__      : #{__FILE__}"
puts "$PROGRAM_NAME : #{$PROGRAM_NAME}"

$0 = 'bla'

require 'tk'
require 'tkextlib/tile'

require_relative '../lib/tkwrapper'

include TkWrapper

Tk::Tile::Style.configure('Visible.TFrame', { background: '#e784e7' })
Tk::Tile::Style.configure('Border.TFrame', { borderwidth: 2 })

Widget.config(:container) do |_|
  {
    grid: {
      column: 0,
      row: 0,
      padx: 5,
      pady: 5,
      sticky: 'nsew',
      weights: { rows: [1], cols: [1] }
    }
  }
end

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
