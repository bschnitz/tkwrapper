# frozen_string_literal: true

# wraps some code of Tk to make it more object oriented, provide new
# functionality and to ease usage
module TkWrapper
  require 'tk'
  require 'tkextlib/tile'
  require_relative './widget'

  class Menu < Widget
    def widget(parent)
      parent['menu'] = TkMenu.new(parent)
    end

    class Cascade < Widget
      def widget(parent)
        menu = TkMenu.new(parent)
        config = @config.merge({ menu: menu })
        parent.add :cascade, **config
        menu
      end
    end

    class Command < Widget
      def widget(parent)
        parent.add(:command, **@config) && nil
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
