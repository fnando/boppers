# frozen_string_literal: true

module Boppers
  module Notifier
    class Slack
      COLORS = {
        green: "good",
        red: "danger"
      }.freeze

      attr_reader :api_token, :channel, :subscribe

      def initialize(api_token:, channel:, subscribe: nil)
        @api_token = api_token
        @channel = channel
        @subscribe = subscribe
      end

      def call(subject, message, options)
        params = {
          token: api_token,
          text: "",
          channel: channel,
          attachments: JSON.dump(
            [
              {
                fallback: message,
                title: subject,
                text: message,
                color: COLORS.fetch(options[:color])
              }
            ]
          )
        }

        HttpClient.post("https://slack.com/api/chat.postMessage", params)
      end
    end
  end
end
