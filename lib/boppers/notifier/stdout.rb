# frozen_string_literal: true

module Boppers
  module Notifier
    class Stdout
      COLORS = {
        green: "\e[32m",
        red: "\e[31m"
      }.freeze

      attr_reader :subscribe

      def initialize(subscribe: nil)
        @subscribe = subscribe
      end

      def call(title, message, options)
        color = COLORS.fetch(options[:color], "\e[0m")

        puts [
          "#{color}## #{title}",
          message.gsub(/^/m, "   "),
          "\e[0m\n"
        ].join("\n")
      end
    end
  end
end
