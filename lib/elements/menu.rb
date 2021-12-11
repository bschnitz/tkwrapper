# frozen_string_literal: true

# wraps some code of Tk to make it more object oriented, provide new
# functionality and to ease usage
module TkWrapper
  require_relative './widget'

  class Menu < Widget
    def tk_class
      TkWidgets::TkMenu
    end

    def build(parent)
      super(parent)
      parent.tk_widget['menu'] = tk_widget
    end

    class Cascade < Widget
      def tk_class
        TkWidgets::TkMenu
      end

      def build(parent)
        super(parent, configure: false)
        config = @config.merge({ menu: tk_widget })
        parent.tk_widget.add :cascade, **config
      end
    end

    class Command < Widget
      def build(parent)
        parent.tk_widget.add :command, **@config
      end
    end

    def self.create(structure: [], config: {})
      Menu.new(
        config: config,
        childs: structure.map { |entry| create_subentry(entry) }
      )
    end

    def self.create_subentries(structure)
      return [] unless structure && !structure.nil?

      structure = [structure] unless structure.is_a?(Array)
      structure.map { |entry| create_subentry(**entry) }
    end

    def self.create_subentry(entry)
      case entry
      in { config: config, structure: structure }
        return Cascade.new config: config, childs: create_subentries(structure)
      else
        return Command.new config: entry
      end
    end
  end
end
