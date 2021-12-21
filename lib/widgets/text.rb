# frozen_string_literal: true

require 'tk'

class TkWrapper::Widgets::Text < TkWrapper::Widgets::Base::Widget
  def tk_class
    TkText
  end
end
