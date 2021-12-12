# frozen_string_literal: true

require 'tk'
require 'tkextlib/tile'
require_relative '../lib/tkwrapper'

include TkWrapper
include TkWrapper::Widgets

Widget.config(:root, {
  geometry: '800x600',
  grid: { weights: { rows: [1], cols: [1] } }
})

Widget.config(:grid, {
  grid: {
    # the grid itself is in the grid of the root window,
    # make it fill the whole space
    column: 0,
    row: 0,
    sticky: 'nsew',
    # when resized, all columns shall resize equally
    weights: {
      rows: [1, 1, 1],
      cols: [1, 1, 1, 1]
    }
  }
})

# create labels with an id of 'label.color'
# WARNING: random standard colors may produce eye cancer
def randomcolor_label(text)
  color = %w[green blue purple yellow red cyan magenta].sample
  Label.new(config: { text: text, id: "label.#{color}" })
end

Widget.config(/label/, {
  grid: { padx: 10, pady: 10, sticky: 'nsew' },
  anchor: 'center'
})

# configure labels using their id and the color in their id
Widget.modify(/label\.([a-z]*)/) do |label, match|
  label.tk_widget['background'] = match[1]
end

# create the labels
labels = (0..6).map { |number| randomcolor_label(number) }

# put those labels into the grid; :right and :bottom span them over columns/rows
root = Root.new(
  config: { id: :root },
  childs: Grid.new(
    config: { id: :grid, tk_class: TkExtensions::TkWidgets::Frame },
    childs: [
      [labels[0], :right,    labels[1], labels[2]],
      [:bottom,   nil,       labels[3], :bottom],
      [labels[4], labels[5], labels[6], :right]
    ]
  )
)

puts root.find(:grid)
puts root.find(Label)
puts root.find_all(/label/).size

Tk.mainloop
