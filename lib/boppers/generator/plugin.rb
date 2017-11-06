# frozen_string_literal: true

module Boppers
  module Generator
    class Plugin < Thor::Group
      include Thor::Actions

      desc "Generate a new Boopers plugin structure"

      def self.source_root
        File.join(__dir__, "plugin")
      end

      def copy_files
        template "gemspec.erb", "#{plugin_name}.gemspec"
        copy_file "gems.rb"
        copy_file ".gitignore"
        copy_file ".rubocop.yml"
        copy_file ".travis.yml"
        copy_file "CODE_OF_CONDUCT.md"
        copy_file "LICENSE.txt"
        copy_file "Rakefile"
        template "README.erb", "README.md"
      end

      def copy_lib_files
        template "lib/entry.erb", "lib/#{plugin_name}.rb"
        template "lib/main.erb", "lib/boppers/#{name}.rb"
        template "lib/version.erb", "lib/boppers/#{name}/version.rb"
      end

      def copy_test_files
        template "test/test_helper.erb", "test/test_helper.rb"

        test_file_name = name.tr("-", "_")
        template "test/test_file.erb", "test/boppers/#{test_file_name}_test.rb"
      end

      def run_commands
        inside destination_root do
          run "git init"
          run "bundle install"
        end
      end

      private

      def plugin_name
        File.basename(destination_root)
      end

      def name
        plugin_name.gsub(/^boppers-/, "")
      end

      def plugin_namespace
        name
          .tr("-", "_")
          .gsub(/_(.)/) { $1.upcase }
          .gsub(/^(.)/) { $1.upcase }
      end
    end
  end
end
