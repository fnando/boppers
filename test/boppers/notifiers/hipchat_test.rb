# frozen_string_literal: true

require "test_helper"
require "boppers/notifier/hipchat"

class HipchatTest < Minitest::Test
  let(:params) do
    {api_token: "API_TOKEN", room: "ROOM"}
  end

  test "lint notifier" do
    notifier = Boppers::Notifier::Hipchat.new(**params)
    Boppers::Testing::NotifierLinter.call(notifier)
  end
end
