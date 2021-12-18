# frozen_string_literal: true

require_relative '../lib/tkwrapper'

include TkWrapper
include TkWrapper::Widgets

manager = Manager.new

manager.config(
  root: {
    weights: { rows: [0, 0, 0], cols: [1, 1] }
  },

  hello: {
    grid: { row: 0, column: 0 }
  },

  worlds: {
    grid: { row: 0, column: 1 }
  },

  left: {
    grid: { row: 1, column: 0 }
  },

  right: {
    grid: { row: 1, column: 1 }
  },

  one: {
    grid: { row: 2, column: 0 }
  },

  two: {
    grid: { row: 2, column: 1 }
  }
)

root = Root.new(
  manager: manager,
  ids: :root,
  childs: [
    Label.new(ids: :hello),
    Label.new(ids: :worlds),
    Label.new(ids: %i[label_yellow left]),
    Label.new(ids: %i[label_magenta right]),
    Label.new(ids: :one),
    Label.new(ids: :two)
  ]
)

puts "\nWorking on all labels (match by class)"
root.find_all(Label).each do |(widget, key)|
  widget.tk_widget.grid(padx: 5, pady: 5)
  puts key
end

puts "\nWorking on labels with ids:"

root.find_all(%i[hello worlds left right]).each do |(widget, key)|
  puts "Key: #{key}"
  puts "Widget: #{widget}"
  widget.tk_widget.text = key
end

puts "\nWorking on labels with pattern matching:"
root.find_all(/label_(.*)/).each do |(widget, key, match)|
  puts widget
  puts key
  puts match[1]
  widget.tk_widget['background'] = match[1]
end

# The manager can also be used and is more performant when working on
# Symbol/String ids
matches = manager.widgets.find_all(%i[one two])
matches[:one].tk_widget.text = '1'
matches[:two].tk_widget.text = '2'

# directly accessing the widget lookup of the manager
manager.widgets[:one].tk_widget.text = 'one'

Tk.mainloop
