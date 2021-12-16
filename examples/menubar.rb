# frozen_string_literal: true

require 'tk'

require_relative '../lib/tkwrapper'

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
