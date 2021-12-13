# frozen_string_literal: true

require 'tk'
require 'tkextlib/tile'

require_relative '../lib/tkwrapper'

Tk.appname('TkWrapperExampleForm')

include TkWrapper
include TkWrapper::Widgets

def entry(label, id)
  [
    Label.new(config: { text: label, grid: { padx: 5, pady: 5 } }),
    AutoResizeEntry.new(config: { id: id, grid: { sticky: 'nw', pady: 5 } })
  ]
end

Widget.config(
  outer_grid: {
    grid: {
      weights: { rows: [0, 1], cols: [1] },
      column: 0, row: 0, sticky: 'nsew'
    }
  },

  entries: {
    grid: {
      sticky: 'nw',
      weights: { cols: [0, 1] }
    }
  }
)

Root.new(
  config: { grid: :onecell },
  childs: [
    Grid.new(
      config: { id: :outer_grid },
      childs: [
        Grid.new(
          config: { id: :entries },
          childs: [
            entry('Title:', :title),
            entry('Year:', :year)
          ]
        ),
        Text.new(config: { grid: { sticky: 'nw' } })
      ]
    )
  ]
)

Tk.mainloop
