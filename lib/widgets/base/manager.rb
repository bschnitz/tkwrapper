# frozen_string_literal: true

# manages widgets and their global configurations
class TkWrapper::Widgets::Base::Manager
  def initialize
    @configuration_matchers = { regex: {}, map: {} }
    @modification_matchers = { regex: {}, map: {} }
  end

  def add_configurations(matcher = nil, config = nil, **configs)
    add_matcher(matcher, config, @configuration_matchers) if config

    configs.each { |mat, cfg| add_matcher(mat, cfg, @configuration_matchers) }
  end

  def add_modification(matcher, &callback)
    add_matcher(matcher, callback, @modification_matchers)
  end

  def configurations(widget)
    configs = find_matching_items(widget.ids, @configuration_matchers)
    configs.map { |config| config[0] }
  end

  def execute_modifications(widget)
    callbacks = find_matching_items(widget.ids, @modification_matchers)
    callbacks.each do |callback|
      callback, match = callback
      match ? callback.call(widget, match) : callback.call(widget)
    end
  end

  private

  def find_matching_items(keys, container)
    keys.each_with_object([]) do |key, items|
      items.concat(
        items_from_map(key, container),
        items_by_regex(key, container)
      )
    end
  end

  def items_from_map(key, container)
    (container[:map][key] || []).map { |item| [item, nil] } || []
  end

  def items_by_regex(key, container)
    container[:regex].each_with_object([]) do |(matcher, items), merged_items|
      match = matcher.match(key)
      merged_items.concat(items.map { |item| [item, match] }) if match
    end
  end

  def add_matcher(matcher, item, container)
    if matcher.is_a?(Regexp)
      (container[:regex][matcher] ||= []).push(item)
    else
      (container[:map][matcher] ||= []).push(item)
    end
  end
end
