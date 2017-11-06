# frozen_string_literal: true

require "test_helper"
require "boppers/notifier/twitter"

class TwitterTest < Minitest::Test
  let(:params) do
    {
      consumer_key: "CONSUMER_KEY",
      consumer_secret: "CONSUMER_SECRET",
      access_token: "ACCESS_TOKEN",
      access_secret: "ACCESS_SECRET",
      user: "USER"
    }
  end

  test "lint notifier" do
    notifier = Boppers::Notifier::Twitter.new(**params)
    Boppers::Testing::NotifierLinter.call(notifier)
  end
end
