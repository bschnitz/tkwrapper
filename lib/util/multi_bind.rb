# frozen_string_literal: true

module TkWrapper
  # extension for tk widgets that enables them to execute multiple bindings on
  # the same widget (object) for the same event
  module MultiBind
    def multi_bind(name, &callback)
      @multi_bindings ||= {}

      unless @multi_bindings[name]
        @multi_bindings[name] = []
        bind(name) { execute_multi_bind(name) }
      end

      @multi_bindings[name].push(callback)
    end

    def execute_multi_bind(name)
      @multi_bindings[name].each(&:call)
    end
  end
end
