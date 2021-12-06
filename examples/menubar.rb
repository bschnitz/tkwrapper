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
  file.add :command, :label => 'New', :command => proc{newFile}
  file.add :command, :label => 'Open...', :command => proc{openFile}
  file.add :command, :label => 'Close', :command => proc{closeFile}

  Tk.mainloop
end

def classified
  require 'tk'

  require_relative '../lib/tkwrapper'
  include TkWrapper

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
end

concise
