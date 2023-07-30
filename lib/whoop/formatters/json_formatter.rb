# frozen_string_literal: true

require "json"

module Whoop
  module Formatters
    module JsonFormatter
      # Format the JSON object
      # @param [String] message The JSON object
      # @param [Boolean] colorize - colorize the output
      # @return [String] The formatted JSON
      def self.format(message, colorize: false)
        pretty_json = JSON.pretty_generate(message)
        return pretty_json unless colorize

        formatter = Rouge::Formatters::TerminalTruecolor.new
        lexer = Rouge::Lexers::JSON.new

        [
          "json:\n\n".colorize(:light_black).underline,
          formatter.format(lexer.lex(pretty_json))
        ].join
      end
    end
  end
end
