# frozen_string_literal: true

module TkWrapper
  require_relative './widget'

  class Entry < Widget
    def tk_class
      TkWidgets::Entry
    end
  end
end
