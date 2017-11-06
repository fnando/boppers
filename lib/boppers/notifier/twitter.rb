# frozen_string_literal: true

module Boppers
  module Notifier
    class Twitter
      attr_reader :consumer_key, :consumer_secret,
                  :access_token, :access_secret, :user, :subscribe

      def initialize(consumer_key:, consumer_secret:, access_token:, access_secret:, user:, subscribe: nil)
        require "twitter"

        @consumer_key = consumer_key
        @consumer_secret = consumer_secret
        @access_token = access_token
        @access_secret = access_secret
        @user = user
        @subscribe = subscribe
      end

      def call(title, message, _options)
        client = ::Twitter::REST::Client.new do |config|
          config.consumer_key        = consumer_key
          config.consumer_secret     = consumer_secret
          config.access_token        = access_token
          config.access_token_secret = access_secret
        end

        body = "#{title}\n\n#{message}"

        client.create_direct_message(user, body)
      end
    end
  end
end
