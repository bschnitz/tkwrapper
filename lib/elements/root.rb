# frozen_string_literal: true

# wraps some code of Tk to make it more object oriented, provide new
# functionality and to ease usage
module TkWrapper
  require_relative './widget/widget'

  class Root < Widget
    def initialize(**arguments)
      super(**arguments)
      build(nil)
    end

    def tk_class
      TkWidgets::TkRoot
    end
  end
end
