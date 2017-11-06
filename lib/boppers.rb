# frozen_string_literal: true

module Boppers
  require "thor"
  require "aitch"

  require "boppers/version"
  require "boppers/cli"
  require "boppers/configuration"
  require "boppers/http_client"
  require "boppers/runner"

  def self.configure
    yield configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  # Send notification.
  # The `name` identifies the message type, which is used to
  # filter out the notifications and their subscribers.
  def self.notify(name, title:, message:, options: {})
    configuration
      .notifiers
      .select {|notifier| subscribed?(notifier, name) }
      .each do |notifier|
        notifier.call(title, message, options)
      end
  end

  def self.subscribed?(notifier, name)
    subscriptions = [notifier.subscribe] if notifier.respond_to?(:subscribe)
    subscriptions ||= [name]
    subscriptions = subscriptions.flatten.map(&:to_sym)

    subscriptions.include?(name)
  end
end
