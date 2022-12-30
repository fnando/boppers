# frozen_string_literal: true

module Boppers
  class CLI < Thor
    check_unknown_options!

    def self.exit_on_failure?
      true
    end

    desc "start [OPTIONS]", "Start Boppers' daemon"

    method_option :require,
                  type: :string,
                  desc: "File to require",
                  required: true

    def start
      require options[:require]
      Runner.new.call
    end

    desc "version", "Prints the Boppers version information"
    map %w[-v --version] => :version

    def version
      say "Boppers v#{VERSION}"
    end

    desc "plugin NAME", "Create a new plugin for Boppers"
    method_option :type,
                  type: :string,
                  desc: "The type of plugin. Can be either bopper or notifier.",
                  required: true

    def plugin(name)
      require "boppers/generator/plugin"

      unless %w[bopper notifier].include?(options[:type])
        message = "ERROR: --type needs to be either 'bopper' or 'notifier'"
        shell.error shell.set_color(message, :red)
        exit 1
      end

      suffix = "-notifier" if options[:type] == "notifier"
      base_path = File.dirname(File.expand_path(name))
      base_name = "boppers-#{File.basename(name)}#{suffix}"

      generator = Generator::Plugin.new
      generator.plugin_type = options[:type]
      generator.destination_root = File.join(base_path, base_name)
      generator.invoke_all
    end

    desc "app NAME", "Create a new app for Boppers"

    def app(name)
      require "boppers/generator/app"

      base_path = File.expand_path(name)

      generator = Generator::App.new
      generator.destination_root = base_path
      generator.invoke_all
    end

    desc "setup NAME", "Discover how to set up notifiers."

    def setup(name)
      file = File.expand_path("../../setup/#{name}.rb", __dir__)

      unless File.file?(file)
        message = "ERROR: invalid setup name."
        shell.error shell.set_color(message, :red)
        exit 1
      end

      require file
      Setup.call(shell)
    end
  end
end
