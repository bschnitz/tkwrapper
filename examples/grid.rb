# frozen_string_literal: true

require 'tk'
require 'tkextlib/tile'

require_relative '../lib/tkwrapper'

include TkWrapper

TkWrapper::Widget.config(/label\.([a-z]*)/) do |label, match|
  label.tk_widget.grid(padx: 10, pady: 10, sticky: 'nsew')
  label.tk_widget['anchor'] = 'center'
  label.tk_widget['background'] = match[1]
end

TkWrapper::Widget.config(:grid) do |grid|
  grid.add_config(grid: { weights: {
    rows: [1, 1, 1],
    cols: [1, 1, 1, 1]
  } })
end

Tk::Tile::Style.configure('TFrame', { background: 'purple' })

label1 = Label.new(config: { text: '1', id: 'label.yellow' })
label2 = Label.new(config: { text: '2', id: 'label.green' })
label3 = Label.new(config: { text: '3', id: 'label.yellow' })
label4 = Label.new(config: { text: '4', id: 'label.red' })
label5 = Label.new(config: { text: '5', id: 'label.green' })
label6 = Label.new(config: { text: '6', id: 'label.red' })
label7 = Label.new(config: { text: '7', id: 'label.green' })

Root.new(
  config: { grid: true },
  childs: Frame.new(
    config: { background: :green, grid: { column: 0, row: 0, sticky: 'nsew' } },
    childs: Grid.new(
      config: { id: :grid },
      childs: [
        [label1, :right, label2, label3],
        [:bottom, nil,   label4, :bottom],
        [label5, label6, label7, :right]
      ]
    )
  )
)

Tk.mainloop
