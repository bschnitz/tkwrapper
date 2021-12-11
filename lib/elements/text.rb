# frozen_string_literal: true

module TkWrapper
  require 'tk'
  require 'tkextlib/tile'
  require_relative './widget'

  class Text < Widget
    def tk_class
      TkWidgets::TkText
    end
  end
end
