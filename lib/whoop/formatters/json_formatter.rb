# frozen_string_literal: true

require "json"

module Whoop
  module Formatters
    module JsonFormatter
      # Format the SQL query
      # @param [String] message The SQL query
      # @param [Boolean] colorize - colorize the SQL query (default: false)
      # @return [String] The formatted SQL query
      def self.format(message, colorize: false)
        pretty_json = JSON.pretty_generate(message)
        return pretty_json unless colorize

        formatter = Rouge::Formatters::TerminalTruecolor.new
        lexer = Rouge::Lexers::JSON.new
        formatter.format(lexer.lex(pretty_json))
      end
    end
  end
end
