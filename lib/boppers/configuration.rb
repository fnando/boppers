# frozen_string_literal: true

module Boppers
  class Configuration
    attr_accessor :handle_exception

    def boppers
      @boppers ||= []
    end

    def notifiers
      @notifiers ||= []
    end
  end
end
