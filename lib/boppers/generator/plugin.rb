# frozen_string_literal: true

module Boppers
  module Generator
    class Plugin < Thor::Group
      include Thor::Actions

      attr_accessor :plugin_type

      desc "Generate a new Boopers plugin structure"

      def self.source_root
        File.join(__dir__, "plugin")
      end

      def copy_files
        template "#{plugin_type}/gemspec.erb", "#{plugin_name}.gemspec"
        copy_file "Gemfile"
        copy_file ".gitignore"
        copy_file ".rubocop.yml"
        copy_file "CODE_OF_CONDUCT.md"
        copy_file "LICENSE.txt"
        copy_file "Rakefile"
        template "#{plugin_type}/README.erb", "README.md"
      end

      def copy_lib_files
        template "#{plugin_type}/entry.erb",
                 "lib/#{plugin_name}.rb"

        template "#{plugin_type}/main.erb",
                 "lib/boppers/#{plugin_dir}#{name}.rb"

        template "#{plugin_type}/version.erb",
                 "lib/boppers/#{plugin_dir}#{name}/version.rb"
      end

      def copy_test_files
        template "test/test_helper.erb", "test/test_helper.rb"

        test_file_name = name.tr("-", "_")
        template "#{plugin_type}/test_file.erb",
                 "test/boppers/#{plugin_dir}#{test_file_name}_test.rb"
      end

      def run_commands
        inside destination_root do
          run "git init"
          run "bundle install"
        end
      end

      private

      def bopper?
        plugin_type == "bopper"
      end

      def plugin_name
        File.basename(destination_root)
      end

      def name
        plugin_name
          .gsub(/^boppers-/, "")
          .gsub(/-notifier$/, "")
      end

      def plugin_namespace
        name
          .tr("-", "_")
          .gsub(/_(.)/) { $1.upcase }
          .gsub(/^(.)/) { $1.upcase }
      end

      def plugin_dir
        "notifier/" unless bopper?
      end
    end
  end
end
