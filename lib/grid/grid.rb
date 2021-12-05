# frozen_string_literal: true

require_relative './cell'
require_relative './row'
require_relative './col'

# wraps some code of Tk to make it more object oriented, provide new
# functionality and to ease usage
module TkWrapper
  require 'tk'
  require 'tkextlib/tile'
  require_relative '../elements/widget'

  # classification of TkGrid
  class Grid < Widget
    attr_reader :parent, :matrix

    def initialize(config: {}, childs: [])
      super(config: config)
      self.matrix = childs
    end

    def build(parent)
      @parent = parent
      configure(@config)
      each do |cell|
        init_colspan(cell)
        init_rowspan(cell)
        cell.build(parent)
      end
    end

    def matrix=(matrix)
      @matrix = create_cells(matrix)
    end

    def add_row(row, build: false)
      @matrix.push(create_row_cells(row, @matrix.length))

      self.build if build

      self
    end

    def create_row_cells(row, row_i)
      row.each_with_index.map do |content, col_i|
        create_cell(content, row_i, col_i)
      end
    end

    def create_cells(matrix)
      matrix.each_with_index.map do |row, row_i|
        create_row_cells(row, row_i)
      end
    end

    def create_cell(content, row_i, col_i)
      return content unless content.is_a?(Widget)

      Cell.new(content, row_i, col_i)
    end

    def [](row_i, col_i)
      return unless @matrix[row_i][col_i].is_a?(Cell)

      @matrix[row_i][col_i]
    end

    def rows
      @matrix.each_with_index.map { |_, i| Row.new(self, i) }
    end

    def cols
      @matrix.first&.each_with_index&.map { |_, i| Col.new(self, i) }
    end

    def init_colspan(cell)
      cols_after_cell = @matrix[cell.row_index][(cell.col_index + 1)..]
      cell.colspan = cols_after_cell.reduce(1) do |span, content|
        content == :right ? span + 1 : (break span)
      end
    end

    def init_rowspan(cell)
      rows_after_cell = @matrix[(cell.row_index + 1)..]
      cell.rowspan = rows_after_cell.reduce(1) do |span, row|
        row[cell.col_index] == :bottom ? span + 1 : (break span)
      end
    end

    def each(&block)
      @matrix.each do |row|
        row.each do |cell|
          cell.is_a?(Cell) ? block.call(cell) : next
        end
      end
    end
  end
end
