# frozen_string_literal: true

require "json"

module Whoop
  class Tracer
    class << self
      # Trace the execution of a block
      # @param io [StringIO] The string to write the results to
      # @param trace_events [Array<Symbol>] The trace events to listen for
      # @return [Array<Hash>] The trace response
      def start_trace(io, trace_events = [], &block)
        raise ArgumentError, "block not given" unless block

        trace = TracePoint.new(*trace_events) do |tp|
          io.puts({
            path: tp.path,
            lineno: tp.lineno,
            event: tp.event,
            method_id: tp.method_id
          }.to_json)
        end

        result = begin
          trace.enable
          yield block
          trace.disable
        end

        [result, io.string]

        # io.string.split(/\n/).map { |str| JSON.parse(str) }
      end
    end
  end
end