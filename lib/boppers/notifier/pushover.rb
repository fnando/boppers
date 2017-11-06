# frozen_string_literal: true

module Boppers
  module Notifier
    class Pushover
      ENDPOINT = "https://api.pushover.net/1/messages.json"

      attr_reader :app_token, :user_token, :subscribe

      def initialize(app_token:, user_token:, subscribe: nil)
        @app_token = app_token
        @user_token = user_token
        @subscribe = subscribe
      end

      def call(title, message, _options)
        HttpClient.post(
          ENDPOINT,
          token: app_token,
          user: user_token,
          title: title,
          message: message
        )
      end
    end
  end
end
