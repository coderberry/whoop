# frozen_string_literal: true

require "amazing_print"

module Whoop
  module Formatters
    module PrettyFormatter
      # Format the message using AwesomePrint
      # @param [String] message The object/class/message
      # @return [String] The formatted message
      def self.format(message)
        message.ai
      end
    end
  end
end
