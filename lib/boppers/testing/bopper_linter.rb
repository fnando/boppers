# frozen_string_literal: true

module Boppers
  module Testing
    class BopperLinter
      extend Minitest::Assertions

      class << self
        attr_accessor :assertions
      end

      @assertions = 0

      def self.call(bopper)
        assert_respond_to(bopper, :call)
      end
    end
  end
end
