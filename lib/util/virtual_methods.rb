# frozen_string_literal: true

# wraps some code of Tk to make it more object oriented, provide new
# functionality and to ease usage
module TkWrapper
  # used to be abled to define virtual methods in a class which is extended by
  # this module
  module VirtualMethods
    # error thrown, when a virtual method is called
    class VirtualMethodCalledError < RuntimeError
      def initialize(name)
        super("Virtual function '#{name}' called.")
      end
    end

    def virtual(method)
      define_method(method) { raise VirtualMethodCalledError, method }
    end
  end
end
