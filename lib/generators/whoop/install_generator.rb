module Whoop
  class InstallGenerator < Rails::Generators::Base
    desc "This generator creates an initializer file for the Whoop gem at config/initializers/whoop.rb, with default recommended settings."

    class_option :level, type: :string, default: 'debug'

    def install
      @level = options['level']

      file_contents = <<~TEXT
      Whoop.setup do |config|
        config.logger = ActiveSupport::Logger.new("log/debug.log")
        # config.logger = ActiveSupport::Logger.new("log/\#{Rails.env}.log")
        # config.logger = ActiveSupport::Logger.new($stdout)
        # config.logger = nil # uses `puts`

        config.level = :#{@level}
        # config.level = :debug
        # config.level = :info
        # config.level = :warn
        # config.level = :error
      end
      TEXT

      create_file "config/initializers/whoop.rb", file_contents
    end
  end
end
