# frozen_string_literal: true

require_relative 'comparator_item_store'
require_relative 'widget_store'

class TkWrapper::Widgets::Base::Manager
  ComparatorItemStore = TkWrapper::Widgets::Base::ComparatorItemStore
  WidgetStore = TkWrapper::Widgets::Base::WidgetStore

  attr_reader :widgets

  def initialize
    @configurations = ComparatorItemStore.new
    @modifications = ComparatorItemStore.new
    @widgets = WidgetStore.new
  end

  def add_configurations(matcher = nil, configuration = nil, **configurations)
    add_configuration(matcher, configuration) if configuration

    configurations.each { |mat, cfg| add_configuration(mat, cfg) }
  end

  def add_configuration(comparator, configuration)
    @configurations.push(comparator, configuration)
  end

  def add_modification(matcher, &callback)
    @modifications.push(matcher, callback)
  end

  def configurations(widget)
    config_list = @configurations.items_and_matches_for_widget(widget)
    config_list.map { |configs| configs[:items] }.flatten(1)
  end

  def execute_modifications(widget)
    item_list = @modifications.items_and_matches_for_widget(widget)
    item_list.each do |items|
      items[:items].each do |callback|
        callback.call(widget, items[:match])
      end
    end
  end

  def configure(widget)
    widget.config.merge(*configurations(widget))
  end

  alias modify add_modification
  alias config add_configurations
end
