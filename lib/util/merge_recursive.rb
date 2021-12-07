# frozen_string_literal: true

def merge_recursive!(*hashes)
  hashes[0].merge!(*hashes[1..]) do |_key, old, new|
    if old.is_a?(Hash) && new.is_a?(Hash)
      merge_recursive!(old, new)
    else
      new
    end
  end
end
