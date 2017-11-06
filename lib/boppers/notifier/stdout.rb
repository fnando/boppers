# frozen_string_literal: true

module Boppers
  module Notifier
    class Stdout
      attr_reader :subscribe

      def initialize(subscribe: nil)
        @subscribe = subscribe
      end

      def call(title, message, *)
        puts [
          "## #{title}",
          message.gsub(/^/m, "   "),
          "\n"
        ].join("\n")
      end
    end
  end
end
