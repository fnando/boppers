# frozen_string_literal: true

module Setup
  def self.call(shell)
    require "aitch"

    $stdout << "== Configuring a Telegram notifier\n\n"
    $stdout << "1. Create a new bot. Visit https://telegram.me/botfather.\n"
    $stdout << "2. Send a message to your bot.\n\n"
    $stdout << "Hit ENTER to continue..."

    $stdin.gets

    $stdout << "\n"

    $stdout << "What's your Telegram bot token? "
    bot_token = $stdin.gets.chomp

    response = Aitch.get("https://api.telegram.org/bot#{bot_token}/getUpdates")

    unless response.ok?
      message = "ERROR: Invalid bot token"
      shell.error shell.set_color(message, :red)
      exit 1
    end

    payload = response
              .data["result"]
              .sort_by {|result| result["update_id"] }
              .last

    unless payload
      message = "ERROR: No messages found."
      shell.error shell.set_color(message, :red)
      exit 1
    end

    channel_id = payload.dig("message", "chat", "id")
    message = "SUCCESS: The channel id is #{channel_id}"
    shell.say shell.set_color(message, :green)
  end
end
