# frozen_string_literal: true


def original
  require 'tk'
  require 'tkextlib/tile'

  root = TkRoot.new {title "Window with Menubar"}
  TkOption.add '*tearOff', 0
  menubar = TkMenu.new(root)
  root['menu'] = menubar
  file = TkMenu.new(menubar)
  edit = TkMenu.new(menubar)
  file.label = 'File'
  menubar.add :cascade, :menu => file
  menubar.add :cascade, :menu => edit, :label => 'Edit'
  file.add :command, :label => 'New', :command => -> { puts 'new File' }
  file.add :command, :label => 'Open...', :command => -> { puts 'open File' }
  file.add :command, :label => 'Close', :command => -> { puts 'close File' }

  Tk.mainloop
end

def classified
  require 'tk'

  require_relative '../lib/tkwrapper'
  include TkWrapper
  include TkWrapper::Widgets

  Root.new(
    childs: Menu.new(
      config: { tearoff: false },
      childs: [
        Menu::Cascade.new(
          config: { label: 'File' },
          childs: [
            Menu::Command.new(
              config: { label: 'New', command: proc { new_file } }
            ),
            Menu::Command.new(
              config: { label: 'Open...', command: proc { open_file } }
            ),
            Menu::Command.new(
              config: { label: 'Close', command: proc { close_file } }
            )
          ]
        ),
        Menu::Cascade.new(
          config: { label: 'Edit' }
        )
      ]
    )
  )

  Tk.mainloop
end

def concise
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
end

concise
