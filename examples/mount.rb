# frozen_string_literal: true

require_relative '../lib/tkwrapper'

include TkWrapper
include TkWrapper::Widgets

manager = Manager.new

manager.config(
  root: {
    weights: { rows: [0, 0, 0], cols: [1, 1] }
  },

  l1: {
    grid: { row: 0, column: 0 }
  },

  l2: {
    grid: { row: 0, column: 1 }
  },

  l3: {
    grid: { row: 1, column: 0 }
  },

  l4: {
    grid: { row: 1, column: 1 }
  },

  l5: {
    grid: { row: 2, column: 0 }
  },

  show_button: {
    grid: { row: 2, column: 1 }
  }
)

root = Root.new(
  manager: manager,
  ids: :root,
  childs: [
    MountPoint.new(ids: :m1),
    MountPoint.new(ids: :m2),
    MountPoint.new(ids: :m3),
    MountPoint.new(ids: :m4),
    MountPoint.new(ids: :m5),
    MountPoint.new(ids: :m6)
  ]
)

manager.widgets[:m1].mount(Label.new(ids: :l1))
manager.widgets[:m2].mount(Label.new(ids: :l2))
manager.widgets[:m3].mount(Label.new(ids: :l3))
manager.widgets[:m4].mount(Label.new(ids: :l4))
#manager.widgets[:m5].mount(Label.new(ids: :l5))
manager.widgets[:m6].mount(Button.new(ids: :show_button))

manager.widgets.iter(Label).each do |match|
  match.tk_widget.text = match.widget.ids[0]
end

manager.widgets[:show_button].tk_widget.text = 'Mount new Widget!'
manager.widgets[:show_button].tk_widget.command = proc do
  unless manager.widgets[:l5]
    manager.widgets[:m5].mount(Label.new(ids: :l5))
    manager.widgets[:l5].tk_widget.text = 'I\'m here!'
  end
end

Tk.mainloop
