# frozen_string_literal: true

require_relative '../lib/tkwrapper'

include TkWrapper
include TkWrapper::Widgets

manager = Manager.new

Root.new(
  manager: manager,
  ids: :root,
  childs: Grid.new(
    ids: :grid,
    config: { grid: :fullcell },
    childs: [
      [Label.new(ids: :l1), Label.new(ids: :l2)],
      [Frame.new(ids: :f3), Frame.new(ids: :f4)]
    ]
  )
)

manager.widgets[:f3].push(Label.new(ids: :l3, config: { grid: :fullcell }))
manager.widgets[:f4].push(Label.new(ids: :l4, config: { grid: :fullcell }))

manager.widgets.iter(Label).each_with_index do |match, index|
  puts match.tk_widget.grid_info
  match.tk_widget.text = "Label Nr. #{index}"
end

Tk.mainloop
