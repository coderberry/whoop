# frozen_string_literal: true

module Whoop
  module Generators
    class InstallGenerator < Rails::Generators::Base
      def set_source_paths
        @source_paths = [
          File.expand_path("templates", __dir__),
          File.expand_path("../../../..", __dir__)
        ]
      end

      def copy_initializer_file
        copy_file \
          "initializer.rb",
          "config/initializers/whoop.rb"
      end
    end
  end
end
