# frozen_string_literal: true

module Boppers
  module Testing
    class NotifierLinter
      extend Minitest::Assertions

      class << self
        attr_accessor :assertions
      end

      @assertions = 0

      def self.call(notifier)
        assert_respond_to(notifier, :call)
        assert_initialize_method(notifier)
        assert_call_method(notifier)
      end

      def self.assert_initialize_method(notifier)
        message =
          "Notifier must implement #{notifier.class}.new(subscribe: nil)"
        initialize_method = notifier.method(:initialize)
        assert_includes initialize_method.parameters, %i[key subscribe], message
      end

      def self.assert_call_method(notifier)
        message =
          "Notifier must implement #{notifier.class}#call" \
          "(title, message, options)"
        call_method = notifier.method(:call)
        assert_equal 3, call_method.parameters.size, message
      end
    end
  end
end
