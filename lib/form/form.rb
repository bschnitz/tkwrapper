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
    attr_accessor :parent
    attr_reader :grid

    def initialize(childs: [])
      @elements = []
      @childs = childs
    end

    def add_element(id, element)
      @elements.push({ id: id, element: element })
    end

    def add_entry(id: nil, label: nil, value: '')
      @elements.push(FormEntry.new(@parent, id: id, label: label, value: value))
    end

    def build(parent)
      @parent = parent
      @grid = Grid.new(parent)

      create_elements_from_childs

      @elements.each do |element|
        @grid.add_row(element.matrix)
      end

      @grid.cols[1].weight = 1
      @grid.each { |cell| cell.widget.grid sticky: 'nsw', padx: 2, pady: 2 }

      @grid.build
    end

    def create_elements_from_childs
      return if @childs.empty?

      @childs.each do |child|
        case child[:type]
        when :entry
          add_entry(**child.except(:type))
        end
      end
    end

    def create_entry_grid_row(entry)
      entry.label ? [entry.label, entry.frame] : [entry.frame, :right]
    end
  end
end