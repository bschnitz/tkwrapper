# frozen_string_literal: true

require_relative './form_element'
require_relative '../elements/entry'

# wraps some code of Tk to make it more object oriented, provide new
# functionality and to ease usage
module TkWrapper
  require 'tk'
  require 'tkextlib/tile'

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
end
