# frozen_string_literal: true

LIB_DIR = __dir__

module TkWrapper end

require_relative 'widgets/widgets'

module TkWrapper
  Widget = TkWrapper::Widgets::Base::Widget
end
