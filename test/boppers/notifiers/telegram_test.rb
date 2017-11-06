# frozen_string_literal: true

require "test_helper"
require "boppers/notifier/telegram"

class TelegramTest < Minitest::Test
  let(:params) do
    {api_token: "API_TOKEN", channel_id: "CHANNEL_ID"}
  end

  test "lint notifier" do
    notifier = Boppers::Notifier::Telegram.new(**params)
    Boppers::Testing::NotifierLinter.call(notifier)
  end
end
