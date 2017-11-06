# frozen_string_literal: true

require "test_helper"
require "boppers/notifier/pushover"

class PushoverTest < Minitest::Test
  let(:params) do
    {app_token: "APP_TOKEN", user_token: "USER_TOKEN"}
  end

  test "lint notifier" do
    notifier = Boppers::Notifier::Pushover.new(**params)
    Boppers::Testing::NotifierLinter.call(notifier)
  end
end
