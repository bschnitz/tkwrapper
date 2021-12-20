# frozen_string_literal: true

class TkWrapper::Widgets::MountPoint < TkWrapper::Widgets::Base::Widget
  def initialize(**args)
    super(**args)
  end

  def build_childs(skip: true)
    super() unless skip
  end

  def mount=(childs)
    mount(childs)
  end

  def mount(childs = nil)
    if childs
      @childs = childs.is_a?(Array) ? childs : [childs]
    end
    @childs.each do |child|
      child.config.merge(@config)
    end
    build_childs(skip: false)
  end
end
