# frozen_string_literal: true

require 'tk'
require_relative '../lib/tkwrapper'

include TkWrapper
include TkWrapper::Widgets

manager = Manager.new

manager.config(
  # default configuration for all widgets
  nil => { grid: { sticky: 'nw' } },

  # configuration for the widget with the id ':grid'
  grid: { grid: { weights: { cols: [1] }, sticky: 'nsew' } }
)

root = Root.new(
  manager: manager,
  config: { grid: :onecell },
  childs: Grid.new(
    id: :grid,
    childs: [
      AutoResizeEntry.new(id: :single_bind),
      AutoResizeEntry.new(id: :multi_bind)
    ]
  )
)

manager.widgets[:single_bind].value = 'hallo'
manager.widgets[:single_bind].tk_widget.bind('Return') { puts 'First Bind' }
manager.widgets[:single_bind].tk_widget.bind('Return') { puts 'Second Bind' }

manager.widgets[:multi_bind].value = 'holla'
# same as bind_append for tk_widget:
manager.widgets[:multi_bind].bind('Return') { puts 'First Bind' }
manager.widgets[:multi_bind].bind('Return') { puts 'Second Bind' }

root.update

Tk.mainloop
