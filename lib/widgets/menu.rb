# frozen_string_literal: true

require 'tk'

class TkWrapper::Widgets::Menu < TkWrapper::Widgets::Base::Widget
  def tk_class
    TkMenu
  end

  def build(parent, **args)
    super(parent, **args)
    parent.tk_widget['menu'] = tk_widget
  end

  class Cascade < TkWrapper::Widgets::Base::Widget
    def tk_class
      TkMenu
    end

    def build(parent, **args)
      args[:configure] = false
      super(parent, **args)
      @config[:menu] = tk_widget
      parent.tk_widget.add :cascade, **@config.config
    end
  end

  class Command < TkWrapper::Widgets::Base::Widget
    def build(parent, **args)
      args[:configure] = false
      super(parent, **args)
      parent.tk_widget.add :command, **@config.config
    end
  end

  def self.create(structure: [], config: {})
    new(
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
    in { config: config, structure: st }
      return Cascade.new config: config, childs: create_subentries(st)
    else
      return Command.new config: entry
    end
  end
end
