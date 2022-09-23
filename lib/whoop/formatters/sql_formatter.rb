# frozen_string_literal: true

require "anbt-sql-formatter/formatter"
require "active_record"

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
        formatter.format(sql.dup)
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
    end
  end
end
