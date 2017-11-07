# frozen_string_literal: true

module Boppers
  module Generator
    class App < Thor::Group
      include Thor::Actions

      desc "Generate a new app structure"

      def self.source_root
        File.join(__dir__, "app")
      end

      def copy_files
        copy_file "gems.rb"
        copy_file "Procfile"
        copy_file "config/boppers.rb"
        copy_file ".gitgnore"
        copy_file ".env"
      end

      def run_commands
        inside destination_root do
          run "git init"
          run "bundle install"
        end
      end
    end
  end
end
