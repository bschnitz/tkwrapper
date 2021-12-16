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

```ruby
require 'tk'
require 'tkextlib/tile'
require 'tkwrapper'

manager = Manager.new

manager.config(:root, {
  geometry: '800x600',
  grid: { weights: { rows: [1], cols: [1] } }
})

manager.config(:grid, {
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
  Label.new(config: { text: text }, ids: "label.#{color}")
end

manager.config(/label/, {
  grid: { padx: 10, pady: 10, sticky: 'nsew' },
  anchor: 'center'
})

# configure labels using their id and the color in their id
manager.modify(/label\.([a-z]*)/) do |label, m|
  label.tk_widget['background'] = m.match[1]
end

# create the labels
labels = (0..6).map { |number| randomcolor_label(number) }

# put those labels into the grid; :right and :bottom span them over columns/rows
root = Root.new(
  manager: manager,
  ids: :root,
  childs: Grid.new(
    ids: :grid,
    childs: [
      [labels[0], :right,    labels[1], labels[2]],
      [:bottom,   nil,       labels[3], :bottom],
      [labels[4], labels[5], labels[6], :right]
    ]
  )
)

Tk.mainloop
```

#### Form

```ruby
require 'tk'
require 'tkextlib/tile'

require 'tkwrapper'

manager = Manager.new

def entry(label, id)
  [
    Label.new(config: { text: label, grid: { padx: 5, pady: 5 } }),
    AutoResizeEntry.new(ids: id, config: {grid: { sticky: 'nw', pady: 5 } })
  ]
end

manager.config(
  outer_grid: {
    grid: {
      weights: { rows: [0, 1], cols: [1] },
      column: 0, row: 0, sticky: 'nsew'
    }
  },

  entries: {
    grid: {
      sticky: 'nw',
      weights: { cols: [0, 1] }
    }
  }
)

Root.new(
  manager: manager,
  config: { grid: :onecell },
  childs: [
    Grid.new(
      ids: :outer_grid,
      childs: [
        Grid.new(
          ids: :entries,
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

```ruby
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
        { label: 'New', command: -> { puts 'new File' } },
        { label: 'Open...', command: -> { puts 'open File' } },
        { label: 'Close', command: -> { puts 'close File' } }
      ]
    }, {
      config: { label: 'Edit' },
      structure: []
    }]
  )
)

Tk.mainloop
```
