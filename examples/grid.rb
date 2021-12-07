# frozen_string_literal: true

require 'tk'
require 'tkextlib/tile'

require_relative '../lib/tkwrapper'

include TkWrapper

TkWrapper::Widget.config(:root) do |root|
  root.tk_widget['geometry'] = '800x600'
  # configure root window (as a grid with one row and column
  root.grid[:weights] = { rows: [1], cols: [1] }
end

TkWrapper::Widget.config(:grid) do |grid|
  # when resized, all columns shall resize equally
  grid.grid[:weights] = {
    rows: [1, 1, 1],
    cols: [1, 1, 1, 1]
  }

  # the grid itself is in the grid of the root window,
  # make it fill the whole space
  grid.grid[:column] = 0
  grid.grid[:row]    = 0
  grid.grid[:sticky] = 'nsew'
end

# create labels with an id of 'label.color'
# WARNING: random standard colors may produce eye cancer
def randomcolor_label(text)
  color = %w[green blue purple yellow red cyan magenta].sample
  Label.new(config: { text: text, id: "label.#{color}" })
end

# configure labels using their id and the color in their id
TkWrapper::Widget.config(/label\.([a-z]*)/) do |label, match|
  label.tk_widget.grid(padx: 10, pady: 10, sticky: 'nsew')
  label.tk_widget['anchor'] = 'center'
  label.tk_widget['background'] = match[1]
end

# create the labels
labels = (0..6).map { |number| randomcolor_label(number) }

# put those labels into the grid; :right and :bottom span them over columns/rows
Root.new(
  config: { id: :root },
  childs: Grid.new(
    config: { id: :grid, tk_class: Tk::Tile::TFrame },
    childs: [
      [labels[0], :right,    labels[1], labels[2]],
      [:bottom,   nil,       labels[3], :bottom],
      [labels[4], labels[5], labels[6], :right]
    ]
  )
)

Tk.mainloop
