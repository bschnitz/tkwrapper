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
    # grid example
    Grid.new(
      ids: :grid,
      config: { grid: :fullcell },
      childs: [
        [Label.new(ids: :l1), Label.new(ids: :l2)],
        [Frame.new(ids: :f3), Label.new(ids: :l4)]
      ]
    )
  ]
)

# pack example
manager.widgets[:f3].push(
  Label.new(
    ids: :l3,
    config: { pack: { expand: true, fill: 'both' }, background: 'magenta' }
  )
)
manager.widgets[:l3].tk_widget.text = 'Packed Label'

manager.widgets.iter(%i[l1 l2 l4]).each do |match|
  match.tk_widget.text = "Label #{match.key}"
end

# place example
l4_bbox = manager.widgets[:l4].cell.bbox
manager.widgets[:l5].tk_widget['background'] = 'yellow'
manager.widgets[:l5].tk_widget.text = 'Placed Label'
manager.widgets[:l5].tk_widget.place(x: l4_bbox[0] + l4_bbox[2], y: l4_bbox[1] + l4_bbox[3])
manager.widgets[:l5].tk_widget.raise

manager.widgets.iter(Label).each do |match|
  puts "Label :#{match.key} uses the " \
       "#{match.widget.winfo.manager} geometry manager."
end

Tk.mainloop
