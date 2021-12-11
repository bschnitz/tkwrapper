# frozen_string_literal: true

module TkWrapper
  require_relative './widget/widget'

  class Label < Widget
    def tk_class
      TkWidgets::Label
    end
  end
end
