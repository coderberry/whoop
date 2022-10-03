# frozen_string_literal: true

require "rails"

module Whoop
  class Engine < ::Rails::Engine
    isolate_namespace Whoop

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot, dir: "spec/factories"
      g.helper false
    end

    initializer "whoop", group: :all do |app|
      # check if Rails api mode
      if app.config.respond_to?(:assets)
        if defined?(Sprockets) && Sprockets::VERSION >= "4"
          app.config.assets.precompile << "whoop/application.js"
          app.config.assets.precompile << "whoop/application.css"
          app.config.assets.precompile << "whoop/favicon.png"
        else
          # use a proc instead of a string
          app.config.assets.precompile << proc { |path| path == "whoop/application.js" }
          app.config.assets.precompile << proc { |path| path == "whoop/application.css" }
          app.config.assets.precompile << proc { |path| path == "whoop/favicon.png" }
        end
      end
    end
  end
end
