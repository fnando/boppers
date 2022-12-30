![Boppers](https://github.com/fnando/boppers/raw/main/images/logo.png)

[![Gem](https://img.shields.io/gem/v/boppers.svg)](https://rubygems.org/gems/boppers)
[![Gem](https://img.shields.io/gem/dt/boppers.svg)](https://rubygems.org/gems/boppers)

# Installation

Add this line to your application's Gemfile:

```ruby
gem "boppers"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install boppers

# Usage

## Using the CLI

To create a new app, use `boppers app [YOUR APP NAME]`. This will generate a
structure so you can just configure your boppers and notifiers.

## Boppers

A bopper is a bot. Basically is a class that responds to `#call`. For instance,
a lambda.

```ruby
Boppers.configure do |config|
  config.boppers << lambda do
    Boppers.notify(:clock, title: "Clock", message: "Now is #{Time.now}")
  end
end
```

By default, boppers are executed every 60 seconds. If you create a class, you
can define your custom interval by creating a method `#interval`. The following
example changes the interval to `15 seconds`.

```ruby
class Clock
  def call
    Boppers.notify(:clock, title: "Clock", message: "Now is #{Time.now}")
  end

  def interval
    15
  end
end

Boppers.configure do |config|
  config.boppers << Clock.new
end
```

The `Boppers.notify(event_name, title: message: options: {})` method expects a
event name (the recommended value is the bot's name), a title, message and a
hash of options (it's up to the notifier to use the options).

### Distributing boppers

I encourage you to share your boppers. I even added a command to generate a
common structure, so you don't have to think about how to organize it. Let's say
you want to distribute the clock bopper above.

```
$ boppers plugin clock --type bopper
      create  boppers-clock.gemspec
      create  gems.rb
      create  .gitignore
      create  .rubocop.yml
      create  .travis.yml
      create  CODE_OF_CONDUCT.md
      ...
```

Now add your bopper code to `lib/boppers/clock.rb`.

```ruby
# frozen_string_literal: true

require "boppers/clock/version"

module Boppers
  class Clock
    def call
      Boppers.notify(
        :clock,
        title: "Clock",
        message: "Now is #{Time.now}"
      )
    end
  end
end
```

Change the `boppers-clock.gemspec` file accordingly (add a description, author
name and email).

If you're writing tests, use `Boppers::Testing::BopperLinter` to lint your
bopper (some basic validations will be made).

```ruby
# frozen_string_literal: true

require "test_helper"

class BoppersClockTest < Minitest::Test
  test "lint bopper" do
    bopper = Boppers::Clock.new
    Boppers::Testing::BopperLinter.call(bopper)
  end
end
```

Then make a commit and run `rake release` to distribute it (I'm assuming your
Rubygems account is already configured).

## Notifiers

A notifier is basically a class that responds to
`#call(title, message, options)`. The following example implements a `stderr`
notifier.

```ruby
class Stderr
  attr_reader :subscribe

  def initialize(subscribe: nil)
    @subscribe = subscribe
  end

  def call(title, message, _options)
    $stderr << "== #{title}\n"
    $stderr << message.gsub(/^/m, "   ")
    $stderr << "\n\n"
  end
end

Boppers.configure do |config|
  config.notifiers << Stderr.new
end
```

You can specify which messages a notifier will receive by setting `subscribe:`,
like the following:

```ruby
Boppers.configure do |config|
  config.notifiers << Stderr.new(subscribe: %i[clock])
end
```

Now this notifier will only be triggered when `Boppers.notify(:clock, **kargs)`
is called, ignoring other boppers.

### Distributing notifiers

The idea is pretty much the same as creating a bopper. Use the command
`boppers plugin [NAME] --type notifier` to generate a file structure. Then
configure the plugin accordingly. There's a a linter for notifiers:
`Boppers::Testing::NotifierLinter`.

### Available notifiers

By default, Boppers comes with the following notifiers.

- [Hipchat](https://www.hipchat.com/sign_in)
- [Pushover](https://pushover.net)
- [Sendgrid](https://sendgrid.com)
- [Slack](https://slack.com)
- stdout
- [Telegram](https://telegram.org)
- [Twitter](https://twitter.com)

#### Hipchat

1. Create a "Send Notification" room API token at
   `https://[SUBDOMAIN].hipchat.com/rooms`.
2. The room id is available at the "Summary" section as "API ID".

```ruby
Boppers.configure do |config|
  config.notifiers << Boppers::Notifier::Hipchat.new(
    api_token: "API_TOKEN,
    room: "ROOM"
  )
end
```

#### Pushover

```ruby
Boppers.configure do |config|
  config.notifiers << Boppers::Notifier::Pushover.new(
    app_token: "APP_TOKEN",
    user_token: "USER_TOKEN"
  )
end
```

#### Slack

1. Create a new bot user at https://my.slack.com/services/new/bot
2. Set the API token as the `api_token:`.
3. Set the channel as the `channel:`.

```ruby
Boppers.configure do |config|
  config.notifiers << Boppers::Notifier::Slack.new(
    api_token: "API_TOKEN",
    channel: "#core"
  )
end
```

#### Sendgrid

```ruby
Boppers.configure do |config|
  config.notifiers << Boppers::Notifier::Sendgrid.new(
    username: "USERNAME",
    password: "PASSWORD",
    domain: "DOMAIN",
    email: "your@email.com"
  )
end
```

#### Stdout

```ruby
Boppers.configure do |config|
  config.notifiers << Boppers::Notifier::Stdout.new
end
```

#### Telegram

1. [Create a bot](https://core.telegram.org/bots#6-botfather). The returned API
   token must be defined as `api_token:`.
2. Send a message to the bot.
3. Run `ruby setup/telegram.rb` locally to get the channel id. You may need to
   install the dependencies with `bundle install` before doing it so.
4. Set the channel as `channel_id: <channel id>`. Sometimes id can be a negative
   number and this is important.

```ruby
Boppers.configure do |config|
  config.notifiers << Boppers::Notifer::Telegram.new(
    api_token: "API_TOKEN",
    channel_id: "CHANNEL_ID"
  )
end
```

You can run `boppers setup telegram`, which will basically guide like those
steps above. No tokens will be saved locally or remotely in any form.

#### Twitter

1. Create an user for your bot.
2. Follow your bot, and make your bot follow you.
3. Create a new Twitter application under your bot's account at
   https://apps.twitter.com/app/new
4. Go to "Keys and Access Tokens" and create a new access token.
5. Set `consumer_key:`, `consumer_secret:`, `access_token:` and `access_secret:`
   named arguments, all available under "Keys and Access Token".
6. Set the user that'll receive the notification as `user: <username>`.

```ruby
Boppers.configure do |config|
  config.notifiers << Boppers::Notifer::Twitter.new(
    consumer_key: "CONSUMER_KEY",
    consumer_secret: "CONSUMER_SECRET",
    access_token: "ACCESS_TOKEN",
    access_secret: "ACCESS_SECRET",
    user: "someuser"
  )
end
```

## Deploying to Heroku

I'm assuming you installed the gem with `gem install boppers` and generated your
app.

Add your configuration to `config/boppers.rb`. Also make sure you don't hardcode
any sensitive value, like API tokens or passwords. Use
[superconfig](https://rubygems.org/gems/superconfig) to manage access to your
environment variables.

Now, configure Heroku. Create a new app for this.

```
heroku create
```

If you're going to send e-mail notification, you'll need Sendgrid.

```
heroku addons:create sendgrid:starter
```

You also need to set the buildpack:

```
heroku buildpacks:set heroku/ruby
```

Make a commit and deploy to your Heroku account.

```
git add .
git commit -m "Initial commit"
git push heroku main
```

Scale up the boppers worker:

```
heroku ps:scale worker=1
```

To make your worker run 24/7 (will cost you $7/month):

```
heroku dyno:type worker=hobby
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake test` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/fnando/boppers. This project is intended to be a safe,
welcoming space for collaboration, and contributors are expected to adhere to
the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Boppers project’s codebases, issue trackers, chat
rooms and mailing lists is expected to follow the
[code of conduct](https://github.com/fnando/boppers/blob/main/CODE_OF_CONDUCT.md).
