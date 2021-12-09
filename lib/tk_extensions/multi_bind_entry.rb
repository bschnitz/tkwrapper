require 'tk'
require 'tkextlib/tile'

module TkExtensions
  class MultiBindEntry < Tk::Tile::Entry
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
end
