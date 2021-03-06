# frozen_string_literal: true

module Util
  def self.merge_recursive!(*hashes, overwrite: true)
    hashes[0].merge!(*hashes[1..]) do |_key, old, new|
      if old.is_a?(Hash) && new.is_a?(Hash)
        merge_recursive!(old, new)
      else
        overwrite ? new : old
      end
    end
  end

  def self.each_recursive(hash, &block)
    hash.each do |key, value|
      next block.call(hash, key, value) unless value.is_a?(Hash)

      block.call(hash, key, each_recursive(value, &block))
    end
  end

  def self.clone_recursive(hash)
    hash.transform_values do |value|
      value.is_a?(Hash) ? clone_recursive(value) : value
    end
  end
end
