# frozen_string_literal: true

class TkWrapper::Widgets::Base::Padding
  def initialize(widget)
    @widget = widget
  end

  def set(left: nil, top: nil, right: nil, bottom: nil)
    values = get
    @widget.tk_widget.padding = [
      left   || values.left,
      top    || values.top,
      right  || values.right,
      bottom || values.bottom
    ]
  end

  def get
    (left, top, right, bottom) = @widget.tk_widget.padding.split

    {
      left:   left   || 0,
      top:    top    || left || 0,
      right:  right  || left || 0,
      bottom: bottom || top  || left || 0
    }
  end

  def left
    get[:left]
  end

  def top
    get[:top]
  end

  def right
    get[:right]
  end

  def bottom
    get[:bottom]
  end

  def left=(left)
    set(left: left)
  end

  def top=(top)
    set(top: top)
  end

  def right=(right)
    set(right: right)
  end

  def bottom=(bottom)
    set(bottom: bottom)
  end
end
