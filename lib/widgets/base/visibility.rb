# frozen_string_literal: true

class TkWrapper::Widgets::Base::Visibility
  def initialize(widget)
    @widget = widget
    @last_manager = nil
  end

  def hide
    return if @last_manager

    @last_manager = @widget.winfo.manager

    case @last_manager
    when 'grid'  then @widget.tk_widget.grid_remove
    when 'pack'  then @widget.tk_widget.pack_remove
    when 'place' then @widget.tk_widget.place_remove
    else
      warn "cannot hide widget with geometry manager #{@last_manager}"
      @last_manager = nil
    end
  end

  def show
    return unless @last_manager

    case @last_manager
    when 'grid'  then @widget.tk_widget.grid
    when 'pack'  then @widget.tk_widget.pack
    when 'place' then @widget.tk_widget.place
    end

    @last_manager = nil
  end

  def toggle
    @last_manager ? show : hide
  end
end
