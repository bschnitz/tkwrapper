# frozen_string_literal: true

require_relative '../util/virtual_methods'

# wraps some code of Tk to make it more object oriented, provide new
# functionality and to ease usage
module TkWrapper
  require 'tk'
  require 'tkextlib/tile'

  class FormElement
    extend VirtualMethods

    def initialize(id: nil)
      @id = id
    end

    virtual def matrix() end
    virtual def value() end
    virtual def value=() end
  end
end
