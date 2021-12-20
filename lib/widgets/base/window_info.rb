class TkWrapper::Widgets::Base::WindowInfo
  def initialize(widget)
    @widget = widget
  end

  def method_missing(name, *args)
    if @widget.tk_widget.respond_to?("winfo_#{name}")
      @widget.tk_widget.send("winfo_#{name}", *args)
    else
      super
    end
  end
end
