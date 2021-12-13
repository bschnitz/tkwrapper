# frozen_string_literal: true

# manages widgets and their global configurations
class TkWrapper::Widgets::Base::Manager
  def initialize
    @configurations = []
    @modifications = []
  end

  def add_configurations(matcher = nil, configuration = nil, **configurations)
    add_configuration(matcher, configuration)

    configurations.each { |mat, cfg| add_configuration(mat, cfg) }
  end

  def add_configuration(matcher, configuration)
    return unless configuration

    @configurations.push([matcher, configuration])
  end

  def add_modification(matcher, &callback)
    @modifications.push([matcher, callback])
  end

  def configurations(widget)
    @configurations.filter_map do |(matcher, config)|
      config if widget.check_match(matcher)
    end
  end

  def execute_modifications(widget)
    @modifications.each do |(matcher, callback)|
      next unless (match = widget.check_match(matcher))

      arguments = match.is_a?(MatchData) ? [widget, match] : [widget]
      callback.call(*arguments)
    end
  end
end
