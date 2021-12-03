# frozen_string_literal: true

require_relative './form_entry'
require_relative '../grid/grid'

# wraps some code of Tk to make it more object oriented, provide new
# functionality and to ease usage
module TkWrapper
  require 'tk'
  require 'tkextlib/tile'

  # easyfied building of uniform Forms
  class Form
    attr_reader :grid

    def initialize(parent)
      @parent = parent
      @elements = []
      @grid = Grid.new(parent)
    end

    def add_element(id, element)
      @elements.push({ id: id, element: element })
    end

    def add_entry(id: nil, label: nil, value: '')
      @elements.push(FormEntry.new(@parent, id: id, label: label, value: value))
    end

    def build
      @elements.each do |element|
        @grid.add_row(element.matrix)
      end

      @grid.cols[1].weight = 1
      @grid.each { |cell| cell.widget.grid sticky: 'nswe', padx: 2, pady: 2 }

      @grid.build
    end

    def create_entry_grid_row(entry)
      entry.label ? [entry.label, entry.frame] : [entry.frame, :right]
    end
  end

  def configure_styles
    #Tk::Tile::Style.theme_use 'clam'
    Tk::Tile::Style.configure('TEntry', { padding: 3 })
    Tk::Tile::Style.configure('TLabelframe', { padding: '5 0 5 5' })
    #Tk::Tile::Style.configure('TLabel', { background: 'blue' })
  end
end
