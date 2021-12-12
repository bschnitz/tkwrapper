## TkWrapper

A Wrapper around some tk widgets to use their ease and allow for a cleaner (HTML/CSS like) structure.

### License

MIT

### Installation

```
gem install tkwrapper
```

### Examples

#### Grid

```
require 'tk'
require 'tkextlib/tile'
require 'tkwrapper'

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
```

#### Form

```
require 'tk'
require 'tkextlib/tile'

require 'tkwrapper'

Tk.appname('TkWrapperExampleForm')

include TkWrapper
include TkWrapper::Widgets

def entry(label, id)
  [
    Label.new(config: { text: label, grid: { padx: 5, pady: 5 } }),
    AutoResizeEntry.new(config: { id: id, grid: { sticky: 'nw', pady: 5 } })
  ]
end

Widget.config(:outer_grid, { grid: {
  weights: { rows: [0, 1], cols: [1] },
  column: 0, row: 0, sticky: 'nsew'
} })

Widget.config(:entries, { grid: {
  sticky: 'nw',
  weights: { cols: [0, 1] }
} })

Root.new(
  config: { grid: :onecell },
  childs: [
    Grid.new(
      config: { id: :outer_grid },
      childs: [
        Grid.new(
          config: { id: :entries },
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
```

#### Menubar

```
require 'tk'

require 'tkwrapper'
include TkWrapper
include TkWrapper::Widgets

Root.new(
  childs: Menu.create(
    config: { tearoff: false },
    structure: [{
      config: { label: 'File' },
      structure: [
        { label: 'New', command: proc { new_file } },
        { label: 'Open...', command: proc { open_file } },
        { label: 'Close', command: proc { close_file } }
      ]
    }, {
      config: { label: 'Edit' },
      structure: []
    }]
  )
)

Tk.mainloop
```
