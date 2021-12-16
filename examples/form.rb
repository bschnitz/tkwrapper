# frozen_string_literal: true

require 'tk'
require 'tkextlib/tile'

require_relative '../lib/tkwrapper'

Tk.appname('TkWrapperExampleForm')

include TkWrapper
include TkWrapper::Widgets

manager = Manager.new

def entry(label, id)
  [
    Label.new(config: { text: label, grid: { padx: 5, pady: 5 } }),
    AutoResizeEntry.new(ids: id, config: {grid: { sticky: 'nw', pady: 5 } })
  ]
end

manager.config(
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
  manager: manager,
  config: { grid: :onecell },
  childs: [
    Grid.new(
      ids: :outer_grid,
      childs: [
        Grid.new(
          ids: :entries,
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
