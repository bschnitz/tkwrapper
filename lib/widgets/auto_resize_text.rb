# frozen_string_literal: true

require_relative 'text'

class TkWrapper::Widgets::AutoResizeText < TkWrapper::Widgets::Text
  def build(parent, **args)
    super(parent, **args)
    bind('<Modified>', ->(ev) { resize(ev) })
    bind('<Modified>', -> { puts 'hihi' })
  end

  def resize(event)
    return unless tk_widget.modified?

    puts event
    puts 'yes!'
    tk_widget.modified(false)
    #max_width = [@cell.bbox[2], 0].max
    #puts @font.metrics
    #new_width = [[@min_width, text_width + @add_width].max, max_width].min
    #tk_widget.width = 0
    #tk_widget.grid(ipadx: new_width / 2.0)
    #@parent.tk_widget.update
  end
end
