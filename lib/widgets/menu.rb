# frozen_string_literal: true

class TkWrapper::Widgets::Menu < TkWrapper::Widgets::Base::Widget
  def tk_class
    TkWidgets::TkMenu
  end

  def build(parent)
    super(parent)
    parent.tk_widget['menu'] = tk_widget
  end

  class Cascade < TkWrapper::Widgets::Base::Widget
    def tk_class
      TkWidgets::TkMenu
    end

    def build(parent)
      super(parent, configure: false)
      @config[:menu] = tk_widget
      parent.tk_widget.add :cascade, **@config.config
    end
  end

  class Command < TkWrapper::Widgets::Base::Widget
    def build(parent)
      parent.tk_widget.add :command, **@config.config
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
