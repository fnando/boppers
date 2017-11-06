# frozen_string_literal: true

module Boppers
  HttpClient = Aitch::Namespace.new

  HttpClient.configure do |config|
    config.user_agent = "Boppers/#{VERSION} (https://github.com/fnando/boppers)"
  end
end
