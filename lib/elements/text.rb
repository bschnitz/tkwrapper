# frozen_string_literal: true

module TkWrapper
  require 'tk'
  require 'tkextlib/tile'
  require_relative './widget'

  class Text < Widget
    def tk_class
      TkText
    end
  end
end
