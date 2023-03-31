# frozen_string_literal: true

require "anbt-sql-formatter/formatter"
require "active_record"

module Whoop
  module Formatters
    module SqlFormatter
      TOKENS_TO_PRESERVE = ['::', '->>', '->' , '#>>', '#>']

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

        formatted_sql = formatter.format(lexer.lex(pretty_sql))
        return formatted_sql unless explain

        raw_explain = exec_explain(sql)
        formatted_explain = formatter.format(lexer.lex(raw_explain))

        [
          "sql:\n\n".colorize(:light_black).underline,
          formatted_sql,
          "\n\n",
          "query plan:\n\n".colorize(:light_black).underline,
          formatted_explain
        ].join
      end

      # Generate a pretty SQL query
      # @param [String] sql The SQL query
      # @return [String] The formatted SQL query
      def self.generate_pretty_sql(sql)
        rule = AnbtSql::Rule.new
        rule.indent_string = "  "

        formatter = AnbtSql::Formatter.new(rule)
        formatted_string = formatter.format(sql.dup)

        # Anbt injects additional spaces into joined symbols.
        # This removes them by generating the "broken" collection
        # of symbols, and replacing them with the original.
        TOKENS_TO_PRESERVE.each do |token|
          token_with_whitespace = inject_whitespace_into(token)
          next unless formatted_string.include?(token_with_whitespace)

          formatted_string.gsub!(token_with_whitespace, token)
        end

        formatted_string
      end

      # Execute the `EXPLAIN` query
      # @param [String] sql The SQL query
      # @return [String] The formatted query plan
      def self.exec_explain(sql)
        result = ActiveRecord::Base.connection.exec_query("EXPLAIN #{sql}")
        lines = result.rows.map(&:first)

        pretty_explain = []
        pretty_explain += lines.map { |line| " #{line}" }
        nrows = result.rows.length
        rows_label = nrows == 1 ? "row" : "rows"
        pretty_explain << "\n(#{nrows} #{rows_label})"

        pretty_explain.join("\n")
      end

      # Adds whitespace to tokens so they match the incorrect format
      # @params [String] token The token to inject whitespace into, ie "->>"
      # @return [String] The token with additional whitespace, ie "- > >"
      def self.inject_whitespace_into(token)
        # Inject whitespace to match the (broken) format
        token_with_whitespace = token.chars.join(" ")

        # :: is a special case where it needs to strip surrounding whitespace too
        return token_with_whitespace unless token == '::'

        " #{token_with_whitespace} "
      end
    end
  end
end
