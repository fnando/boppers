# frozen_string_literal: true

module Boppers
  module Utils
    def self.symbolize_keys(hash)
      hash.each_with_object({}) do |(k, v), target|
        target[k.to_sym] = v
      end
    end
  end
end
