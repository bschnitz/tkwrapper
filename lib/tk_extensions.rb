require 'tk'
require 'tkextlib/tile'

module TkExtensions
  # allow a Tk widget to have multiple bindings for the same event
  module MultiBind
    def bind(event, &callback)
      @bindings ||= {}

      unless @bindings[event]
        @bindings[event] = []
        super(event) { execute_all_bindings(event) }
      end

      @bindings[event].push(callback)
    end

    def execute_all_bindings(event)
      @bindings[event].each(&:call)
    end
  end

  module TkWidgets
    # from several Tk widgets create subclasses, which include MultiBind
    # the reason why we loop over strings and not the classes themselve is, that
    # the class names may be aliases (e.g. Tk::Tile::Entry is an alias for
    # Tk::Tile::TEntry)
    tk_class_names = [
      'TkRoot',          # becomes TkExtensions::TkRoot
      'TkText',          # becomes TkExtensions::TkText
      'TkMenu',          # becomes TkExtensions::TkMenu
      'Tk::Tile::Entry', # becomes TkExtensions::Entry
      'Tk::Tile::Frame', # becomes TkExtensions::Frame
      'Tk::Tile::Label'  # becomes TkExtensions::Label
    ]
    tk_class_names.each do |tk_class_name|
      # extract last part of the name (e.g. Tk::Tile::Entry => Entry)
      new_child_class_name = tk_class_name.match(/([^:]*)$/)[1]
      # get the class from the class constant name
      tk_class = const_get(tk_class_name)
      # create a new child class of tk_class and have it include MultiBind, which
      # overwrites the bind method of that class to allow for multiple bindings
      new_child_class = Class.new(tk_class) { include(MultiBind) }
      # make the new class known to the TkExtensions namespace to allow to use it
      # by e.g. TkExtensions::Entry
      const_set(new_child_class_name, new_child_class)
    end
  end
end
