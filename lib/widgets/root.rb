# frozen_string_literal: true

require 'tk'

class TkWrapper::Widgets::Root < TkWrapper::Widgets::Base::Widget
  def initialize(**arguments)
    super(**arguments)
    build(nil)
  end

  def tk_class
    TkRoot
  end
end
