# frozen_string_literal: true

class TkWrapper::Widgets::Root < TkWrapper::Widgets::Base::Widget
  def initialize(**arguments)
    super(**arguments)
    build(nil)
  end

  def tk_class
    TkWidgets::TkRoot
  end
end
