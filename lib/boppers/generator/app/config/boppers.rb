# frozen_string_literal: true

require "bundler/setup"
Bundler.require

# Load the stdout notifier.
# Check https://github.com/fnando/boppers#notifiers for more
# information about notifiers.
require "boppers/notifier/stdout"

Config = Env::Vars.new do
  # mandatory :sendgrid_username, string
  # mandatory :sendgrid_password, string
  # mandatory :sendgrid_domain, string
end

Boppers.configure do |config|
  # Configure your notifiers.
  # A notifier is anything that responds to #call(title, message, options),
  # like a lambda. The following example sends the contents to stdout.
  config.notifiers << Boppers::Notifier::Stdout.new

  # This is how a custom lambda notifier looks like:
  # config.notifiers << lambda |title, message, _options| do
  #   puts "=> #{title}"
  #   puts "=> #{message}"
  # end

  # Retrieve configuration from `Config`, which fetches value from
  # environment variables.
  # config.notifiers << Boppers::Notifier::Sendgrid.new(
  #   username: Config.sendgrid_username,
  #   password: Config.sendgrid_password,
  #   domain: Config.sendgrid_domain,
  #   email: "your@email.com"
  # )

  # Handle exceptions. By default, any exception will be re-raised.
  # You can use this configuration to enable some error monitoring
  # service like Sentry.
  config.handle_exception = lambda do |exception|
    raise exception

    # If you're using an notification error like
    # Sentry, use something like this:
    # Raven.capture_exception(exception)
  end

  # Configure your boppers.
  # A bopper is anything that responds to #call, like a lambda.
  # The following example returns the current time.
  config.boppers << lambda do
    Boppers.notify("Current time", "Now is #{Time.now}")
  end

  # A bopper can also configure the polling interval by defining a
  # method `#interval`. If this method is not available, the default
  # value will be used (1-minute). The following example runs every second.
  #
  # class Counter
  #   def initialize
  #     @count = 0
  #   end
  #
  #   def interval
  #     1
  #   end
  #
  #   def call
  #     @count += 1
  #     Boppers.notify("Counter", "[#{Time.now}] Current count is #{@count}")
  #   end
  # end
  #
  # config.boppers << Counter.new

  # The following example uses https://rubygems.org/gems/boppers-uptime plugin.
  # config.boppers << Boppers::Uptime.new(
  #   url: "http://example.com",
  #   status: 200,
  #   min_failures: 2
  # )
end
