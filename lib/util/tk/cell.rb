# frozen_string_literal: true

require_relative 'tk'

class TkWrapper::Util::Tk::Cell
  def initialize(widget)
    @widget = widget
  end

  # returns the bounding box of the tk_widget
  def bbox
    return unless (container = container_parent)

    grid_info = TkGrid.info(@widget.tk_widget)
    start_col = grid_info['column']
    end_col = start_col + grid_info['columnspan'] - 1
    start_row = grid_info['row']
    end_row = start_row + grid_info['rowspan'] - 1

    container.tk_widget.update
    TkGrid.bbox(container.tk_widget, start_col, start_row, end_col, end_row)
  end

  private

  # the first parent, which contains a tk_widget, which is really different
  # from self.tk_widget
  def container_parent
    container = @widget.parent
    while container.tk_widget == @widget.tk_widget
      return unless container.parent # not in a grid?

      container = container.parent
    end
    container
  end
end
