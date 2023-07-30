# frozen_string_literal: true

require "amazing_print"

module Whoop
  module Formatters
    module TraceFormatter
      # @param [TraceResponse] response The results of the trace
      # @return [String] The formatted message
      def self.format(trace_response)
        json = trace_response.traced_events.map do |description, tp, path, lineno|
          [
            "#{description}:".colorize(:light_black),
            "#{tp.event} on #{path}:#{lineno}".colorize(:light_black)
          ].join(" ")
        end

        JsonFormatter.format(json)
      end
    end
  end
end
