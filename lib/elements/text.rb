# frozen_string_literal: true

module TkWrapper
  require_relative './widget/widget'

  class Text < Widget
    def tk_class
      TkWidgets::TkText
    end
  end
end
