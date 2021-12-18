# frozen_string_literal: true

LIB_DIR = __dir__

module TkWrapper
  module Util
    module Tk
    end
  end
end

require_relative 'widgets/widgets'

module TkWrapper
  Manager = TkWrapper::Widgets::Base::Manager
  Widget = TkWrapper::Widgets::Base::Widget
end
