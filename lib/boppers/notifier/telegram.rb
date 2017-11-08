# frozen_string_literal: true

module Boppers
  module Notifier
    class Telegram
      attr_reader :api_token, :channel_id, :subscribe

      def initialize(api_token:, channel_id:, subscribe: nil)
        require "telegram_bot"

        @api_token = api_token
        @channel_id = channel_id
        @subscribe = subscribe
      end

      def call(title, message, options)
        telegram_options = options.fetch(:telegram, {})
        title = telegram_options.delete(:title) { title }
        message = telegram_options.delete(:message) { message }

        bot = TelegramBot.new(token: api_token)
        notification = TelegramBot::OutMessage.new
        notification.chat = TelegramBot::Channel.new(id: channel_id)
        notification.text = "#{title}\n\n#{message}"

        telegram_options.each do |key, value|
          notification.public_send("#{key}=", value)
        end

        notification.send_with(bot)
      end
    end
  end
end
