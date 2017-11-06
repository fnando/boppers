# frozen_string_literal: true

require "test_helper"
require "boppers/notifier/slack"

class SlackTest < Minitest::Test
  let(:params) do
    {api_token: "API_TOKEN", channel: "CHANNEL"}
  end

  test "lint notifier" do
    notifier = Boppers::Notifier::Slack.new(**params)
    Boppers::Testing::NotifierLinter.call(notifier)
  end
end
