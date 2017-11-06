# frozen_string_literal: true

require "test_helper"
require "boppers/notifier/sendgrid"

class SendgridTest < Minitest::Test
  let(:params) do
    {
      username: "USERNAME",
      password: "PASSWORD",
      domain: "DOMAIN",
      email: "EMAIL"
    }
  end

  test "lint notifier" do
    notifier = Boppers::Notifier::Sendgrid.new(**params)
    Boppers::Testing::NotifierLinter.call(notifier)
  end
end
