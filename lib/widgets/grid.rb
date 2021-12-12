# frozen_string_literal: true

# classification of TkGrid
class TkWrapper::Widgets::Grid < TkWrapper::Widgets::Base::Widget
  attr_reader :parent, :matrix

  def tk_class
    TkWidgets::Frame
  end

  def initialize(config: {}, childs: [])
    super(config: config, childs: childs)
    @childs.map! { |row| row.is_a?(Array) ? row : [row] }
    configure_cells_for_grid
    @childs.flatten! && @childs.select! { |cell| cell.is_a?(Widget) }
  end

  def configure_cells_for_grid
    @childs.each_with_index do |row, row_i|
      row.each_with_index do |cell, col_i|
        next unless cell.is_a?(Widget)

        (cell.config[:grid] ||= {}).merge!({ row: row_i, column: col_i })

        configure_colspan(cell, row_i, col_i)
        configure_rowspan(cell, row_i, col_i)
      end
    end
  end

  def configure_colspan(cell, row_i, col_i)
    cols_after_cell = @childs[row_i][(col_i + 1)..]
    colspan = cols_after_cell.reduce(1) do |span, content|
      content == :right ? span + 1 : (break span)
    end
    (cell.config[:grid] ||= {}).merge!({ columnspan: colspan })
  end

  def configure_rowspan(cell, row_i, col_i)
    rows_after_cell = @childs[(row_i + 1)..]
    rowspan = rows_after_cell.reduce(1) do |span, row|
      row[col_i] == :bottom ? span + 1 : (break span)
    end
    (cell.config[:grid] ||= {}).merge!({ rowspan: rowspan })
  end
end
