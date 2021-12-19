# frozen_string_literal: true

class TkWrapper::Widgets::MountPoint < TkWrapper::Widgets::Base::Widget
  def initialize(**args)
    raise use_no_config_for_mount_point_error if args['config']

    @build_args = {}

    super(**args)
  end

  def use_no_config_for_mount_point_error
    ArgumentError.new(
      'Don\'t use the config argument for MountPoint. ' \
      'Use it on the mounted childs.'
    )
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
    build_childs(skip: false)
  end
end
