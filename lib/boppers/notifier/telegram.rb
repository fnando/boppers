# frozen_string_literal: true

module Boppers
  module Notifier
    class Telegram
      attr_reader :api_token, :channel_id, :subscribe

      def initialize(api_token:, channel_id:, subscribe: nil)
        @api_token = api_token
        @channel_id = channel_id
        @subscribe = subscribe
      end

      def call(title, message, options)
        context = self
        telegram_options = options.fetch(:telegram, {})
        title = telegram_options.delete(:title) { title }
        message = telegram_options.delete(:message) { message }

        telegram_options[:text] = "#{title}\n\n#{message}"
        telegram_options[:chat_id] = channel_id

        HttpClient.post do
          url "https://api.telegram.org/bot#{context.api_token}/sendMessage"
          params telegram_options
          options expect: 200
        end
      end
    end
  end
end
