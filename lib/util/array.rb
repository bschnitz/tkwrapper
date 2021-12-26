# frozen_string_literal: true

module Util
  def self.first_not_nil(array, default = nil)
    index = indexes.find { |i| !array[i].nil? }
    index.nil? ? default : array[index]
  end
end
