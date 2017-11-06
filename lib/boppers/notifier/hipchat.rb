# frozen_string_literal: true

module Boppers
  module Notifier
    class Hipchat
      attr_reader :api_token, :room

      def initialize(api_token:, room:, subscribe: nil)
        @api_token = api_token
        @room = room
        @subscribe = subscribe
      end

      def call(title, message, options)
        endpoint = "https://api.hipchat.com/v2/room/#{room}/notification"
        HttpClient.post(endpoint,
                        message_format: "text",
                        color: options.fetch(:color, "gray"),
                        notify: true,
                        message: message,
                        title: title,
                        auth_token: api_token)
      end
    end
  end
end
