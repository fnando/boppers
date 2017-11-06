# frozen_string_literal: true

module Boppers
  class Runner
    def boppers
      Boppers.configuration.boppers
    end

    def run_bopper(bopper)
      interval = if bopper.respond_to?(:interval)
                   bopper.interval
                 else
                   60
                 end

      Thread.new do
        loop do
          begin
            bopper.call
          rescue StandardError => error
            Boppers.configuration.handle_exception&.call(error)
          end

          sleep interval
        end
      end
    end

    def call
      threads = boppers.each_with_object([]) do |bopper, buffer|
        buffer << run_bopper(bopper)
      end

      threads.each(&:join)
    end
  end
end
