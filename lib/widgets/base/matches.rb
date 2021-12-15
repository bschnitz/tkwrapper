require_relative 'match'

# matches widgets against conditions and stores matching widgets and matches
class TkWrapper::Widgets::Base::Matches
  include Enumerable

  def initialize
    @matches = {}
  end

  def add(matches)
    (matches.is_a?(Array) ? matches : [matches]).each do |match|
      (@matches[match.key] ||= []).push(match) if match
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
end
