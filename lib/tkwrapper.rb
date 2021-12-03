# frozen_string_literal: true

# wraps some code of Tk to make it more object oriented, provide new
# functionality and to ease usage
module TkWrapper
  require 'tk'
  require 'tkextlib/tile'

  # used to be abled to define virtual methods in a class which is extended by
  # this module
  module VirtualMethods
    # error thrown, when a virtual method is called
    class VirtualMethodCalledError < RuntimeError
      def initialize(name)
        super("Virtual function '#{name}' called.")
      end
    end

    def virtual(method)
      define_method(method) { raise VirtualMethodCalledError, method }
    end
  end

  # Row or Col of a Grid
  module GridVector
    def initialize(grid, index)
      @index = index
      @grid = grid
    end

    def weight=(number)
      config weight: number
    end
  end

  # Row of a Grid
  class Row
    include GridVector

    def config(config)
      TkGrid.rowconfigure(@grid.container, @index, config)
    end
  end

  # Column of a Grid
  class Col
    include GridVector

    def config(config)
      TkGrid.columnconfigure(@grid.container, @index, config)
    end
  end

  # Cell in a Grid
  class Cell
    attr_accessor :rowspan, :colspan, :widget
    attr_reader :row_index, :col_index

    def initialize(widget, grid, row_index, col_index)
      @grid = grid
      @widget = widget
      @row_index = row_index
      @col_index = col_index
      @rowspan = 1
      @colspan = 1
    end

    def build
      @widget.grid(
        row: @row_index,
        column: @col_index,
        rowspan: @rowspan,
        columnspan: @colspan
      )
    end
  end

  # classification of TkGrid
  class Grid
    attr_reader :container
    attr_accessor :matrix

    def initialize(container, matrix = [])
      @container = container
      container.grid column: 0, row: 0, sticky: 'nsew'
      self.matrix = matrix
    end

    def build
      each do |cell|
        init_colspan(cell)
        init_rowspan(cell)
        cell.build
      end
    end

    def matrix=(matrix, build: true)
      @matrix = create_cells(matrix)
      self.build if build
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
      return content unless content.is_a?(TkObject)

      Cell.new(content, self, row_i, col_i)
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

  # easyfied handling of Tkk Entry with autoresize
  class Entry
    # min_width: minimal width in pixel
    # add_width: width to add after determining width via autoresize
    attr_accessor :id, :min_width, :add_width
    attr_reader :entry, :label, :frame

    def initialize(parent, frame = nil)
      @parent = parent
      @frame = frame || Tk::Tile::Frame.new(parent)
      @entry = Tk::Tile::Entry.new(@frame) { textvariable TkVariable.new }
      @min_width = 80
      @add_width = 0
    end

    def value=(value)
      @entry.textvariable.value = value
    end

    def value
      @entry.textvariable.value
    end

    def autoresize
      @frame.bind('Configure') { resize }
      @entry.textvariable.trace('write') { resize }
    end

    def create_dummy_label_with_same_size(&block)
      label = Tk::Tile::Label.new(@frame)
      label.text = value
      label.place(relx: 0, rely: 0)
      label.lower
      @frame.update
      result = block.call(label)
      label.destroy
      result
    end

    def content_text_size_in_pixel
      return 0 if value.empty?

      create_dummy_label_with_same_size(&:winfo_width)
    end

    def resize
      @entry.width = 0

      content_width = content_text_size_in_pixel
      max_width = @parent.winfo_width
      new_width = [[@min_width, content_width + @add_width].max, max_width].min

      # pad to both directions, so need to devide by 2
      @entry.grid(ipadx: new_width / 2.0)
    end
  end

  class FormElement
    extend VirtualMethods

    def initialize(id: nil)
      @id = id
    end

    virtual def matrix() end
    virtual def value() end
    virtual def value=() end
  end

  class FormEntry < FormElement
    attr_reader :id

    def initialize(parent, id: nil, value: '', label: nil)
      super(id: id)
      build(parent, value: value, label: label)
    end

    def build(parent, value: '', label: nil)
      (@label, labelframe) = create_label(parent, label)
      @entry = Entry.new(parent, labelframe)
      @entry.value = value unless value.empty?
      @entry.autoresize
    end

    def create_label(parent, options)
      case options
      in nil
        nil
      in String
        [Tk::Tile::Label.new(parent) { text options }, nil]
      in {type: :left, ** }
        [Tk::Tile::Label.new(parent) { text options[:text] }, nil]
      in {type: :frame, ** }
        [nil, Tk::Tile::Labelframe.new(parent) { text options[:text] }]
      end
    end

    def matrix
      return [@entry.frame, :right] unless @label

      [@label, @entry.frame]
    end

    def value
      @entry.value
    end

    def value=(value)
      @entry.value = value
    end
  end

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
