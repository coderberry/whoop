module Whoop
  class Tracer
    class << self
      # Trace the execution of a block
      # @param [Array<Symbol>] trace_events - The trace events to listen for
      # @yield The code block to be executed and traced
      # @return [TraceResponse] The trace response
      #
      # @example Tracing a block of code
      #   Whoop::Tracer.trace("Debug trace") do
      #     foo = "foo"
      #     bar = "bar"
      #     baz = "baz"
      #   end
      def start_trace(trace_events = [], &block)
        raise ArgumentError, "block not given" unless block_given?

        response = TraceResponse.new
        trace = TracePoint.new(*trace_events) do |tp|
          response.traced_events << [description, tp, tp.path, tp.lineno]
        end

        trace.enable
        response.results = yield block
        trace.disable

        response
      end
    end
  end
end
