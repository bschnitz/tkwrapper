# frozen_string_literal: true

require_relative '../lib/tkwrapper'

include TkWrapper
include TkWrapper::Widgets

manager = Manager.new

Root.new(
  manager: manager,
  ids: :root,
  childs: Grid.new(
    childs: [
      [MountPoint.new(ids: :m1), MountPoint.new(ids: :m2)],
      [MountPoint.new(ids: :m3), MountPoint.new(ids: :m4)],
      [MountPoint.new(ids: :m5), MountPoint.new(ids: :m6)]
    ]
  )
)

manager.widgets[:m1].mount(Label.new(ids: :l1))
manager.widgets[:m2].mount(Label.new)
manager.widgets[:m3].mount(Label.new)
manager.widgets[:m4].mount(Label.new)
manager.widgets[:m6].mount(Button.new(ids: :show_button))

manager.widgets.iter(Label).each_with_index do |match, index|
  match.tk_widget.text = "Label Nr. #{index}"
end

manager.widgets[:show_button].tk_widget.text = 'Mount new Widget!'
manager.widgets[:show_button].tk_widget.command = proc do
  unless manager.widgets[:l5]
    manager.widgets[:m5].mount(Label.new(ids: :l5))
    manager.widgets[:l5].tk_widget.text = 'I\'m here!'
  end
end

Tk.mainloop
