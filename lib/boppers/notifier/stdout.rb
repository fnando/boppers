# frozen_string_literal: true

module Boppers
  module Notifier
    class Stdout
      COLORS = {
        green: "\e[32m",
        red: "\e[31m"
      }.freeze

      NO_COLOR = "\e[0m"

      attr_reader :subscribe

      def initialize(subscribe: nil)
        @subscribe = subscribe
      end

      def call(title, message, options)
        color = COLORS.fetch(options[:color], NO_COLOR)
        message = message
                  .gsub(/^/m, "   ")
                  .lines
                  .map {|line| "#{color}#{line}#{NO_COLOR}" }
                  .join

        puts [
          "#{color}## #{title}#{NO_COLOR}",
          message,
          "\n"
        ].join("\n")
      end
    end
  end
end
