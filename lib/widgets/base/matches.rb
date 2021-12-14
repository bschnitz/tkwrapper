require_relative 'match'

# matches widgets against conditions and stores matching widgets and matches
class TkWrapper::Widgets::Base::Matches
  include Enumerable

  def initialize
    @matches = {}
  end

  def add_with_multiple_matchers(widget, matchers)
    matchers.each do |matcher|
      add(widget, matcher)
    end
  end

  def add(widget, matcher)
    case matcher
    when Regexp         then add_by_regex_on_id(widget, matcher)
    when String, Symbol then add_by_equality_on_id(widget, matcher)
    when nil            then add_for_key(nil, widget, nil)
    when Class          then add_by_equality_on_class(widget, matcher)
    else                     false
    end
  end

  def each(&block)
    @matches.each do |(key, matches_for_key)|
      matches_for_key.each do |match|
        block.call([match.widget, key, match.match])
      end
    end
  end

  def [](key)
    case @matches[key].size
    when 0 then nil
    when 1 then @matches[key][0]
    else        @matches[key]
    end
  end

  private

  def add_by_equality_on_class(widget, matcher)
    return false unless widget.is_a?(matcher)

    add_for_key(matcher.name, widget, matcher.name)
  end

  def add_by_regex_on_id(widget, matcher)
    widget.ids.reduce(false) do |matches, id|
      if (match = matcher.match(id))
        add_for_key(match[0], widget, match)
      else
        matches || false
      end
    end
  end

  def add_by_equality_on_id(widget, key)
    widget.ids.each do |id|
      return add_for_key(key, widget, key) if id == key
    end
    false
  end

  def add_for_key(key, widget, match)
    match = TkWrapper::Widgets::Base::Match.new(key, widget, match)
    (@matches[key] ||= []).push(match) || true
  end
end
