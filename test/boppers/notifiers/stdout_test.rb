# frozen_string_literal: true

require "test_helper"
require "boppers/notifier/stdout"

class StdoutTest < Minitest::Test
  test "lint notifier" do
    notifier = Boppers::Notifier::Stdout.new
    Boppers::Testing::NotifierLinter.call(notifier)
  end
end
