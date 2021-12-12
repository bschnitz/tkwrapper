# frozen_string_literal: true

module Util
  def self.merge_recursive!(*hashes)
    hashes[0].merge!(*hashes[1..]) do |_key, old, new|
      if old.is_a?(Hash) && new.is_a?(Hash)
        merge_recursive!(old, new)
      else
        new
      end
    end
  end

  def self.each_recursive(hash, &block)
    hash.each do |key, value|
      next block.call(hash, key, value) unless value.is_a?(Hash)

      block.call(hash, key, each_recursive(value, &block))
    end
  end

  def self.recursive_transform_key_value!(hash, &block)
    hash.transform_keys! do |key|
      value = hash[key]
      next recursive_transform_key_value!(value, &block) if value.is_a?(Hash)

      block.call(key, value)
    end
  end
end
