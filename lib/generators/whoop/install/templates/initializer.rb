# frozen_string_literal: true

Whoop.setup do |config|
  config.logger = ActiveSupport::Logger.new("log/debug.log")
  # config.logger = ActiveSupport::Logger.new("log/#{Rails.env}.log")
  # config.logger = ActiveSupport::Logger.new($stdout)
  # config.logger = nil # uses `puts`

  config.level = :debug
  # config.level = :info
  # config.level = :warn
  # config.level = :error
end
