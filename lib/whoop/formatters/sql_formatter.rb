# frozen_string_literal: true

require "anbt-sql-formatter/formatter"

module Whoop
  module Formatters
    module SqlFormatter
      # Format the SQL query
      # @param [String] sql The SQL query
      # @param [Boolean] colorize - colorize the SQL query (default: false)
      # @param [Boolean] explain - also run `EXPLAIN` on the query (default: false)
      # @return [String] The formatted SQL query
      def self.format(sql, colorize: false, explain: false)
        pretty_sql = generate_pretty_sql(sql)
        return pretty_sql unless colorize

        formatter = Rouge::Formatters::TerminalTruecolor.new
        lexer = Rouge::Lexers::SQL.new
        formatter.format(lexer.lex(pretty_sql))
      end

      def self.generate_pretty_sql(sql)
        rule = AnbtSql::Rule.new
        rule.indent_string = "  "
        formatter = AnbtSql::Formatter.new(rule)
        formatter.format(sql.dup)
      end
    end
  end
end
