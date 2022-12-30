# frozen_string_literal: true

module Boppers
  class Runner
    def initialize
      @stop = false
    end

    def stop?
      @stop
    end

    def stop!
      @stop = true
    end

    def boppers
      Boppers.configuration.boppers
    end

    def default_interval
      60
    end

    def run_bopper(bopper)
      interval = if bopper.respond_to?(:interval)
                   bopper.interval
                 else
                   default_interval
                 end

      interval = interval.to_i
      interval = default_interval if interval.zero?

      Thread.new do
        elapsed_time = 0

        loop do
          break if stop?

          begin
            bopper.call if elapsed_time.zero?
          rescue StandardError => error
            Boppers.configuration.handle_exception&.call(error)
          end

          elapsed_time += 1

          sleep 1

          elapsed_time = 0 if elapsed_time == interval
        end
      end
    end

    def call
      trap("SIGINT") { stop! }

      threads = boppers.each_with_object([]) do |bopper, buffer|
        buffer << run_bopper(bopper)
      end

      threads.each(&:join)
    end
  end
end
