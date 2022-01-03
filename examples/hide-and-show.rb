# frozen_string_literal: true

require_relative '../lib/tkwrapper'

include TkWrapper
include TkWrapper::Widgets

manager = Manager.new

Root.new(
  manager: manager,
  ids: :root,
  childs: [
    Label.new(ids: :l5),
    Grid.new(
      ids: :grid,
      config: { grid: :fullcell },
      childs: [
        [Button.new(ids: :toggle), Label.new(ids: :label, config: { hidden: true })],
        [Button.new(ids: :hide), Button.new(ids: :show)]
      ]
    )
  ]
)

manager.widgets[:label].tk_widget.text = 'Hide me!'

manager.widgets[:show].tk_widget.text = 'Show'
manager.widgets[:show].tk_widget.command = proc do
  manager.widgets[:label].visibility.show
end
manager.widgets[:hide].tk_widget.text = 'Hide'
manager.widgets[:hide].tk_widget.command = proc do
  manager.widgets[:label].visibility.hide
end
manager.widgets[:toggle].tk_widget.text = 'Toggle'
manager.widgets[:toggle].tk_widget.command = proc do
  manager.widgets[:label].visibility.toggle
end

Tk.mainloop
